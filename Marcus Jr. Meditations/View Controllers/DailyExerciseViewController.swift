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

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var selectTimeCell: UITableViewCell!
    @IBOutlet weak var selectedTimesCell: UITableViewCell!
    @IBOutlet weak var selectTimeButton: UIButton!
    @IBOutlet weak var selectNumTimesButton: UIButton!
    
    @IBOutlet weak var firstTime: UILabel!
    @IBOutlet weak var secondTime: UILabel!
    @IBOutlet weak var thirdTime: UILabel!
    @IBOutlet weak var fourthTime: UILabel!
    @IBOutlet weak var fifthTime: UILabel!
    
    @IBOutlet weak var exerciseTextView: UITextView!
    
    let center = UNUserNotificationCenter.current()
    var labelMapping: [Int: UILabel] = [:]
    
    // reduce number of times logic in didSets called
    private var pickerChosenDays: Int = 1 { // what the picker says, when this happens should also delete dates if excessive labels showing
        didSet {
            savePickerChosenDaysToDisk()
            
            if pickerChosenDays > timesSelected.count {
                enableSelectTimeButton()
            } else if pickerChosenDays <= timesSelected.count {
                removeExcessiveTimes()
                disableSelectTimeButton()
            }
        }
    }
    
    // in didSet, need to be able to save to particular emotion and exercise (use emotion string and exercise index?) "SelectedEmotion.choice_SelectedExercise.key"
    private var timeLabels: [UILabel] = [] // collection of time labels
    
    private var timesSelected: [Date] = [] { // collection of dates chosen
        
        didSet(oldTimes) {

            if let emotion = SelectedEmotion.choice, let exercise = SelectedExercise.key, timesSelected != oldTimes {
                saveTimesSelected(emotion: emotion, exercise: exercise)

                if oldTimes.count > timesSelected.count { // handling labels, notifications, time selected button
                    handleRemovedTimes(oldTimes: oldTimes, emotion: emotion, exercise: exercise)
                } else if timesSelected.count > oldTimes.count {
                    handleAddedTimes(oldTimes: oldTimes, emotion: emotion, exercise: exercise)
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectNumTimesButton.layer.cornerRadius = 30
        labelMapping = [1: firstTime, 2: secondTime, 3: thirdTime, 4: fourthTime, 5: fifthTime]

        tableView.rowHeight =  UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        if let exerciseKey = SelectedExercise.key {
            title = NSLocalizedString(exerciseKey + "_title", comment: "title of exercise")
        }
            
        timeLabels = [firstTime, secondTime, thirdTime, fourthTime, fifthTime]
        _ = removeExcessiveLabels() // start all hidden
        
        // _title, _quotation, _commentary, _action
        if let exerciseKey = SelectedExercise.key {
            
            if let standardExerciseFont =  UIFont(name: "SanFranciscoDisplay-Regular", size: 16) {
                let quotation = NSMutableAttributedString(string: "\n\"" + NSLocalizedString(exerciseKey + "_quotation", comment: "quotation of exercise") + "\"", attributes: [.font: standardExerciseFont])
                var commentary =  NSMutableAttributedString(string: "\n\n" + NSLocalizedString(exerciseKey + "_commentary", comment: "commentary on exercise"), attributes: [.font: standardExerciseFont])
                if commentary.string.trimmingCharacters(in: .whitespacesAndNewlines) == exerciseKey + "_commentary" {
                    commentary = NSMutableAttributedString(string: "")
                }
                let action = NSMutableAttributedString(string: "\n\n" + NSLocalizedString(exerciseKey + "_action", comment: "action on exercise") + "\n", attributes: [.font: standardExerciseFont])

                if let boldExerciseFont = UIFont(name: "SanFranciscoDisplay-Semibold", size: 16) {
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setAsTopViewController()
        
        if let emotion = SelectedEmotion.choice, let exercise = SelectedExercise.key {
            
            if let emotionRawValue = Emotion.getRawValue(from: emotion) {
                // order of timesSelected before pickerChosenDays matters, if picker first, goes off incorrect value of timesSeleted, timesSelected doesnt touch pickerChosen
                timesSelected = retrieveTimesSelectedFromDisk(emotionRawValue: emotionRawValue, exercise: exercise)
                pickerChosenDays = retrievePickerChosenDaysFromDisk(emotionRawValue: emotionRawValue, exercise: exercise)
                showLabels(emotionRawValue: emotionRawValue, exercise: exercise)
            }
            
            //numberOfDaysPicker.selectRow(pickerChosenDays - 1, inComponent: 0, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPickerVC" {
            let pickerVC = segue.destination
            if let pickerVC = pickerVC as? PickerViewController {
                
                pickerVC.pickerView.dataSource = self
                pickerVC.pickerView.delegate = self
                pickerVC.pickerChosenDays = pickerChosenDays
                
                if let originalColor = navigationController?.navigationBar.tintColor {
                    pickerVC.originalButtonColor = originalColor
                }
                
                navigationController?.navigationBar.isUserInteractionEnabled = false
                navigationController?.navigationBar.tintColor = UIColor.lightGray
            }
        }
    }
    
    @IBAction func selectTime(_ sender: UIButton) {
        assert(pickerChosenDays > timesSelected.count) // picker days more than times picked

        let date = datePicker.date
        timesSelected.append(date)
    }
    
    @IBAction func eraseTime(_ sender: UIButton) {
        if let superview = sender.superview {

            for view in superview.subviews {
                if let view = view as? UILabel {
                    timesSelected.remove(at: view.tag - 1)
                }
            }
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
    }
    
    private func handleAddedTimes(oldTimes: [Date], emotion: EmotionTypeEncompassing, exercise: String) {
        let addedTimes = timesSelected.filter { oldTimes.index(of: $0) == nil }
        
        for date in addedTimes {
            addAdditionalLocalNotification(date: date, emotion: emotion, exercise: exercise)
        }
        
        if let emotionRawValue = Emotion.getRawValue(from: emotion) {
            showLabels(emotionRawValue: emotionRawValue, exercise: exercise)
        }
        
        if pickerChosenDays <= timesSelected.count {
            disableSelectTimeButton()
        }
        
    }
    
    private func handleRemovedTimes(oldTimes: [Date], emotion: EmotionTypeEncompassing, exercise: String) {
        removeExcessiveTimes()
        let removedTimes = oldTimes.filter { timesSelected.index(of: $0) == nil }
        let notificationIDsToDelete = getNotificationsToDelete(emotion: emotion, exercise: exercise, removedTimes: removedTimes)
        center.removePendingNotificationRequests(withIdentifiers: notificationIDsToDelete)

        if pickerChosenDays > timesSelected.count {
            enableSelectTimeButton()
        }
    }
    
    private func disableSelectTimeButton() {
        selectTimeButton.isUserInteractionEnabled = false
        selectTimeButton.setTitleColor(UIColor.lightGray, for: .normal)
    }
    
    private func enableSelectTimeButton() {
        selectTimeButton.isUserInteractionEnabled = true
        selectTimeButton.setTitleColor(UIColor.blue, for: .normal)
    }
    
    private func reorderTimesSelected() {
        timesSelected.sort()
        for (i, time) in timesSelected.enumerated() {
            if let label = labelMapping[i + 1] {
                label.text = time.description(with: Locale.current)
            }
        }
    }
    
    private func removeExcessiveTimes() {
        // this deletes times and hides the labels
        let indicesToRemove = removeExcessiveLabels()
        
        if let lastIndex = indicesToRemove.last, indicesToRemove.count > 0 {
            timesSelected.removeSubrange(ClosedRange(uncheckedBounds: (lower: indicesToRemove[0], upper: lastIndex)))
        }
    }
    
    private func removeExcessiveLabels() -> [Int] {
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

        reorderTimesSelected()

        return indicesToRemove
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
    
    private func savePickerChosenDaysToDisk() {
        if let emotion = SelectedEmotion.choice, let exercise = SelectedExercise.key {
            if let emotionRawValue = Emotion.getRawValue(from: emotion) {
                UserDefaults.standard.set(pickerChosenDays, forKey: "\(emotionRawValue)$\(exercise)_times")
            }
        }
    }
    
    private func saveTimesSelected(emotion: EmotionTypeEncompassing, exercise: String) {
        if let emotionRawValue = Emotion.getRawValue(from: emotion) {
            UserDefaults.standard.set(timesSelected, forKey: "\(emotionRawValue)$\(exercise)")
        }
    }
    
    private func retrievePickerChosenDaysFromDisk(emotionRawValue: String, exercise: String) -> Int {
        let storedNumberOfDays: Int = UserDefaults.standard.integer(forKey: "\(emotionRawValue)$\(exercise)_times")
        return storedNumberOfDays == 0 ? 1 : storedNumberOfDays
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
        for i in 0..<timesSelected.count {
            timeLabels[i].superview?.isHidden = false
        }

        reorderTimesSelected()
    }
    
    // save and retrive functionality from date model, times selected being set to hiding or showing labels
    
    // dates property, times picked property
    
}
