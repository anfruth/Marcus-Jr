//
//  MeditationListTableController.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/6/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import UIKit

protocol ExerciseSettable{
    func setExerciseKey(exerciseKey: String)
}

extension ExerciseSettable {
    func setExerciseKey(exerciseKey: String) {
        SelectedExercise.key = exerciseKey
    }
}

struct SelectedExercise {
    fileprivate(set) static var key: String?
}

class MeditationListTableController: UITableViewController, NotificationsVC {

    private var keysForSelectedEmotion: [String]?
    private var tableAlreadyLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight =  UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        if let emotion = SelectedEmotion.choice, let rawValue = Emotion.getRawValue(from: emotion) {
            title = "Daily Meditations - \(rawValue)"
        }
        
        if MeditationList.completedExercises.keys.count == 0 {
            MeditationList.retrieveMeditationListFromDisk()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if tableAlreadyLoaded {
            tableView.reloadData() // if coming back in nav, check to see if any exercise completed.
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setAsTopViewController()
        tableAlreadyLoaded = true
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let emotion = SelectedEmotion.choice {
            
            getAllKeysOfEmotionIfNeeded(emotion: emotion)
            if let keysForSelectedEmotion = keysForSelectedEmotion {
                return keysForSelectedEmotion.count + MeditationListConfiguration.universalEmotionKeys.count
            }
        }
        
        return 0 // should never happen
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "dailyMeditation", for: indexPath) as? DailyMeditationCell {
            
            if indexPath.row >= 4 && keysForSelectedEmotion == nil { // only get all indices if do not have, should be nil only once
                if let emotion = SelectedEmotion.choice {
                    getAllKeysOfEmotionIfNeeded(emotion: emotion)
                } else {
                    return UITableViewCell()
                }
            }
            
            var meditationKey = ""
            
            if let keysForSelectedEmotion = keysForSelectedEmotion, indexPath.row >= MeditationListConfiguration.universalEmotionKeys.count {
                meditationKey = keysForSelectedEmotion[indexPath.row - MeditationListConfiguration.universalEmotionKeys.count] // + 4 or whatever number of universals
            } else if indexPath.row < MeditationListConfiguration.universalEmotionKeys.count {
                meditationKey = MeditationListConfiguration.universalEmotionKeys[indexPath.row]
            }
            
            if MeditationList.completedExercises[meditationKey] == true { // need true explicitly because dict returns an optional
                cell.labelForDescription.textColor = UIColor.lightGray
            }
            
            cell.labelForDescription.text = NSLocalizedString(meditationKey, comment: "")
            
            return cell
        }

        return UITableViewCell()
    }
    
    private func getAllKeysOfEmotionIfNeeded(emotion: EmotionTypeEncompassing) {
        
        if let emotion = emotion as? NegativeEmotionType {
            if keysForSelectedEmotion != nil { return }
            keysForSelectedEmotion = MeditationListConfiguration.getOrderedMeditationsByEmotion(orderByEmotion: emotion)
            
        } else if let emotion = emotion as? PositiveEmotionType {
            if keysForSelectedEmotion != nil { return }
            keysForSelectedEmotion = MeditationListConfiguration.getOrderedMeditationsByEmotion(orderByEmotion: emotion)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let keysForSelectedEmotion = keysForSelectedEmotion, indexPath.row < keysForSelectedEmotion.count + MeditationListConfiguration.universalEmotionKeys.count {
            let possibleKeys = MeditationListConfiguration.universalEmotionKeys + keysForSelectedEmotion
            let meditationKey = possibleKeys[indexPath.row]
            SelectedExercise.key = meditationKey
        }
        
        performSegue(withIdentifier: "toExercise", sender: self)
    }


}

