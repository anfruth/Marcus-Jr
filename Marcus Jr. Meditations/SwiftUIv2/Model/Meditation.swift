//
//  Meditation.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 6/19/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import Foundation

final class Meditation: Identifiable {
    let id: String
    
    var reflectionTimes: [Date]
    var visitedAfterFinalTime: Bool
    
    init(id: String, reflectionTimes: [Date] = [], visitedAfterFinalTime: Bool = false) {
        self.id = id
        self.reflectionTimes = reflectionTimes
        self.visitedAfterFinalTime = visitedAfterFinalTime
    }
    
}
