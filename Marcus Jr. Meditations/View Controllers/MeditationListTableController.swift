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
    
    // MARK: - Table view data source
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setAsTopViewController()
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
        
        if let keysForSelectedEmotion = keysForSelectedEmotion, indexPath.row < keysForSelectedEmotion.count {
            let meditationKey = keysForSelectedEmotion[indexPath.row]
            SelectedExercise.key = meditationKey
        }
        
        performSegue(withIdentifier: "toExercise", sender: self)
    }


}

