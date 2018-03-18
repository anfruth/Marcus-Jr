//
//  MeditationTimesModel.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 3/11/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import Foundation

class MeditationTimes: CompleteExerciseSettable {
    
    private let emotion: EmotionTypeEncompassing
    let exercise: String
    private(set) var pickerDaysEqualMeditationTimes: Bool = false

    weak var delegate: MeditationTimesTableViewController?
    
    var exerciseComplete: Bool { // complete when all meditation times have passed
        didSet {
            if exerciseComplete {
                MeditationTimes.completeExercise(exercise: exercise)
            } else {
                MeditationTimes.resetExercise(exercise: exercise)
            }
            
            MeditationTimes.saveMeditationListToDisk()
        }
    }
    
    var pickerChosenDays: Int = 1 { // what the picker says, when this happens should also delete dates if excessive labels showing
        didSet {
            savePickerChosenDaysToDisk()
            setPickerDaysEqualFlag()
        }
    }
    
    var timesSelected: [Meditation] = [] { // collection of dates chosen per exercise
        
        didSet(oldTimes) {
            
            setPickerDaysEqualFlag()
            if let emotion = SelectedEmotion.choice, let exercise = SelectedExercise.key, timesSelected != oldTimes {
                saveTimesSelected(emotion: emotion, exercise: exercise)
                
                if oldTimes.count > timesSelected.count { // handling labels, notifications, time selected button
                    delegate?.handleRemovedTimes(oldMeditationTimes: oldTimes, emotion: emotion, exercise: exercise)
                } else if timesSelected.count > oldTimes.count {
                    delegate?.handleAddedTimes(oldMeditationTimes: oldTimes, emotion: emotion, exercise: exercise)
                }
            }
        }
        
    }
    
    init(emotion: EmotionTypeEncompassing, exercise: String) {
        self.emotion = emotion
        self.exercise = exercise
        self.exerciseComplete = false

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
            let data = try? JSONEncoder().encode(timesSelected)
            if let data = data {
                UserDefaults.standard.set(data, forKey: "\(emotionRawValue)$\(exercise)")
            }
        }
    }
//
//    private func saveExerciseCompletedStatus() {
//        UserDefaults.standard.set(exerciseComplete, forKey: <#T##String#>)
//        // exercise string _isCompleted
//    }
//
//    private func retrieveExerciseCompletedStatus() {
//
//    }
    
    private func retrievePickerChosenDaysFromDisk(emotionRawValue: String, exercise: String) -> Int {
        let storedNumberOfDays: Int = UserDefaults.standard.integer(forKey: "\(emotionRawValue)$\(exercise)_times")
        return storedNumberOfDays == 0 ? 1 : storedNumberOfDays
    }
    

    private func retrieveTimesSelectedFromDisk(emotionRawValue: String, exercise: String) -> [Meditation] {
        if let meditationData = UserDefaults.standard.data(forKey: "\(emotionRawValue)$\(exercise)") {
            let meditations = try? JSONDecoder().decode([Meditation].self, from: meditationData)
            if let meditations = meditations {
                return meditations
            }
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

