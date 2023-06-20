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
    
    var enchiridionChapter: String {
        return NSLocalizedString(id + "_title", comment: "Enchiridion Chapter")
    }
    
    var summary: String {
        return NSLocalizedString(id, comment: "Meditation Summary")
    }
    
    var quotation: String {
        return NSLocalizedString(id + "_quotation", comment: "Enchiridion Quotation")
    }
    
    var commentary: String {
        return NSLocalizedString(id + "_commentary", comment: "Meditation Commentary")
    }
    
    var action: String {
        return NSLocalizedString(id + "_action", comment: "Meditation Action")
    }
    
    init(id: String, reflectionTimes: [Date] = [], visitedAfterFinalTime: Bool = false) {
        self.id = id
        self.reflectionTimes = reflectionTimes
        self.visitedAfterFinalTime = visitedAfterFinalTime
    }
    
}
