//
//  MeditationTimesModel.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 3/11/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import Foundation

class MeditationTimes {
    
    static weak var delegate: MeditationTimesTableViewController?
    
    static var pickerChosenDays: Int = 1 { // what the picker says, when this happens should also delete dates if excessive labels showing
        didSet {
            savePickerChosenDaysToDisk()
            
            if pickerChosenDays > timesSelected.count {
                delegate?.enableSelectTimeButton()
            } else if pickerChosenDays <= timesSelected.count {
                delegate?.removeExcessiveTimes()
                delegate?.disableSelectTimeButton()
            }
        }
    }
    
     static var timesSelected: [Date] = [] { // collection of dates chosen
        
        didSet(oldTimes) {
            
            if let emotion = SelectedEmotion.choice, let exercise = SelectedExercise.key, timesSelected != oldTimes {
                delegate?.saveTimesSelected(emotion: emotion, exercise: exercise)
                
                if oldTimes.count > timesSelected.count { // handling labels, notifications, time selected button
                    delegate?.handleRemovedTimes(oldTimes: oldTimes, emotion: emotion, exercise: exercise)
                } else if timesSelected.count > oldTimes.count {
                    delegate?.handleAddedTimes(oldTimes: oldTimes, emotion: emotion, exercise: exercise)
                }
            }
        }
        
    }
    
    static func retrievePickerChosenDaysFromDisk(emotionRawValue: String, exercise: String) -> Int {
        let storedNumberOfDays: Int = UserDefaults.standard.integer(forKey: "\(emotionRawValue)$\(exercise)_times")
        return storedNumberOfDays == 0 ? 1 : storedNumberOfDays
    }
    
    static func savePickerChosenDaysToDisk() {
        if let emotion = SelectedEmotion.choice, let exercise = SelectedExercise.key {
            if let emotionRawValue = Emotion.getRawValue(from: emotion) {
                UserDefaults.standard.set(pickerChosenDays, forKey: "\(emotionRawValue)$\(exercise)_times")
            }
        }
    }
    
    
}

