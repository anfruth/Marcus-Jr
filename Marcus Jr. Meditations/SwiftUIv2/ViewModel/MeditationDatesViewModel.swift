//
//  MeditationDatesViewModel.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 7/2/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import Foundation

final class MeditationDatesViewModel: ObservableObject {
    
    @Published var datesToDisplay: [String]
    @Published var showDuplicateMeditationError = false
    @Published var showMaxMeditationError = false
    
    var selectedDate: Date
    let maxMeditationTimes = 50
    
    private var dates = [Date]()
    private let meditation: Meditation
    
    init(dates: [Date], meditation: Meditation, selectedDate: Date) {
        self.dates = dates
        self.meditation = meditation
        self.selectedDate = selectedDate
        datesToDisplay = []
        
        loadInitialListOfDates()
        datesToDisplay = formattedDates
    }
    
    // inefficient way of maintaining sorted list, but list will be too small to matter.
    private var formattedDates: [String] {
        return dates.sorted().map {
            return DateFormatter.localizedString(from: $0, dateStyle: .medium, timeStyle: .short)
        }
    }
    
    func loadInitialListOfDates() {
        let reflectionTimeDescriptions = ReflectionTimeFactory.sharedInstance.loadReflectionTimes(from: meditation, maxReflections: maxMeditationTimes)
        dates = reflectionTimeDescriptions.compactMap { $0.meditationDate }
    }
    
    func insert(date: Date) {
        showMaxMeditationError = false
        showDuplicateMeditationError = false
        
        if dates.count >= maxMeditationTimes {
            showMaxMeditationError = true
            return
        }
        
        if dates.contains(date) {
            showDuplicateMeditationError = true
            return
        }
        
        dates.append(date)
        datesToDisplay = formattedDates
        
        ReflectionTimeFactory.sharedInstance.createReflectionTime(from: meditation, on: date)
    }
    
    func delete(at index: Int) {
        let date = dates[index]
        showDuplicateMeditationError = false
        dates.remove(at: index)
        datesToDisplay = formattedDates
        
        ReflectionTimeFactory.sharedInstance.deleteRelectionTime(from: meditation, on: date)
    }
}
