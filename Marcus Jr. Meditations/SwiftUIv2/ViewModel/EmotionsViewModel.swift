//
//  EmotionsViewModel.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 6/19/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import Foundation

final class EmotionsViewModel: ObservableObject {
    
    @Published var emotionsInGrid = Emotion.allCases
    @Published var selectedEmotion: Emotion?
    @Published var isShowingMeditationList = false
    
    func meditations(from emotion: Emotion) -> [Meditation] {
        guard let meditationsIds = emotionMeditationIdMap[emotion] else { return [] }
        return meditationsIds.compactMap { Meditation(id: $0) }
    }
    
    private lazy var emotionMeditationIdMap = loadEmotionMeditationIdMap()
    
    private func loadEmotionMeditationIdMap() -> [Emotion: [String]]  {
        guard let configPath = Bundle.main.path(forResource: "EmotionConfig", ofType: "plist"),
              let configData = FileManager.default.contents(atPath: configPath) else { return [:] }
        
        let decoder = PropertyListDecoder()
        guard let decodedPlist = try? decoder.decode([String: [String]].self, from: configData) else { return [:] }
        
        let map: [Emotion: [String]] = Dictionary(uniqueKeysWithValues: decodedPlist.compactMap { (Emotion(rawValue: $0) ?? .loss, $1) })
        
        return map
    }
    
}
