//
//  DailyExerciseViewController.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/17/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.x
//

import UIKit
import UserNotifications

class DailyExerciseViewController: UITableViewController, NotificationsVC {

    @IBOutlet weak var selectNumTimesButton: UIButton!
    @IBOutlet weak var selectTimeButton: UIButton!
    @IBOutlet weak var exerciseTextView: UITextView!
    
    var meditationTimes: MeditationTimes?
    var alreadyShownVC: Bool = false
    
    private let standardFont = "SanFranciscoDisplay"
    private let meditationTimesSegueID = "toMeditationTimes"
    private let commentaryKey = "_commentary"
    private let quotationComment = "quotation of exercise"
    private let commentaryComment = "commentary on exercise"
    private let actionComment = "action on exercise"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectNumTimesButton.layer.cornerRadius = 30
        selectTimeButton.layer.cornerRadius = 30

        tableView.rowHeight =  UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        
        // _title, _quotation, _commentary, _action
        if let exerciseKey = SelectedExercise.key {
            setupExerciseText(exerciseKey: exerciseKey)
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
        } else if segue.identifier == meditationTimesSegueID {
            let meditationTimesController = segue.destination
            if let meditationTimesController = meditationTimesController as? MeditationTimesTableViewController {
                meditationTimesController.meditationTimes = meditationTimes
                if let meditationTimes = meditationTimes {
                    meditationTimes.delegate = meditationTimesController
                }
            }
        }
    }

    @IBAction func selectTimesToMeditate(_ sender: UIButton) {
        
        UNUserNotificationCenter.current().getNotificationSettings { (userNotificationSettings) in
            DispatchQueue.main.async { [weak self] in
                guard let vc = self else { return }
                if userNotificationSettings.authorizationStatus == .notDetermined {
                    vc.presentCorrectAlert(authorizationStatus: .notDetermined)
                    
                } else if userNotificationSettings.authorizationStatus == .denied {
                    vc.presentCorrectAlert(authorizationStatus: .denied)
                    
                } else {
                    vc.performSegue(withIdentifier: vc.meditationTimesSegueID, sender: vc)
                }
            }
        }
    }
    
    private func setupExerciseText(exerciseKey: String) {
        
        if let standardExerciseFont =  UIFont(name: "\(standardFont)-Regular", size: 18) {
            let quotation = NSMutableAttributedString(string: "\n\"" + NSLocalizedString(exerciseKey + "_quotation", comment: quotationComment) + "\"", attributes: [.font: standardExerciseFont])
            var commentary =  NSMutableAttributedString(string: "\n\n" + NSLocalizedString(exerciseKey + commentaryKey, comment: commentaryComment), attributes: [.font: standardExerciseFont])
            if commentary.string.trimmingCharacters(in: .whitespacesAndNewlines) == exerciseKey + commentaryKey {
                commentary = NSMutableAttributedString(string: "")
            }
            let action = NSMutableAttributedString(string: "\n\n" + NSLocalizedString(exerciseKey + "_action", comment: actionComment) + "\n", attributes: [.font: standardExerciseFont])
            
            if let boldExerciseFont = UIFont(name: "\(standardFont)-Semibold", size: 18) {
                let attributedElements = createAttributedCommentaryAndAction(commentary: commentary, boldExerciseFont: boldExerciseFont)
                createFullExerciseText(quotation: quotation, attributedElements: attributedElements, commentary: commentary, action: action)
            }
        }
    }
    
    private func createAttributedCommentaryAndAction(commentary: NSAttributedString, boldExerciseFont: UIFont) -> (NSMutableAttributedString, NSMutableAttributedString) {
        var attributedCommentary: NSMutableAttributedString
        if commentary.string != "" {
            attributedCommentary = NSMutableAttributedString(string: "\n\nCommentary:", attributes: [.font: boldExerciseFont])
        } else {
            attributedCommentary = NSMutableAttributedString(string: "")
        }
        
        let attributedAction = NSMutableAttributedString(string: "\n\nAction:", attributes: [.font: boldExerciseFont])
        
        return (attributedCommentary, attributedAction)
    }
    
    private func createFullExerciseText(quotation: NSMutableAttributedString, attributedElements: (NSMutableAttributedString, NSMutableAttributedString), commentary: NSMutableAttributedString, action: NSMutableAttributedString) {
        quotation.append(attributedElements.0)
        quotation.append(commentary)
        quotation.append(attributedElements.1)
        quotation.append(action)
        
        exerciseTextView.attributedText = quotation
    }
    
    private func presentCorrectAlert(authorizationStatus: UNAuthorizationStatus) {
        let alert = NotificationsSetup.sharedInstance.giveAppPromptForNotifications(authorizationStatus: authorizationStatus) { (userEnabledNotifications) in
            
            DispatchQueue.main.async { [weak self] in
                guard let vc = self else { return }
                let permAlert = NotificationsSetup.sharedInstance.suggestPermanentNotifications() {
                    if userEnabledNotifications {
                        vc.performSegue(withIdentifier: vc.meditationTimesSegueID, sender: vc)
                    }

                }
                
                NotificationsReceiver.sharedInstance.topViewController?.present(permAlert, animated: true, completion: nil)
            }
        }
        
        if let alert = alert {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
