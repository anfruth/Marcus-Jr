//
//  EmotionsViewModel.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 6/19/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import Foundation
import CoreData

final class EmotionsViewModel: ObservableObject, RoutingResettable {
    
    @Published var emotionsInGrid: [EmotionDescription] = []
    @Published var selectedEmotion: EmotionDescription?
    @Published var isShowingMeditationList = false
    
    init() {
        emotionsInGrid = sortedEmotionDescriptions
    }
    
    lazy var sortedEmotionDescriptions: [EmotionDescription] = {
        let sorted = emotionDescriptions.sorted(by: {
            let allEmotion = Emotion.allCases
            
            let firstEmotion = Emotion(rawValue: ($0.emotion ?? "")) ?? .anger
            let secondEmotion = Emotion(rawValue: ($1.emotion ?? "")) ?? .anger
            
            return allEmotion.firstIndex(of: firstEmotion) ?? 0 < allEmotion.firstIndex(of: secondEmotion) ?? 0
        })
        
        return sorted
    }()
    
    lazy private var emotionDescriptions: [EmotionDescription] = {
        EmotionFactory.sharedInstance.createEmotionsIfNeeded()
        return EmotionFactory.sharedInstance.emotionDescriptions
    }()
    
    func selectEmotion(from emotionText: String) {
        guard let emotion = Emotion(rawValue: emotionText) else {
            completeRouting()
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.selectedEmotion = EmotionFactory.sharedInstance.getEmotionDescription(from: emotion)
            self?.isShowingMeditationList = true
        }
    }
    
    func selectEmotion(from index: Int) {
        selectedEmotion = EmotionFactory.sharedInstance.getEmotionDescription(from: Emotion.allCases[index])
        if let selectedEmotion {
            emotionsInGrid = [selectedEmotion]
        }
    }

}
