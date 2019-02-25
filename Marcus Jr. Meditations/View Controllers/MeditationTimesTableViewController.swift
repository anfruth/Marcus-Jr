//
//  MeditationTimesTableViewController.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 3/11/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import UIKit
import UserNotifications

protocol MeditationTimesModelDelegate {
    func handleAddedTimes(oldMeditationTimes: [Meditation], emotion: EmotionTypeEncompassing, exercise: String)
    func handleRemovedTimes(oldMeditationTimes: [Meditation], emotion: EmotionTypeEncompassing, exercise: String)
}

class MeditationTimesTableViewController: UITableViewController, NotificationsVC, MeditationTimesModelDelegate, CompleteExerciseSettable {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var selectTimeButton: UIButton!
    
    @IBOutlet weak var firstTime: UILabel!
    @IBOutlet weak var secondTime: UILabel!
    @IBOutlet weak var thirdTime: UILabel!
    @IBOutlet weak var fourthTime: UILabel!
    @IBOutlet weak var fifthTime: UILabel!
    
    @IBOutlet weak var firstX: UIButton!
    @IBOutlet weak var secondX: UIButton!
    @IBOutlet weak var thirdX: UIButton!
    @IBOutlet weak var fourthX: UIButton!
    @IBOutlet weak var fifthX: UIButton!
    
    weak var delegate: DailyExerciseViewController?
    
    var meditationTimes: MeditationTimes?
    private var xButtons: [UIButton] = [] // collection of time labels
    
    private let center = UNUserNotificationCenter.current()
    private var buttonMapping: [Int: UIButton] = [:]
    private var buttonToLabelMapping: [UIButton: UILabel] = [:]
    
    private let duplicateTimeTitleKey = "Duplicate_time_title"
    private let duplicateTimeTitleComment = "Dupliicate time title"
    private let duplicateTimeMessageKey = "Duplicate_time_message"
    private let duplicateTimeMessageComment = "Duplicate time message"
    private let okActionKey = "Ok_action"
    private let okActionKeyComment = "Ok message"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentDate = Date()
        datePicker.minimumDate = currentDate + 60 // next minute
        
        xButtons = [firstX, secondX, thirdX, fourthX, fifthX]
        buttonMapping = [1: firstX, 2: secondX, 3: thirdX, 4: fourthX, 5: fifthX]
        buttonToLabelMapping = [firstX: firstTime, secondX: secondTime, thirdX: thirdTime, fourthX: fourthTime, fifthX: fifthTime]
        
        reorderTimesSelected()
        _ = removeExcessiveLabels() // start all hidden
        
        if let meditationTimes = meditationTimes {
            if meditationTimes.pickerDaysEqualMeditationTimes {
                removeExcessiveTimes()
                disableSelectTimeButton()
            } else {
                enableSelectTimeButton()
            }
        }
        
        if let emotion = SelectedEmotion.choice, let exercise = SelectedExercise.key {
            
            if let emotionRawValue = Emotion.getRawValue(from: emotion) {
                showLabels(emotionRawValue: emotionRawValue, exercise: exercise)
            }
        }
        
        greyCompletedLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setAsTopViewController()
    }
    
    @IBAction func selectTime(_ sender: UIButton) {
        center.getNotificationSettings { notificationSettings in
            
            DispatchQueue.main.async { [weak self] in
                if notificationSettings.authorizationStatus != .authorized {
                    self?.kickUserOutOfController()
                } else {
                    
                    guard let vc = self, let meditationTimes = vc.meditationTimes else {
                        return
                    }
                    
                    assert(meditationTimes.pickerChosenDays > meditationTimes.timesSelected.count) // picker days more than times picked
                    
                    let date = vc.datePicker.date
                    let roundedToLowestMinute: TimeInterval = floor(date.timeIntervalSinceReferenceDate / 60) * 60
                    let roundedDate = Date(timeIntervalSinceReferenceDate: roundedToLowestMinute)
                    
                    if let exercise = SelectedExercise.key {
                        let meditation = Meditation(date: roundedDate, exercise: exercise)
                        if !meditationTimes.timesSelected.contains(meditation) {
                            meditationTimes.timesSelected.append(meditation)
                        } else {
                            vc.showAlertDuplicateTime()
                        }
                    }
                }
            }
        }
    }

    @IBAction func eraseTime(_ sender: UIButton) {
        
        center.getNotificationSettings { notificationSettings in
            
            DispatchQueue.main.async { [weak self] in
                if notificationSettings.authorizationStatus != .authorized {
                    self?.kickUserOutOfController()
                } else {
                    
                    guard let vc = self, let meditationTimes = vc.meditationTimes else {
                        return
                    }
                    
                    if let label = vc.buttonToLabelMapping[sender] {
                        meditationTimes.timesSelected.remove(at: label.tag - 1)
                    }
                    
                    
                }
            }
        }
      
    }
    
    // MARK: Meditation Times Model Delegate

    func handleAddedTimes(oldMeditationTimes: [Meditation], emotion: EmotionTypeEncompassing, exercise: String) {
        guard let meditationTimes = meditationTimes else {
            return
        }
        
        let addedMeditationTimes = meditationTimes.timesSelected.filter { oldMeditationTimes.index(of: $0) == nil }
        
        for meditation in addedMeditationTimes {
            addAdditionalLocalNotification(date: meditation.date, emotion: emotion, exercise: exercise)
        }
        
        if let emotionRawValue = Emotion.getRawValue(from: emotion) {
            showLabels(emotionRawValue: emotionRawValue, exercise: exercise)
        }
        
        if meditationTimes.pickerChosenDays <= meditationTimes.timesSelected.count {
            disableSelectTimeButton()
        }
        
    }
    
    func handleRemovedTimes(oldMeditationTimes: [Meditation], emotion: EmotionTypeEncompassing, exercise: String) {
        guard let meditationTimes = meditationTimes else {
            return
        }
        
        removeExcessiveTimes()
        let removedMeditations = oldMeditationTimes.filter { meditationTimes.timesSelected.index(of: $0) == nil }
        let notificationIDsToDelete = getNotificationsToDelete(emotion: emotion, exercise: exercise, removedMeditations: removedMeditations)
        center.removePendingNotificationRequests(withIdentifiers: notificationIDsToDelete)

        if meditationTimes.pickerChosenDays > meditationTimes.timesSelected.count {
            enableSelectTimeButton()
        }
    }
    
    // MARK: - Private methods
    
    private func removeExcessiveLabels() -> [Int] {
        guard let meditationTimes = meditationTimes else {
            return []
        }
        
        var indicesToRemove: [Int] = []
        for (i, button) in xButtons.enumerated() {
            
            if i + 1 > meditationTimes.timesSelected.count || i + 1 > meditationTimes.pickerChosenDays { // if number of times labels exceed number of times picked, number of times reduced.
                
                buttonToLabelMapping[button]?.isHidden = true
                button.isHidden = true
                button.setTitleColor(UIColor(red: 0.90, green: 0.11, blue: 0.21, alpha: 1.0), for: .normal)
                button.isUserInteractionEnabled = true
                
                if meditationTimes.timesSelected.indices.contains(i) {
                    indicesToRemove.append(i)
                }
            }
        }
        
        reorderTimesSelected()
        
        return indicesToRemove
    }
    
    private func showAlertDuplicateTime() {
        var alert = UIAlertController()
        
        alert = UIAlertController(title: NSLocalizedString(duplicateTimeTitleKey, comment: duplicateTimeTitleComment), message: NSLocalizedString(duplicateTimeMessageKey, comment: duplicateTimeMessageComment), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString(okActionKey, comment: okActionKeyComment), style: .default))
        
        present(alert, animated: true, completion: nil)
    }

    private func kickUserOutOfController() {
        var alert = UIAlertController()
        
        NotificationsSetup.sharedInstance.makeDeniedAlert(alert: &alert, completionHandler: {
            self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "Skip", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        
        present(alert, animated: true, completion: nil)

    }
    
    private func disableSelectTimeButton() {
        selectTimeButton.isUserInteractionEnabled = false
        selectTimeButton.backgroundColor = UIColor.lightGray
    }
    
    private func enableSelectTimeButton() {
        selectTimeButton.isUserInteractionEnabled = true
        selectTimeButton.backgroundColor = UIColor(red:0.27, green:0.51, blue:0.93, alpha:1.0) // get correct blue
    }
    
    private func removeExcessiveTimes() {
        guard let meditationTimes = meditationTimes else {
            return
        }
        // this deletes times and hides the labels
        let indicesToRemove = removeExcessiveLabels()
        
        if let lastIndex = indicesToRemove.last, indicesToRemove.count > 0 {
            meditationTimes.timesSelected.removeSubrange(ClosedRange(uncheckedBounds: (lower: indicesToRemove[0], upper: lastIndex)))
        }
    }
    

    private func reorderTimesSelected() {
        guard let meditationTimes = meditationTimes else {
            return
        }

        meditationTimes.timesSelected = meditationTimes.timesSelected.sorted(by: {$0.date < $1.date})
        for (i, meditation) in meditationTimes.timesSelected.enumerated() {
            if let button = buttonMapping[i + 1], let label = buttonToLabelMapping[button] {
                let dateString = DateFormatter.localizedString(from: meditation.date, dateStyle: .medium, timeStyle: .short)
                
                label.text = dateString
            }
        }
    }
    
    private func addAdditionalLocalNotification(date: Date, emotion: EmotionTypeEncompassing, exercise: String) {
        
        let content = getContentForNotification()
        let trigger = getTriggerForNotification(date: date)
        
        if let emotionRawValue = Emotion.getRawValue(from: emotion) {
            let request = UNNotificationRequest(identifier: "\(emotionRawValue)$\(exercise)$\(date.description)", content: content, trigger: trigger)
            
            center.add(request) { (error) in
                #if DEBUG
                    if let error = error {
                        print(error.localizedDescription)
                    }
                #endif
            }
        }
    }
    
    private func getContentForNotification() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Time to Meditate!", arguments: nil)
        if let key = SelectedExercise.key {
            content.body = NSString.localizedUserNotificationString(forKey: NSLocalizedString(key, comment: "The meditation title"), arguments: nil)
        }
        content.categoryIdentifier = "meditationCategory"
        content.sound = UNNotificationSound.default()
        
        return content
    }
    
    private func getTriggerForNotification(date: Date) -> UNCalendarNotificationTrigger {
        let calendar = Calendar.current
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute]
        let dateComponents = calendar.dateComponents(components, from: date)
        return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    }

    private func getNotificationsToDelete(emotion: EmotionTypeEncompassing, exercise: String, removedMeditations: [Meditation]) -> [String] {
        var notificationIdentifiers: [String] = []
        for meditation in removedMeditations {
            if let emotionRawValue = Emotion.getRawValue(from: emotion) {
                notificationIdentifiers.append("\(emotionRawValue)$\(exercise)$\(meditation.date.description)")
            }
        }
        
        return notificationIdentifiers
    }
    
    private func showLabels(emotionRawValue: String, exercise: String) {
        guard let meditationTimes = meditationTimes else {
            return
        }
        
        for i in 0..<meditationTimes.timesSelected.count {
            xButtons[i].isHidden = false
            buttonToLabelMapping[xButtons[i]]?.isHidden = false
        }

        reorderTimesSelected()
    }
    
    private func greyCompletedLabels() { // returns true if all exercises complete
        guard let meditationTimes = meditationTimes else {
            return
        }
        
        for time in meditationTimes.timesSelected {
            
            if time.completed {
                if let indexToDelete = meditationTimes.timesSelected.index(of: time) {
                    if let button = buttonMapping[indexToDelete + 1], let label = buttonToLabelMapping[button] {
                        label.textColor = UIColor.lightGray
                        button.setTitleColor(UIColor.lightGray, for: .normal)
                        button.isUserInteractionEnabled = false
                    }
                }
            }
        }
        
    }
    
}
