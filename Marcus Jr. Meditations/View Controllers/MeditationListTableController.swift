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

class MeditationListTableController: UIViewController, UITableViewDataSource, UITableViewDelegate, NotificationsVC {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resetAllButton: UIButton!
    @IBOutlet weak var resetAllButtonHeight: NSLayoutConstraint!
    
    private var keysForSelectedEmotion: [String]?
    private var tableAlreadyLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight =  UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        if let emotion = SelectedEmotion.choice, let rawValue = Emotion.getRawValue(from: emotion) {
            title = "Daily Meditations - \(rawValue)"
        }
        
        if MeditationList.completedExercises.keys.count == 0 {
            MeditationList.retrieveMeditationListFromDisk()
        }
        
        resetAllButton.backgroundColor = UIColor(red: (247/255), green: (247/255), blue: (247/255), alpha: 1)
        showOrHideCompletedExerciseButton()
        tableView.layoutIfNeeded()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if tableAlreadyLoaded {
            tableView.reloadData() // if coming back in nav, check to see if any exercise completed.
            showOrHideCompletedExerciseButton()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setAsTopViewController()
        tableAlreadyLoaded = true
    }

    @IBAction func resetAllExercisesAbove(_ sender: UIButton) {
        
        if let emotion = SelectedEmotion.choice {
            getAllKeysOfEmotionIfNeeded(emotion: emotion) // almost certainly not needed since table would have appeared before this could be pressed, but there as a safeguard
            
            if let keysForSelectedEmotion = keysForSelectedEmotion {
                for (i, exerciseKey) in (MeditationListConfiguration.universalEmotionKeys + keysForSelectedEmotion).enumerated() {
                    let meditationTimes = MeditationTimes(emotion: emotion, exercise: exerciseKey) // hopefully not too expensive lookup, check...
                    
                    if meditationTimes.exerciseComplete {
                        
                        meditationTimes.resetCompletedExercise()
                        let indexPath = IndexPath(row: i, section: 0)
                        if let dailyMeditationCell = tableView.cellForRow(at: indexPath) as? DailyMeditationCell {
                            dailyMeditationCell.labelForDescription.textColor = .black
                        }
                    }
                    
                }
            }
        }
        
        showOrHideCompletedExerciseButton()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let emotion = SelectedEmotion.choice {
            
            getAllKeysOfEmotionIfNeeded(emotion: emotion)
            if let keysForSelectedEmotion = keysForSelectedEmotion {
                return keysForSelectedEmotion.count + MeditationListConfiguration.universalEmotionKeys.count
            }
        }
        
        return 0 // should never happen
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
            cell.labelForDescription.preferredMaxLayoutWidth = cell.bounds.width - 40
            
            return cell
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let keysForSelectedEmotion = keysForSelectedEmotion, indexPath.row < keysForSelectedEmotion.count + MeditationListConfiguration.universalEmotionKeys.count {
            let possibleKeys = MeditationListConfiguration.universalEmotionKeys + keysForSelectedEmotion
            let meditationKey = possibleKeys[indexPath.row]
            SelectedExercise.key = meditationKey
        }
        
        performSegue(withIdentifier: "toExercise", sender: self)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        tableView.layoutIfNeeded()
        tableView.reloadData()
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
    
    // combine to one func for this with other
    private func showOrHideCompletedExerciseButton() {
        guard let emotion = SelectedEmotion.choice else {
            return
        }
        
        getAllKeysOfEmotionIfNeeded(emotion: emotion)
        if let keysForSelectedEmotion = keysForSelectedEmotion {
            for exerciseKey in MeditationListConfiguration.universalEmotionKeys + keysForSelectedEmotion {
                if MeditationList.completedExercises[exerciseKey] == true {
                    resetAllButton.isHidden = false
                    resetAllButtonHeight.constant = 50
                    return
                }
            }
        }
        
        resetAllButton.isHidden = true
        resetAllButtonHeight.constant = 0
    }

}

