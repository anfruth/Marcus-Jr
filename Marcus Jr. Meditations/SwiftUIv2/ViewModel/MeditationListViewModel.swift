//
//  MeditationListViewModel.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 6/17/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import Foundation

final class MeditationListViewModel: ObservableObject {
    
    @Published var meditationVM: MeditationViewModel?
    @Published var meditationSelected: Bool = false
    
    private let emotion: Emotion
    private let meditations: [Meditation]
    
    lazy var emotionText = emotion.rawValue
    
    lazy var meditationSummaries: [(String, Int)] = {
        return meditations.enumerated().map { (index, meditation) in
            return (NSLocalizedString(meditation.id, comment: "Meditation Summary"), index)
        }
    }()
    
    init(emotion: Emotion, meditations: [Meditation]) {
        self.emotion = emotion
        self.meditations = meditations
    }
    
    func selectMeditation(from index: Int) {
        if index < meditations.count {
            meditationSelected = true
            let meditation = meditations[index]
            meditationVM = MeditationViewModel(meditation: meditation)
        }
    }
    
}
