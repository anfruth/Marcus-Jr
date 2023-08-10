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
    
    @Published var meditationVM: MeditationViewModel?
    @Published var meditationSelected: Bool = false
    
    private let emotionDescription: EmotionDescription
    private let moc: NSManagedObjectContext
    
    lazy var meditations: [Meditation] = {
        return MeditationFactory.sharedInstance.getSortedMeditations(by: emotionDescription)
    }()
    
    lazy var emotionText = emotionDescription.emotion ?? ""
    
    lazy var meditationSummaries: [(String, Int)] = {
        return meditations.enumerated().map { (index, meditation) in
            return (NSLocalizedString(meditation.localizedId ?? "", comment: "Meditation Summary"), index)
        }
    }()
    
    init(emotionDescription: EmotionDescription, moc: NSManagedObjectContext) {
        self.emotionDescription = emotionDescription
        self.moc = moc
        
        super.init(emotion: emotionDescription.emotion ?? "")
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
}
