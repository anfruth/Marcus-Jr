//
//  DailyExerciseViewController.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/17/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.x
//

import UIKit
import UserNotifications

class DailyExerciseViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, NotificationsVC {

    @IBOutlet weak var numberOfDaysPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var selectTimeCell: UITableViewCell!
    @IBOutlet weak var selectedTimesCell: UITableViewCell!
    @IBOutlet weak var selectTimeButton: UIButton!
    
    @IBOutlet weak var firstTime: UILabel!
    @IBOutlet weak var secondTime: UILabel!
    @IBOutlet weak var thirdTime: UILabel!
    @IBOutlet weak var fourthTime: UILabel!
    @IBOutlet weak var fifthTime: UILabel!
    
    // reduce number of times logic in didSets called
    private var pickerChosenDays: Int = 1 { // what the picker says
        didSet {
            
            if let emotion = SelectedEmotion.choice, let exercise = SelectedExercise.key {
                if let emotionRawValue = Emotion.getRawValue(from: emotion) {
                    UserDefaults.standard.set(pickerChosenDays, forKey: "\(emotionRawValue)$\(exercise)_times")
                }
            }
            
            if timesSelected.count >= pickerChosenDays {
                selectTimeButton.isUserInteractionEnabled = false
                selectTimeButton.setTitleColor(UIColor.lightGray, for: .normal)
            }
            
        }
    }
    
    // in didSet, need to be able to save to particular emotion and exercise (use emotion string and exercise index?) "SelectedEmotion.choice_SelectedExercise.key"
    private var timeLabels: [UILabel] = [] // collection of time labels
    
    private var timesSelected: [Date] = [] { // collection of dates chosen
        
        didSet(oldTimes) {
            
            // this removes notifications for deleted times
            if let emotion = SelectedEmotion.choice, let exercise = SelectedExercise.key, timesSelected != oldTimes {
                if let emotionRawValue = Emotion.getRawValue(from: emotion) {
                    UserDefaults.standard.set(timesSelected, forKey: "\(emotionRawValue)$\(exercise)")
                }
                
                let center = UNUserNotificationCenter.current()
                
                if oldTimes.count > timesSelected.count {
                    // remove notification, loop through find, dates that are now gone.
                    let removedDates = oldTimes.filter { timesSelected.index(of: $0) == nil }
                    
                    var notificationIdentifiers: [String] = []
                    for date in removedDates {
                        if let emotionRawValue = Emotion.getRawValue(from: emotion) {
                            notificationIdentifiers.append("\(emotionRawValue)$\(exercise)$\(date.description)")
                        }
                    }
                    
                    center.removePendingNotificationRequests(withIdentifiers: notificationIdentifiers)
                }
            }
        }
        
    }
    
    private func addAdditionalLocalNotification(date: Date, emotion: EmotionTypeEncompassing, exercise: String) {
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Time to Meditate!", arguments: nil)
        if let key = SelectedExercise.key {
            content.body = NSString.localizedUserNotificationString(forKey: NSLocalizedString(key, comment: "The meditation title"), arguments: nil)
        }
        content.categoryIdentifier = "meditationCategory"
        content.sound = UNNotificationSound.default()
        
        let calendar = Calendar.current
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute]
        let dateComponents = calendar.dateComponents(components, from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        timeLabels = [firstTime, secondTime, thirdTime, fourthTime, fifthTime]
        
        for label in timeLabels {
            label.superview?.isHidden = true
        }
        
        numberOfDaysPicker.dataSource = self
        numberOfDaysPicker.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setAsTopViewController()
        
        if let emotion = SelectedEmotion.choice, let exercise = SelectedExercise.key {
            
            if let emotionRawValue = Emotion.getRawValue(from: emotion) {
                let storedNumberOfDays: Int = UserDefaults.standard.integer(forKey: "\(emotionRawValue)$\(exercise)_times")
                pickerChosenDays = storedNumberOfDays == 0 ? 1 : storedNumberOfDays
            }
            
            if let emotionRawValue = Emotion.getRawValue(from: emotion) {
                if let dates = UserDefaults.standard.array(forKey: "\(emotionRawValue)$\(exercise)") as? [Date] {
                    timesSelected = dates
                    reorderTimesSelected()
                    for i in 0..<timesSelected.count {
                        timeLabels[i].superview?.isHidden = false
                    }
                }
            }
            
            numberOfDaysPicker.selectRow(pickerChosenDays - 1, inComponent: 0, animated: true)
            
            if pickerChosenDays > timesSelected.count {
                selectTimeButton.isUserInteractionEnabled = true
                selectTimeButton.setTitleColor(UIColor.blue, for: .normal)
            }
        }
    }
    
    
    @IBAction func selectTime(_ sender: UIButton) {
        
        if let emotion = SelectedEmotion.choice, let exercise = SelectedExercise.key, timesSelected.count <= 5 {
            
            assert(pickerChosenDays >= timesSelected.count) // picker days more or equal to times picked
            
            let label = timeLabels[timesSelected.count]
            
            label.superview?.isHidden = false
            let date = datePicker.date
            timesSelected.append(date)
            addAdditionalLocalNotification(date: date, emotion: emotion, exercise: exercise)
            label.text = datePicker.date.description(with: Locale.current)
            
            if timesSelected.count >= pickerChosenDays {
                selectTimeButton.isUserInteractionEnabled = false
                selectTimeButton.setTitleColor(UIColor.lightGray, for: .normal)
            }

            reorderTimesSelected()
        }
    }
    
    @IBAction func eraseTime(_ sender: UIButton) {
        
        selectTimeButton.isUserInteractionEnabled = true
        selectTimeButton.setTitleColor(UIColor.blue, for: .normal)
        
        if let superview = sender.superview {
        
            for view in superview.subviews {
                if let view = view as? UILabel {
                    timesSelected.remove(at: view.tag - 1)
                    removeExcessiveTimes() // will only hide labels, will not removed additional timesSelected due to conditional check in method
                }
            }
        }
        
        reorderTimesSelected()
    }
    
    private func reorderTimesSelected() {
        timesSelected.sort()
        for (i, time) in timesSelected.enumerated() {
            if let label = view.viewWithTag(i + 1) as? UILabel {
                label.text = time.description(with: Locale.current)
            }
        }
    }
    
    private func removeExcessiveTimes() {
        // this deletes times and hides the labels
        var indicesToRemove: [Int] = []
        
        for (i, label) in timeLabels.enumerated() {
            
            if i + 1 > timesSelected.count || i + 1 > pickerChosenDays { // if number of times labels exceed number of times picked, number of times reduced.
                label.superview?.isHidden = true
                if timesSelected.indices.contains(i) {
                    indicesToRemove.append(i)
                    timeLabels[i].superview?.isHidden = true // hides labels that no longer have a time
                }
            }
        }
        
        if let lastIndex = indicesToRemove.last, indicesToRemove.count > 0 {
            timesSelected.removeSubrange(ClosedRange(uncheckedBounds: (lower: indicesToRemove[0], upper: lastIndex)))
        }
    }
    
    // MARK: - UIPickerView Data Source

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    // MARK: - UIPickerView Delegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row + 1)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerChosenDays = row + 1
        
        if pickerChosenDays > timesSelected.count {
            selectTimeButton.isUserInteractionEnabled = true
            selectTimeButton.setTitleColor(UIColor.blue, for: .normal)
            
        } else if pickerChosenDays < timesSelected.count {
            removeExcessiveTimes()
            selectTimeButton.isUserInteractionEnabled = false
            selectTimeButton.setTitleColor(UIColor.lightGray, for: .normal)
        }
        
    }
}
