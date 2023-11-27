//
//  MeditationListViewModel.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 6/17/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import Foundation
import CoreData

final class MeditationListViewModel: EmotionRouter, ObservableObject {
    
    struct Summary {
        let meditationID: String
        let index: Int
        let isComplete: Bool
    }
    
    @Published var meditationVM: MeditationViewModel?
    @Published var meditationSelected: Bool = false
    @Published var showAlert: Bool = false
    @Published var meditationSummaries: [Summary] = []
    
    private let emotionDescription: EmotionDescription
    private(set) var alertInfo: AlertInfo?
    private let notificationManager: MeditationNotifiable
    
    lazy private var meditations: [Meditation] = {
        return MeditationFactory.sharedInstance.getSortedMeditations(by: emotionDescription)
    }()
    
    lazy var emotionText = emotionDescription.emotion ?? ""
    
    lazy var reflectionFactory = ReflectionTimeFactory(moc: DataController.sharedInstance.container.viewContext)
    
    private func getMeditationSummaries() -> [Summary] {
        return meditations.enumerated().map { (index, meditation) in
            let id = NSLocalizedString(meditation.localizedId ?? "", comment: "Meditation Summary")
            let isComplete = meditationComplete(from: index)
            return Summary(meditationID: id, index: index, isComplete: isComplete)
        }
    }
    
    init(emotionDescription: EmotionDescription, notificationManager: MeditationNotifiable) {
        self.emotionDescription = emotionDescription
        self.notificationManager = notificationManager
        
        super.init(emotion: emotionDescription.emotion ?? "")
        meditationSummaries = getMeditationSummaries()
    }
    
    func updateMeditationSummaries() {
        meditationSummaries = getMeditationSummaries()
    }
    
    func meditationComplete(from index: Int) -> Bool {
        guard index < meditations.count else { return false }
        
        return meditations[index].visitedAfterFinalTime
    }
    
    func anyMeditationComplete() -> Bool {
        let completedMeditation = meditations.first {
            $0.visitedAfterFinalTime == true
        }
        
        return completedMeditation != nil
    }
    
    func showSingleSelectedMeditationPreview(from index: Int) {
        if index < meditations.count {
            let meditationSummary = getMeditationSummaries()[index]
            meditationSummaries = [meditationSummary]
        }
    }
    
    func selectMeditation(from index: Int) {
        if index < meditations.count {
            meditationSelected = true
            let meditation = meditations[index]
            meditationVM = MeditationViewModel(meditation: meditation, emotionDescription: emotionDescription)
        }
    }
    
    func selectMeditation(from id: String) {
        let meditation = meditations.first { $0.localizedId == id }
        if let meditation {
            meditationSelected = true
            meditationVM = MeditationViewModel(meditation: meditation, emotionDescription: emotionDescription)
        }
    }
    
    func deleteAllDates() {
        alertInfo = AlertInfo(title: NSLocalizedString("Reset Meditations", comment: "Reset Meditations comment"),
                              message: NSLocalizedString("Are you sure you want to reset all your meditations for this emotion?", comment: "Are you sure comment"),
                              acceptActionOption: NSLocalizedString("Reset", comment: "Reset comment"),
                              declineActionOption: "Back",
                              acceptAction:
                                { [weak self] in
                                guard let self else { return false }
                                
                                let reflectionTimes = reflectionFactory.loadReflectionTimes(from: emotionDescription)
                                
                                let notificationConfigs: [NotificationConfig] = reflectionTimes.compactMap {
                                    guard let date = $0.meditationDate, let routedEmotion = $0.routedEmotion?.emotion, let exercise = $0.meditation?.localizedId else { return nil }
                                    return NotificationConfig(exercise: exercise, date: date, emotion: routedEmotion)
                                }
                                
                                do {
                                    try reflectionFactory.deleteAllRelectionTime(from: emotionDescription)
                                    notificationManager.deleteNotifications(with: notificationConfigs)
                                    meditationSummaries = getMeditationSummaries()
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
