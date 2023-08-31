//
//  MeditationFactory.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 7/8/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import Foundation

import Foundation
import CoreData

final class MeditationFactory {
    
    static var sharedInstance = MeditationFactory(moc: DataController.sharedInstance.container.viewContext)
    
    private let moc: NSManagedObjectContext
    private var inMemoryStore = [String: Meditation]() // Meditation localization id and meditation
    
    private init(moc: NSManagedObjectContext) {
        self.moc = moc
        loadAllMeditationsIntoMemory()
    }
    
    private func loadAllMeditationsIntoMemory() {
        let request = Meditation.fetchRequest()
        //request.predicate = NSPredicate(format: "emotions contains[cd]")
        
        var meditations: [Meditation] = []
        
        do {
            meditations = try moc.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        
        meditations.forEach { meditation in
            if let localizedId = meditation.localizedId {
                inMemoryStore[localizedId] = meditation
            }
        }
    }
    
    func getSortedMeditations(by emotion: EmotionDescription) -> [Meditation] {
        return createMeditationsIfNeeded(from: emotion).sorted {
            $0.localizedId ?? "" < $1.localizedId ?? ""
        }
    }
    
    func markCompletionStatus(meditation: Meditation, finished: Bool) {
        meditation.visitedAfterFinalTime = finished
        
        do {
            try moc.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func createMeditationsIfNeeded(from emotionDescription: EmotionDescription) -> [Meditation] {
        
        var linkedMeditationsSet = Set<String>() // set of localization ids from disk
        
        var linkedMeditations = allMeditationsLinked(to: emotionDescription) // from disk
        
        linkedMeditations.forEach { meditation in
            if let localizedId = meditation.localizedId {
                inMemoryStore[localizedId] = meditation // save to memory from disk
                linkedMeditationsSet.insert(localizedId)
            }
        }

        
        guard let emotionEnum = convert(from: emotionDescription) else { return [] } // Serious issues if this returns
        let requiredLocalizedIds = Set(getMeditationIds(from: emotionEnum)) // localized ids that should be linked (from plist)
        let remainingLocalizationIds = requiredLocalizedIds.subtracting(linkedMeditationsSet)
        
        // check if remaining localization ids are in memory. If so link.
        // going to load all existing meditations into memory for now (small enough it doesn't matter)
        
        var idsMissingFromMemory = Set<String>()
        
        remainingLocalizationIds.forEach { localizationId in
            let meditation = inMemoryStore[localizationId]
            if let meditation {
                meditation.addToEmotions(emotionDescription)
                linkedMeditations.append(meditation)
            } else {
                idsMissingFromMemory.insert(localizationId)
            }
        }
       
        // whatever localization ids are left needs to be created and saved to disk and memory (since was found in neither location)
        idsMissingFromMemory.forEach { localizationId in
            let meditation = Meditation(context: moc)
            
            meditation.localizedId = localizationId
            meditation.visitedAfterFinalTime = false
            meditation.addToEmotions(emotionDescription)
            
            inMemoryStore[localizationId] = meditation
            linkedMeditations.append(meditation)
        }
        
            
        do {
            try moc.save()
        } catch {
            print(error.localizedDescription)
        }
        
        return linkedMeditations
    }
    
    private func allMeditationsLinked(to emotionDescription: EmotionDescription) -> [Meditation] {
        let request = Meditation.fetchRequest()
        request.predicate = NSPredicate(format: "emotions contains[cd] %@", emotionDescription)
        
        var meditations: [Meditation] = []
        
        do {
            meditations = try moc.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        
       // guard let emotionEnum = convert(from: emotionDescription) else { return false }
        return meditations// == getMeditationIds(from: emotionEnum).count
    }
    
    private func getMeditationIds(from emotion: Emotion) -> [String] {
        guard let meditationsIds = emotionMeditationIdMap[emotion] else { return [] }
        return meditationsIds
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
    
    private func convert(from emotionDescription: EmotionDescription) -> Emotion? {
        guard let emotionString = emotionDescription.emotion, let emotionEnum = Emotion(rawValue: emotionString) else { return nil }
        return emotionEnum
    }
    
}
