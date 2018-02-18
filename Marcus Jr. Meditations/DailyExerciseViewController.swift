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
    
    private var chosenNumberOfDays: Int = 1 {
        didSet {
            
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
    
    private var timeLabels: [UILabel] = []
    private var timesSelected: [Date] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        timeLabels = [firstTime, secondTime, thirdTime, fourthTime, fifthTime]
        
        for label in timeLabels {
            label.superview?.isHidden = true
        }
        
        numberOfDaysPicker.dataSource = self
        numberOfDaysPicker.delegate = self
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
