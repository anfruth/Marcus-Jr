//
//  DailyExerciseContainerViewController.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 3/18/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import UIKit

class DailyExerciseContainerViewController: UIViewController {

    @IBOutlet weak var heightOfExerciseButton: NSLayoutConstraint!
    @IBOutlet weak var resetCompletedExerciseButton: UIButton!
    @IBOutlet weak var resetExerciseFillerView: UIView!


    var meditationTimes: MeditationTimes?
    var alreadyShownVC: Bool = false
    
    private let exerciseTitleComment = "title of exercise"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let exerciseKey = SelectedExercise.key {
            title = NSLocalizedString(exerciseKey + "_title", comment: exerciseTitleComment)
        }

        let greyishColor =  UIColor(red: (247/255), green: (247/255), blue: (247/255), alpha: 1)
        resetCompletedExerciseButton.backgroundColor = greyishColor
        resetExerciseFillerView.backgroundColor = greyishColor
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedDaily" {
            guard let emotion = SelectedEmotion.choice, let exercise = SelectedExercise.key else {
                return
            }
            
            showOrHideCompletedExerciseButton()
            // important before MeditationTimes init, meditationTimes will reset the value in completedExercises, and wont be set back until MeditationTimesTableVC is loaded.
            
            meditationTimes = MeditationTimes(emotion: emotion, exercise: exercise)
            
            if let dailyExerciseVC = segue.destination as? DailyExerciseViewController {
                dailyExerciseVC.meditationTimes = meditationTimes
            }
        }
    }
    
    @IBAction func resetCompletedExercise(_ sender: UIButton) {
        meditationTimes?.resetCompletedExercise()
        showOrHideCompletedExerciseButton()
    }
    
    private func showOrHideCompletedExerciseButton() {
        guard let exercise = SelectedExercise.key else {
            return
        }
        
        if MeditationList.completedExercises[exercise] == true {
            resetCompletedExerciseButton.isHidden = false
            resetExerciseFillerView.isHidden = false
            heightOfExerciseButton.constant = 50
        } else {
            resetCompletedExerciseButton.isHidden = true
            resetExerciseFillerView.isHidden = true
            heightOfExerciseButton.constant = 0
        }
    }
}
