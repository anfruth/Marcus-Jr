//
//  MeditationModel.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 3/17/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import Foundation

class Meditation: Codable, Equatable { // individual meditation (one per chosen time to meditate)
    
    static func ==(lhs: Meditation, rhs: Meditation) -> Bool {
        return lhs.date == rhs.date && lhs.completed == lhs.completed
    }
    
    let exercise: String
    let date: Date
    
    var completed: Bool {
        return Date() >= date
    }
    
    init(date: Date, exercise: String) {
        self.date = date
        self.exercise = exercise
    }
    
}
