//
//  MeditationTimesModel.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 3/11/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import Foundation

class MeditationTimes {
    
    private let emotion: EmotionTypeEncompassing
    private let exercise: String
    private(set) var pickerDaysEqualMeditationTimes: Bool = false

    weak var delegate: MeditationTimesTableViewController?
    
    var pickerChosenDays: Int = 1 { // what the picker says, when this happens should also delete dates if excessive labels showing
        didSet {
            savePickerChosenDaysToDisk()
            setPickerDaysEqualFlag()
        }
    }
    
    var timesSelected: [Date] = [] { // collection of dates chosen
        
        didSet(oldTimes) {
            
            setPickerDaysEqualFlag()
            if let emotion = SelectedEmotion.choice, let exercise = SelectedExercise.key, timesSelected != oldTimes {
                saveTimesSelected(emotion: emotion, exercise: exercise)
                
                if oldTimes.count > timesSelected.count { // handling labels, notifications, time selected button
                    delegate?.handleRemovedTimes(oldTimes: oldTimes, emotion: emotion, exercise: exercise)
                } else if timesSelected.count > oldTimes.count {
                    delegate?.handleAddedTimes(oldTimes: oldTimes, emotion: emotion, exercise: exercise)
                }
            }
        }
        
    }
    
    init(emotion: EmotionTypeEncompassing, exercise: String) {
        self.emotion = emotion
        self.exercise = exercise
        
        if let emotionRawValue = Emotion.getRawValue(from: emotion) {
            // order of timesSelected before pickerChosenDays matters, if picker first, goes off incorrect value of timesSeleted, timesSelected doesnt touch pickerChosen
            timesSelected = retrieveTimesSelectedFromDisk(emotionRawValue: emotionRawValue, exercise: exercise)
            pickerChosenDays = retrievePickerChosenDaysFromDisk(emotionRawValue: emotionRawValue, exercise: exercise)
            
            setPickerDaysEqualFlag()
        }
        
    }
    
    func savePickerChosenDaysToDisk() {
        if let emotion = SelectedEmotion.choice, let exercise = SelectedExercise.key {
            if let emotionRawValue = Emotion.getRawValue(from: emotion) {
                UserDefaults.standard.set(pickerChosenDays, forKey: "\(emotionRawValue)$\(exercise)_times")
            }
        }
    }
    
    func saveTimesSelected(emotion: EmotionTypeEncompassing, exercise: String) {
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
    
    private func setPickerDaysEqualFlag() {

        if pickerChosenDays > timesSelected.count {
            pickerDaysEqualMeditationTimes = false
        } else { // pickerChosenDays should never be less than timesSelected
            pickerDaysEqualMeditationTimes = true
        }
    }


    
    
}

