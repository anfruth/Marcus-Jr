//
//  DailyExerciseViewController.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/17/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import UIKit

class DailyExerciseViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {

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
    private var chosenNumberOfDays: Int = 1 {
        didSet {
            
            if let emotion = SelectedEmotion.choice, let exercise = SelectedExercise.key {
                UserDefaults.standard.set(chosenNumberOfDays, forKey: "\(emotion)_\(exercise)_times")
            }
            
            if numberOfTimesPicked > chosenNumberOfDays {
                numberOfTimesPicked = chosenNumberOfDays
            }
            
            selectTimeButton.isUserInteractionEnabled = false
            selectTimeButton.setTitleColor(UIColor.lightGray, for: .normal)
        }
    }
    
    private var numberOfTimesPicked: Int = 0 {
        
        didSet {
            var indicesToRemove: [Int] = []
            
            for (i, label) in timeLabels.enumerated() {
                
                if i + 1 > numberOfTimesPicked {
                    label.superview?.isHidden = true
                    if timesSelected.indices.contains(i) {
                        indicesToRemove.append(i)
                    }
                }
            }
            
            if let lastIndex = indicesToRemove.last, indicesToRemove.count > 0 {
                timesSelected.removeSubrange(ClosedRange(uncheckedBounds: (lower: indicesToRemove[0], upper: lastIndex)))
            }
            
            reorderTimesSelected()
        }

    }
    // in didSet, need to be able to save to particular emotion and exercise (use emotion string and exercise index?) "SelectedEmotion.choice_SelectedExercise.key"
    private var timeLabels: [UILabel] = []
    
    private var timesSelected: [Date] = [] {
        
        didSet(oldValue) {
            if let emotion = SelectedEmotion.choice, let exercise = SelectedExercise.key, timesSelected != oldValue {
                UserDefaults.standard.set(timesSelected, forKey: "\(emotion)_\(exercise)")
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
        
        if let emotion = SelectedEmotion.choice, let exercise = SelectedExercise.key {
            
            let timesADay = UserDefaults.standard.integer(forKey: "\(emotion)_\(exercise)_times")
            chosenNumberOfDays = timesADay
            
            if let dates = UserDefaults.standard.array(forKey: "\(emotion)_\(exercise)") as? [Date] {
                timesSelected = dates
                numberOfTimesPicked = timesSelected.count
                reorderTimesSelected()
                for i in 0..<timesSelected.count {
                    timeLabels[i].superview?.isHidden = false
                }
            }
            
            numberOfDaysPicker.selectRow(chosenNumberOfDays - 1, inComponent: 0, animated: true)
            
            if chosenNumberOfDays > numberOfTimesPicked {
                selectTimeButton.isUserInteractionEnabled = true
                selectTimeButton.setTitleColor(UIColor.blue, for: .normal)
            }
        }
    }
    
    
    @IBAction func selectTime(_ sender: UIButton) {
        
        let label = timeLabels[numberOfTimesPicked]
        
        if let existingText = label.text {
            label.superview?.isHidden = false
            timesSelected.append(datePicker.date)
            label.text = existingText + datePicker.date.description(with: Locale.current)
        }
        
        numberOfTimesPicked += 1
        
        if numberOfTimesPicked == chosenNumberOfDays {
            selectTimeButton.isUserInteractionEnabled = false
            selectTimeButton.setTitleColor(UIColor.lightGray, for: .normal)
        }

        reorderTimesSelected()
    }
    
    @IBAction func eraseTime(_ sender: UIButton) {
        
        selectTimeButton.isUserInteractionEnabled = true
        selectTimeButton.setTitleColor(UIColor.blue, for: .normal)
        
        if let superview = sender.superview {
        
            for view in superview.subviews {
                if let view = view as? UILabel {
                    timesSelected.remove(at: view.tag - 1)
                }
            }
        }
        
        numberOfTimesPicked -= 1
        
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
        chosenNumberOfDays = row + 1
        
        if chosenNumberOfDays > numberOfTimesPicked {
            selectTimeButton.isUserInteractionEnabled = true
            selectTimeButton.setTitleColor(UIColor.blue, for: .normal)
        }
        
    }
}
