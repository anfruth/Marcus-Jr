//
//  EmotionModel.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/1/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import Foundation

protocol EmotionType {}

extension EmotionType {
    
    static func getAllEmotionTypes() -> [EmotionType] {
        
        return (NegativeEmotion.NegativeEmotionType.allValues as [EmotionType]) + (PositiveEmotion.PositiveEmotionType.allValues as [EmotionType])
    }
    
}

class Emotion: EmotionType {}

class NegativeEmotion: Emotion {
    
    let emotion: NegativeEmotionType
    
    init(emotion: NegativeEmotionType) {
        self.emotion = emotion
    }
    
    enum NegativeEmotionType: String, EmotionType {
        
        case loss = "Loss"
        case anger = "Anger"
        case sadness = "Sadness"
        case anxiety = "Anxiety"
        case envy = "Envy"
        
        static var allValues: [NegativeEmotionType] {
            return [NegativeEmotionType.loss, NegativeEmotionType.anger, NegativeEmotionType.sadness, NegativeEmotionType.anxiety, NegativeEmotionType.envy]
        }
    }
    
}

class PositiveEmotion: Emotion {
    let emotion: PositiveEmotionType
    
    init(emotion: PositiveEmotionType) {
        self.emotion = emotion
    }
    
    enum PositiveEmotionType: String, EmotionType {
        
        case perseverance = "Perseverance"
        case discipline = "Discipline"
        case empathy = "Empathy"
        case courage = "Courage"
        
        static var allValues: [PositiveEmotionType] {
            return [PositiveEmotionType.perseverance, PositiveEmotionType.discipline, PositiveEmotionType.empathy, PositiveEmotionType.courage]
        }
        
    }

}


    


