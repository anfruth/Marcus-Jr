//
//  EmotionFactory.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 7/8/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import Foundation
import CoreData

final class EmotionFactory {
    
    private(set) var emotionDescriptions: [EmotionDescription] = []
    
    private let moc: NSManagedObjectContext
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
    func createEmotionsIfNeeded() {
        
        let request = EmotionDescription.fetchRequest()
        request.fetchBatchSize = Emotion.allCases.count
        
        var results: [EmotionDescription] = []
        
        do {
            results = try moc.fetch(request)
        } catch {}
        
        if results.isEmpty {
            results = Emotion.allCases.map { emotion in
                let emotionDescription = EmotionDescription(context: moc)
                emotionDescription.emotion = emotion.rawValue
                return emotionDescription
            }
            
            do {
                try moc.save()
            } catch {}
        }
        
        emotionDescriptions = results
    }
    
    func getEmotionDescription(from emotion: Emotion) -> EmotionDescription? {
        return emotionDescriptions.first { $0.emotion == emotion.rawValue }
    }
    
}
