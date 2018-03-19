//
//  DailyExerciseViewController.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/17/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.x
//

import UIKit

class DailyExerciseViewController: UITableViewController, NotificationsVC {

    @IBOutlet weak var selectNumTimesButton: UIButton!
    @IBOutlet weak var selectTimeButton: UIButton!
    @IBOutlet weak var exerciseTextView: UITextView!
    @IBOutlet weak var completedExerciseToolbar: UIToolbar!
    
    var meditationTimes: MeditationTimes?
    var alreadyShownVC: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let emotion = SelectedEmotion.choice, let exercise = SelectedExercise.key else {
            return
        }
        
        setExerciseAsCompleteIfNeeded()
        showOrHideCompletedExerciseButton()
        // important before MeditationTimes init, meditationTimes will reset the value in completedExercises, and wont be set back until MeditationTimesTableVC is loaded.
        
        meditationTimes = MeditationTimes(emotion: emotion, exercise: exercise)
        
        if let exerciseKey = SelectedExercise.key {
            title = NSLocalizedString(exerciseKey + "_title", comment: "title of exercise")
        }
        
        selectNumTimesButton.layer.cornerRadius = 30
        selectTimeButton.layer.cornerRadius = 30

        tableView.rowHeight =  UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        // _title, _quotation, _commentary, _action
        if let exerciseKey = SelectedExercise.key {
            
            if let standardExerciseFont =  UIFont(name: "SanFranciscoDisplay-Regular", size: 18) {
                let quotation = NSMutableAttributedString(string: "\n\"" + NSLocalizedString(exerciseKey + "_quotation", comment: "quotation of exercise") + "\"", attributes: [.font: standardExerciseFont])
                var commentary =  NSMutableAttributedString(string: "\n\n" + NSLocalizedString(exerciseKey + "_commentary", comment: "commentary on exercise"), attributes: [.font: standardExerciseFont])
                if commentary.string.trimmingCharacters(in: .whitespacesAndNewlines) == exerciseKey + "_commentary" {
                    commentary = NSMutableAttributedString(string: "")
                }
                let action = NSMutableAttributedString(string: "\n\n" + NSLocalizedString(exerciseKey + "_action", comment: "action on exercise") + "\n", attributes: [.font: standardExerciseFont])

                if let boldExerciseFont = UIFont(name: "SanFranciscoDisplay-Semibold", size: 18) {
                    var attributedCommentary: NSMutableAttributedString
                    if commentary.string != "" {
                        attributedCommentary = NSMutableAttributedString(string: "\n\nCommentary:", attributes: [.font: boldExerciseFont])
                    } else {
                        attributedCommentary = NSMutableAttributedString(string: "")
                    }
                    
                    let attributedAction = NSMutableAttributedString(string: "\n\nAction:", attributes: [.font: boldExerciseFont])
                    
                    quotation.append(attributedCommentary)
                    quotation.append(commentary)
                    quotation.append(attributedAction)
                    quotation.append(action)
                    
                    exerciseTextView.attributedText = quotation
                }
            }
        }
        
        setExerciseAsCompleteIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if alreadyShownVC {
            showOrHideCompletedExerciseButton()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        alreadyShownVC = true
        setAsTopViewController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toPickerVC" {
            setNeedsStatusBarAppearanceUpdate()
            let pickerVC = segue.destination
            if let pickerVC = pickerVC as? PickerViewController {
                pickerVC.meditationTimes = meditationTimes
                
                if let originalColor = navigationController?.navigationBar.tintColor {
                    pickerVC.originalButtonColor = originalColor
                }
                
                navigationController?.isNavigationBarHidden = true
            }
        } else if segue.identifier == "toMeditationTimes" {
            let meditationTimesController = segue.destination
            if let meditationTimesController = meditationTimesController as? MeditationTimesTableViewController {
                meditationTimesController.meditationTimes = meditationTimes
                if let meditationTimes = meditationTimes {
                    meditationTimes.delegate = meditationTimesController
                }
            }
        }
    }
    
    @IBAction func resetCompletedExercise(_ sender: UIBarButtonItem) {
        meditationTimes?.resetCompletedExercise()
        completedExerciseToolbar.isHidden = true
    }
    
    private func setExerciseAsCompleteIfNeeded() { // should be part of MeditationTimesModel
        guard let meditationTimes = meditationTimes else {
            return
        }
        
        for meditation in meditationTimes.timesSelected {
            if !meditation.completed {
                meditationTimes.exerciseComplete = false
                return
            }
        }
        
        meditationTimes.exerciseComplete = true
    }
    
    private func showOrHideCompletedExerciseButton() {
        guard let exercise = SelectedExercise.key else {
            return
        }
        
        if MeditationList.completedExercises[exercise] == true {
            completedExerciseToolbar.isHidden = false
        } else {
            completedExerciseToolbar.isHidden = true
        }
    }
    
}
