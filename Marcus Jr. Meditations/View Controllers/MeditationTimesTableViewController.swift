//
//  MeditationTimesTableViewController.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 3/11/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import UIKit
import UserNotifications

class MeditationTimesTableViewController: UITableViewController, NotificationsVC {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var selectTimeButton: UIButton!
    
    @IBOutlet weak var firstTime: UILabel!
    @IBOutlet weak var secondTime: UILabel!
    @IBOutlet weak var thirdTime: UILabel!
    @IBOutlet weak var fourthTime: UILabel!
    @IBOutlet weak var fifthTime: UILabel!
    
    weak var delegate: DailyExerciseViewController?
    
    private var timeLabels: [UILabel] = [] // collection of time labels
    
    let center = UNUserNotificationCenter.current()
    var labelMapping: [Int: UILabel] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MeditationTimes.delegate = self
        
        timeLabels = [firstTime, secondTime, thirdTime, fourthTime, fifthTime]
        labelMapping = [1: firstTime, 2: secondTime, 3: thirdTime, 4: fourthTime, 5: fifthTime]
        _ = removeExcessiveLabels() // start all hidden

        if let emotion = SelectedEmotion.choice, let exercise = SelectedExercise.key {
            
            if let emotionRawValue = Emotion.getRawValue(from: emotion) {
                // order of timesSelected before pickerChosenDays matters, if picker first, goes off incorrect value of timesSeleted, timesSelected doesnt touch pickerChosen
                MeditationTimes.timesSelected = retrieveTimesSelectedFromDisk(emotionRawValue: emotionRawValue, exercise: exercise)
                MeditationTimes.pickerChosenDays = MeditationTimes.retrievePickerChosenDaysFromDisk(emotionRawValue: emotionRawValue, exercise: exercise)
                showLabels(emotionRawValue: emotionRawValue, exercise: exercise)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setAsTopViewController()
    }
    
    @IBAction func selectTime(_ sender: UIButton) {
        assert(MeditationTimes.pickerChosenDays > MeditationTimes.timesSelected.count) // picker days more than times picked
        
        let date = datePicker.date
        MeditationTimes.timesSelected.append(date)
    }

    @IBAction func eraseTime(_ sender: UIButton) {
        if let superview = sender.superview {
            
            for view in superview.subviews {
                if let view = view as? UILabel {
                    MeditationTimes.timesSelected.remove(at: view.tag - 1)
                }
            }
        }
    }
    
    func handleAddedTimes(oldTimes: [Date], emotion: EmotionTypeEncompassing, exercise: String) {
        let addedTimes = MeditationTimes.timesSelected.filter { oldTimes.index(of: $0) == nil }
        
        for date in addedTimes {
            addAdditionalLocalNotification(date: date, emotion: emotion, exercise: exercise)
        }
        
        if let emotionRawValue = Emotion.getRawValue(from: emotion) {
            showLabels(emotionRawValue: emotionRawValue, exercise: exercise)
        }
        
        if MeditationTimes.pickerChosenDays <= MeditationTimes.timesSelected.count {
            disableSelectTimeButton()
        }
        
    }
    
    func handleRemovedTimes(oldTimes: [Date], emotion: EmotionTypeEncompassing, exercise: String) {
        removeExcessiveTimes()
        let removedTimes = oldTimes.filter { MeditationTimes.timesSelected.index(of: $0) == nil }
        let notificationIDsToDelete = getNotificationsToDelete(emotion: emotion, exercise: exercise, removedTimes: removedTimes)
        center.removePendingNotificationRequests(withIdentifiers: notificationIDsToDelete)

        if MeditationTimes.pickerChosenDays > MeditationTimes.timesSelected.count {
            enableSelectTimeButton()
        }
    }
    
    func disableSelectTimeButton() {
        selectTimeButton.isUserInteractionEnabled = false
        selectTimeButton.backgroundColor = UIColor.lightGray
    }
    
    func enableSelectTimeButton() {
        selectTimeButton.isUserInteractionEnabled = true
        selectTimeButton.backgroundColor = UIColor.blue // get correct blue
    }
    
    func removeExcessiveTimes() {
        // this deletes times and hides the labels
        let indicesToRemove = removeExcessiveLabels()
        
        if let lastIndex = indicesToRemove.last, indicesToRemove.count > 0 {
            MeditationTimes.timesSelected.removeSubrange(ClosedRange(uncheckedBounds: (lower: indicesToRemove[0], upper: lastIndex)))
        }
    }
    
    func removeExcessiveLabels() -> [Int] {
        var indicesToRemove: [Int] = []
        for (i, label) in timeLabels.enumerated() {
            
            if i + 1 > MeditationTimes.timesSelected.count || i + 1 > MeditationTimes.pickerChosenDays { // if number of times labels exceed number of times picked, number of times reduced.
                label.superview?.isHidden = true
                if MeditationTimes.timesSelected.indices.contains(i) {
                    indicesToRemove.append(i)
                    timeLabels[i].superview?.isHidden = true // hides labels that no longer have a time
                }
            }
        }

        reorderTimesSelected()

        return indicesToRemove
    }
    
    func saveTimesSelected(emotion: EmotionTypeEncompassing, exercise: String) {
        if let emotionRawValue = Emotion.getRawValue(from: emotion) {
            UserDefaults.standard.set(MeditationTimes.timesSelected, forKey: "\(emotionRawValue)$\(exercise)")
        }
    }

    private func reorderTimesSelected() {
        MeditationTimes.timesSelected.sort()
        for (i, time) in MeditationTimes.timesSelected.enumerated() {
            if let label = labelMapping[i + 1] {
                label.text = time.description(with: Locale.current)
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
    
    private func retrieveTimesSelectedFromDisk(emotionRawValue: String, exercise: String) -> [Date] {
        if let dates = UserDefaults.standard.array(forKey: "\(emotionRawValue)$\(exercise)") as? [Date] {
            return dates
        }
        
        return []
    }

    private func getNotificationsToDelete(emotion: EmotionTypeEncompassing, exercise: String, removedTimes: [Date]) -> [String] {
        var notificationIdentifiers: [String] = []
        for date in removedTimes {
            if let emotionRawValue = Emotion.getRawValue(from: emotion) {
                notificationIdentifiers.append("\(emotionRawValue)$\(exercise)$\(date.description)")
            }
        }
        
        return notificationIdentifiers
    }
    
    private func showLabels(emotionRawValue: String, exercise: String) {
        for i in 0..<MeditationTimes.timesSelected.count {
            timeLabels[i].superview?.isHidden = false
        }

        reorderTimesSelected()
    }
}
