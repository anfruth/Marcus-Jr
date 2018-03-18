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
    
    weak var delegate: DailyExerciseViewController?
    
    var meditationTimes: MeditationTimes?
    private var timeLabels: [UILabel] = [] // collection of time labels
    
    let center = UNUserNotificationCenter.current()
    var labelMapping: [Int: UILabel] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentDate = Date()
        datePicker.minimumDate = currentDate + 60 // next minute
        
        timeLabels = [firstTime, secondTime, thirdTime, fourthTime, fifthTime]
        labelMapping = [1: firstTime, 2: secondTime, 3: thirdTime, 4: fourthTime, 5: fifthTime]
        
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
        
        greyCompleteLabelsAndCheckForExerciseComplete()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setAsTopViewController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        greyCompleteLabelsAndCheckForExerciseComplete()
    }
    
    @IBAction func selectTime(_ sender: UIButton) {
        guard let meditationTimes = meditationTimes else {
            return
        }
        
        assert(meditationTimes.pickerChosenDays > meditationTimes.timesSelected.count) // picker days more than times picked
        
        let date = datePicker.date
        let roundedToLowestMinute: TimeInterval = floor(date.timeIntervalSinceReferenceDate / 60) * 60
        let roundedDate = Date(timeIntervalSinceReferenceDate: roundedToLowestMinute)
        
        if let exercise = SelectedExercise.key {
            let meditation = Meditation(date: roundedDate, exercise: exercise)
            meditationTimes.timesSelected.append(meditation)
        }
    }

    @IBAction func eraseTime(_ sender: UIButton) {
        guard let meditationTimes = meditationTimes else {
            return
        }
        
        if let superview = sender.superview {
            for view in superview.subviews {
                if let view = view as? UILabel {
                    meditationTimes.timesSelected.remove(at: view.tag - 1)
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
    
    private func greyCompleteLabelsAndCheckForExerciseComplete() {
        let allTimesCompleted = completeExpiredMeditations()
        
        if allTimesCompleted {
            meditationTimes?.exerciseComplete = true
        } else {
            meditationTimes?.exerciseComplete = false
        }
    }
    
    private func removeExcessiveLabels() -> [Int] {
        guard let meditationTimes = meditationTimes else {
            return []
        }
        
        var indicesToRemove: [Int] = []
        for (i, label) in timeLabels.enumerated() {
            
            if i + 1 > meditationTimes.timesSelected.count || i + 1 > meditationTimes.pickerChosenDays { // if number of times labels exceed number of times picked, number of times reduced.
                label.superview?.isHidden = true
                if meditationTimes.timesSelected.indices.contains(i) {
                    indicesToRemove.append(i)
                    timeLabels[i].superview?.isHidden = true // hides labels that no longer have a time
                }
            }
        }
        
        reorderTimesSelected()
        
        return indicesToRemove
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
            if let label = labelMapping[i + 1] {
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
            timeLabels[i].superview?.isHidden = false
        }

        reorderTimesSelected()
    }
    
    private func completeExpiredMeditations() -> Bool { // returns true if all exercises complete
        guard let meditationTimes = meditationTimes else {
            return false
        }
        
        if meditationTimes.timesSelected.count == 0 {
            return false
        }
        
        var allCompleted = true
        for time in meditationTimes.timesSelected {
            
            if time.completed {
                if let indexToDelete = meditationTimes.timesSelected.index(of: time) {
                    if let label = labelMapping[indexToDelete + 1] {
                        label.textColor = UIColor.lightGray
                    }
                }
            } else {
                allCompleted = false
            }
        }

        return allCompleted
    }
    
}
