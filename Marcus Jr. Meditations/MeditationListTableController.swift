//
//  MeditationListTableController.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/6/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import UIKit

class MeditationListTableController: UITableViewController {

    private var indicesForEmotion: [Int]?
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "dailyMeditation", for: indexPath) as? DailyMeditationCell {
            
            if indicesForEmotion == nil {
                if let emotion = SelectedEmotion.choice {
                    
                    if let emotion = emotion as? Emotion.EmotionTypeGeneral {
                        indicesForEmotion = MeditationListConfiguration.getOrderedMeditationsByEmotion(orderByEmotion: emotion)
                    } else if let emotion = emotion as? NegativeEmotion.NegativeEmotionType {
                        indicesForEmotion = MeditationListConfiguration.getOrderedMeditationsByEmotion(orderByEmotion: emotion)
                    } else if let emotion = emotion as? PositiveEmotion.PositiveEmotionType {
                        indicesForEmotion = MeditationListConfiguration.getOrderedMeditationsByEmotion(orderByEmotion: emotion)
                    }
                    
                } else {
                    return UITableViewCell()
                }
            }
            
            let row = indexPath.row
            if let indicesForEmotion = indicesForEmotion, row < indicesForEmotion.count {
                let meditationTitleIndex = String(indicesForEmotion[row])
                cell.labelForDescription.text = NSLocalizedString(meditationTitleIndex, comment: "")
            }
            
            return cell
            
        }

        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toExercise", sender: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        indicesForEmotion = nil
    }

}

