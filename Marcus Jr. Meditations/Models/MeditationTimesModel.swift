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
                saveTimesSelected(exercise: exercise)
                
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
    
    private func savePickerChosenDaysToDisk() {
        if let exercise = SelectedExercise.key {
            UserDefaults.standard.set(pickerChosenDays, forKey: "\(exercise)_times")
        }
    }
    
    private func saveTimesSelected(exercise: String) {
        let data = try? JSONEncoder().encode(timesSelected)
        if let data = data {
            UserDefaults.standard.set(data, forKey: "\(exercise)")
        }
    }

    private func setTimesSelectedAndPickerDays() {
        // order of timesSelected before pickerChosenDays matters, if picker first, goes off incorrect value of timesSeleted, timesSelected doesnt touch pickerChosen
        timesSelected = retrieveTimesSelectedFromDisk(exercise: exercise)
        pickerChosenDays = retrievePickerChosenDaysFromDisk(exercise: exercise)
        
        setPickerDaysEqualFlag()
    }
    
    private func retrievePickerChosenDaysFromDisk(exercise: String) -> Int {
        let storedNumberOfDays: Int = UserDefaults.standard.integer(forKey: "\(exercise)_times")
        return storedNumberOfDays == 0 ? 1 : storedNumberOfDays
    }
    

    private func retrieveTimesSelectedFromDisk(exercise: String) -> [Meditation] {
        if let meditationData = UserDefaults.standard.data(forKey: exercise) {
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

