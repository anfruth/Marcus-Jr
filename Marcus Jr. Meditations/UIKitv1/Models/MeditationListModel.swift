//
//  MeditationListModel.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 3/18/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//


import Foundation

protocol CompleteExerciseSettable {} // only classes or structs that conform to this protocol can change the completedExercises dict.

// stores all the meditation exercises independent of an emotion or trait. Shows if the exercises are complete.
class MeditationList {
    
    fileprivate(set) static var completedExercises: [String: Bool] = [:] // faster lookup time with dictionary than with array, even though all values will be true
    
    static func retrieveMeditationListFromDisk() {
        if let completedExercisesFromDisk = UserDefaults.standard.dictionary(forKey: "completedExercises") as? [String: Bool] {
            completedExercises = completedExercisesFromDisk
        } else {
            completedExercises = [:]
        }
    }
    
}

extension CompleteExerciseSettable {
    
    static func completeExercise(exercise: String) {
        MeditationList.completedExercises[exercise] = true
    }
    
    static func resetExercise(exercise: String) {
        MeditationList.completedExercises[exercise] = nil
    }
    
    static func saveMeditationListToDisk() {
        UserDefaults.standard.set(MeditationList.completedExercises, forKey: "completedExercises")
        
    }
    
}
