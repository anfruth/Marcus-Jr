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
    
    var exerciseComplete: Bool { // complete when all meditation times have passed, can't possibly be true until its set in MeditationTimesTableVC
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
            if timesSelected != oldTimes {
                saveTimesSelected(emotion: emotion, exercise: exercise)
                
                if oldTimes.count > timesSelected.count { // handling labels, notifications, time selected button
                    delegate?.handleRemovedTimes(oldMeditationTimes: oldTimes, emotion: emotion, exercise: exercise)
                } else if timesSelected.count > oldTimes.count {
                    delegate?.handleAddedTimes(oldMeditationTimes: oldTimes, emotion: emotion, exercise: exercise)
                }
            }
            
            setExerciseAsCompletedIfNeeded()
        }
        
    }
    
    init(emotion: EmotionTypeEncompassing, exercise: String) {
        self.emotion = emotion
        self.exercise = exercise
        self.exerciseComplete = false

        setTimesSelectedAndPickerDays()
    }
    
    func resetCompletedExercise() {
        timesSelected = []
        pickerChosenDays = 1
    }
    
    func setExerciseAsCompletedIfNeeded() {

        for meditation in timesSelected {
            if !meditation.completed {
                exerciseComplete = false
                return
            }
        }
        
        if timesSelected.count == 0 {
            exerciseComplete = false
        } else {
            exerciseComplete = true
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

    private func setTimesSelectedAndPickerDays() {
        if let emotionRawValue = Emotion.getRawValue(from: emotion) {
            // order of timesSelected before pickerChosenDays matters, if picker first, goes off incorrect value of timesSeleted, timesSelected doesnt touch pickerChosen
            timesSelected = retrieveTimesSelectedFromDisk(emotionRawValue: emotionRawValue, exercise: exercise)
            pickerChosenDays = retrievePickerChosenDaysFromDisk(emotionRawValue: emotionRawValue, exercise: exercise)
            
            setPickerDaysEqualFlag()
        }
    }
    
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

