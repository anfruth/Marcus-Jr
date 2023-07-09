//
//  MeditationListViewModel.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 6/17/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import Foundation
import CoreData

final class MeditationListViewModel: ObservableObject {
    
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
    }
    
    func selectMeditation(from index: Int) {
        if index < meditations.count {
            meditationSelected = true
            let meditation = meditations[index]
            meditationVM = MeditationViewModel(meditation: meditation)
        }
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
