//
//  MeditationDatesViewModel.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 7/2/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import Foundation

final class MeditationDatesViewModel: EmotionRouter, ObservableObject {
    
    @Published var showAlert = false
    @Published var datesToDisplay: [String]
    @Published var showDuplicateMeditationError = false
    @Published var showMaxMeditationError = false
    
    private let notificationManager: MeditationNotifiable
    private(set) var alertInfo: AlertInfo?
    
    var selectedDate: Date
    let maxMeditationTimes = 50
    
    private var dates = [Date]()
    private let meditation: Meditation
    let emotionDescription: EmotionDescription
    
    init(dates: [Date], meditation: Meditation, selectedDate: Date,
         notificationManager: MeditationNotifiable, emotionDescription: EmotionDescription) {
        self.dates = dates
        self.meditation = meditation
        self.selectedDate = selectedDate
        self.notificationManager = notificationManager
        self.emotionDescription = emotionDescription
        self.datesToDisplay = []
        
        super.init(emotion: emotionDescription.emotion ?? "")
        
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
        
        guard let exercise = meditation.localizedId, let emotion = emotionDescription.emotion else {
            // maybe add error showing something fatal. This should never be called.
            return
        }
        
        dates.append(date)
        datesToDisplay = formattedDates
        
        notificationManager.addNotification(using: NotificationConfig(exercise: exercise, date: date, emotion: emotion))
        ReflectionTimeFactory.sharedInstance.createReflectionTime(from: meditation, on: date)
    }
    
    func delete(at index: Int) {
        guard let exercise = meditation.localizedId, let emotion = emotionDescription.emotion else {
            // maybe add error showing something fatal. This should never be called.
            return
        }
        
        let date = dates[index]
        showDuplicateMeditationError = false
        dates.remove(at: index)
        datesToDisplay = formattedDates
    
        let notificationConfig = NotificationConfig(exercise: exercise, date: date, emotion: emotion)
        
        notificationManager.deleteNotifications(with: [notificationConfig])
        ReflectionTimeFactory.sharedInstance.deleteRelectionTime(from: meditation, on: date)
    }
    
    func deleteAllDates() {
        alertInfo = AlertInfo(title: NSLocalizedString("Delete Meditation Times", comment: "Delete all comment"),
                              message: NSLocalizedString("Are you sure you want to delete all your meditation times for this meditation?", comment: "Are you sure comment"),
                              acceptActionOption: NSLocalizedString("Delete", comment: "Delete comment"),
                              declineActionOption: "Back",
                              acceptAction:
                                { [weak self] in
                                    guard let self else { return false }
                                    guard let exercise = meditation.localizedId, let emotion = emotionDescription.emotion else {
                                        // maybe add error showing something fatal. This should never be called.
                                        return false
                                    }
                                    let notificationConfigs = dates.map {
                                        NotificationConfig(exercise: exercise, date: $0, emotion: emotion)
                                    }
                                    notificationManager.deleteNotifications(with: notificationConfigs)
                                    dates.removeAll()
                                    datesToDisplay = formattedDates
            
                                    do {
                                        try ReflectionTimeFactory.sharedInstance.deleteAllRelectionTime(from: meditation)
                                    } catch {
                                        print(error.localizedDescription)
                                        print("failed to batch delete meditation dates")
                                    }
                                        
                                    return false
                                },
                              declineAction: nil
        )
        
        showAlert = true
    }
}
