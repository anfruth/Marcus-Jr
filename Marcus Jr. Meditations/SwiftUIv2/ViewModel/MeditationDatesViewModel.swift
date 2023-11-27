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
    @Published var selectedDate: Date
    
    private let notificationManager: MeditationNotifiable
    private(set) var alertInfo: AlertInfo?
    
    let maxMeditationTimes = 10
    
    private var dates = [Date]() {
        didSet {
            if dates.isEmpty {
                MeditationFactory.sharedInstance.markCompletionStatus(meditation: meditation, finished: false)
            }
        }
    }
    private let meditation: Meditation
    let emotionDescription: EmotionDescription
    
    lazy var reflectionFactory = ReflectionTimeFactory(moc: DataController.sharedInstance.container.viewContext)
    
    // TODO: Handle MeditationFactory.sharedInstance.markCompletionStatus(meditation: meditation, finished: false) when at 0 meditation times case, all scenarios. Maybe didSet on dates.G
    // a meditation is only finished if all reflection times have passed. If no reflection times, it is not finished.
    
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
        self.selectedDate = nextMinute(from: selectedDate)
    }
    
    // inefficient way of maintaining sorted list, but list will be too small to matter.
    private var formattedDates: [String] {
        return dates.map {
            return DateFormatter.localizedString(from: $0, dateStyle: .medium, timeStyle: .short)
        }
    }
    
    func reflectionTimeComplete(from index: Int) -> Bool {
        guard index < dates.count else { return true }
        
        let meditationDate = dates[index]
        return Date.now > meditationDate
    }
    
    func nextMinute(from date: Date) -> Date {
        let roundedDownMinutes = (date.timeIntervalSinceReferenceDate / 60).rounded(.down)
        let roundedDownMinutesInSeconds = roundedDownMinutes * 60
        return Date(timeIntervalSinceReferenceDate: roundedDownMinutesInSeconds + 60)
    }
    
    func loadInitialListOfDates() {
        let reflectionTimeDescriptions = reflectionFactory.loadReflectionTimes(from: meditation, maxReflections: maxMeditationTimes)
        dates = reflectionTimeDescriptions.compactMap { $0.meditationDate }.sorted(by: >)
    }
    
    @MainActor
    func insert(date: Date) async {
        var date = date
        let currentDate = Date.now
        showMaxMeditationError = false
        showDuplicateMeditationError = false
        
        if date < currentDate {
            date = nextMinute(from: currentDate)
        }
        
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
        
        do {
            try await notificationManager.addNotification(using: NotificationConfig(exercise: exercise, date: date, emotion: emotion))
        } catch {
            alertInfo = AlertInfo(title: NSLocalizedString("Meditation Time Limitation Reached", comment: "Maximum meditation times"),
                                  message: NSLocalizedString("You are only allowed to have a maximum of 64 unfinished meditation times app-wide. Please either wait for your current meditation times to complete or delete any meditation times occuring in the future.", comment: "Are you sure comment"),
                                  acceptActionOption: NSLocalizedString("Ok", comment: "Ok comment"),
                                  declineActionOption: nil,
                                  acceptAction: nil,
                                  declineAction: nil
                        )
            showAlert = true
            return
        }
        
        dates.append(date)
        dates.sort(by: >)
        datesToDisplay = formattedDates
        
        reflectionFactory.createReflectionTime(from: meditation, on: date, emotion: emotionDescription)
        MeditationFactory.sharedInstance.markCompletionStatus(meditation: meditation, finished: false)
    }

    
    func delete(at index: Int) {
        guard let exercise = meditation.localizedId else {
            // maybe add error showing something fatal. This should never be called.
            return
        }
        
        guard index < dates.count else { return }
        let date = dates[index]
        showDuplicateMeditationError = false
        dates.remove(at: index)
        dates.sort(by: >)
        datesToDisplay = formattedDates
        
        if !dates.isEmpty && reflectionTimeComplete(from: dates.count - 1) {
            MeditationFactory.sharedInstance.markCompletionStatus(meditation: meditation, finished: true)
        }
    
        // Cannot assume current routed emotion is the same emotion used when reflection time was created.
        guard let reflectionTime = reflectionFactory.getReflectionTime(from: meditation, on: date) else { return }
        guard let emotionDescription = reflectionTime.routedEmotion, let emotion = emotionDescription.emotion else { return }
        let notificationConfig = NotificationConfig(exercise: exercise, date: date, emotion: emotion)
        
        notificationManager.deleteNotifications(with: [notificationConfig])
        reflectionFactory.delete(reflectionTime: reflectionTime)
    }
    
    func deleteAllDates() {
        alertInfo = AlertInfo(title: NSLocalizedString("Delete Meditation Times", comment: "Delete all comment"),
                              message: NSLocalizedString("Are you sure you want to delete all your meditation times for this meditation?", comment: "Are you sure comment"),
                              acceptActionOption: NSLocalizedString("Delete", comment: "Delete comment"),
                              declineActionOption: "Back",
                              acceptAction:
                                { [weak self] in
                                    guard let self else { return false }
                                    guard let exercise = meditation.localizedId else {
                                        // maybe add error showing something fatal. This should never be called.
                                        return false
                                    }
                                    
                                    let reflectionTimes = reflectionFactory.loadReflectionTimes(from: meditation, maxReflections: maxMeditationTimes)
            
                                    let notificationConfigs: [NotificationConfig] = reflectionTimes.compactMap {
                                        guard let date = $0.meditationDate, let routedEmotion = $0.routedEmotion?.emotion else { return nil }
                                        return NotificationConfig(exercise: exercise, date: date, emotion: routedEmotion)
                                    }
            
                                    do {
                                        try reflectionFactory.deleteAllRelectionTime(from: meditation)
                                        notificationManager.deleteNotifications(with: notificationConfigs)
                                        dates.removeAll()
                                        datesToDisplay = formattedDates
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
