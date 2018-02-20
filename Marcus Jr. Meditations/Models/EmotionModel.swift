//
//  EmotionModel.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/1/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import Foundation

protocol EmotionTypeEncompassing {}

protocol EmotionType: Equatable {
    associatedtype EmotionCategory
}

extension EmotionType {
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        
        if let lhs = lhs as? Emotion.EmotionTypeGeneral, let rhs = rhs as? Emotion.EmotionTypeGeneral {
            return lhs.rawValue == rhs.rawValue
        } else if let lhs = lhs as? NegativeEmotion.NegativeEmotionType, let rhs = rhs as? NegativeEmotion.NegativeEmotionType {
            return lhs.rawValue == rhs.rawValue
        } else if let lhs = lhs as? PositiveEmotion.PositiveEmotionType, let rhs = rhs as? PositiveEmotion.PositiveEmotionType {
            return lhs.rawValue == rhs.rawValue
        }
        
        return false
    }
    
}
class Emotion {
    
    static func getEmotionFromRawValue(rawValue: String) -> EmotionTypeEncompassing? {
        
        var emotion: EmotionTypeEncompassing?
        
        switch rawValue {
        case "Universal":
            emotion = EmotionTypeGeneral.universal
        case "Loss":
            emotion = NegativeEmotion.NegativeEmotionType.loss
        case "Anger":
            emotion = NegativeEmotion.NegativeEmotionType.anger
        case "Sadness":
            emotion = NegativeEmotion.NegativeEmotionType.sadness
        case "Anxiety":
            emotion = NegativeEmotion.NegativeEmotionType.anxiety
        case "Envy":
            emotion = NegativeEmotion.NegativeEmotionType.envy
        case "Perseverance":
            emotion = PositiveEmotion.PositiveEmotionType.perseverance
        case "Discipline":
            emotion = PositiveEmotion.PositiveEmotionType.discipline
        case "Empathy":
            emotion = PositiveEmotion.PositiveEmotionType.empathy
        case "Courage":
            emotion = PositiveEmotion.PositiveEmotionType.courage
        default:
            break
        }
        
        return emotion
        
    }
    
    static func getRawValue(from emotion: EmotionTypeEncompassing) -> String? {
        
        if let emotion = emotion as? Emotion.EmotionTypeGeneral {
            return emotion.rawValue
        } else if let emotion = emotion as? NegativeEmotion.NegativeEmotionType {
            return emotion.rawValue
        } else if let emotion = emotion as? PositiveEmotion.PositiveEmotionType {
            return emotion.rawValue
        }
        
        return nil
        
    }
    
    static func getAllEmotionTypes() -> [EmotionTypeEncompassing] {
        
        return NegativeEmotion.NegativeEmotionType.allValues as [EmotionTypeEncompassing] + PositiveEmotion.PositiveEmotionType.allValues as [EmotionTypeEncompassing]
    }
    
    enum EmotionTypeGeneral: String, EmotionType, EmotionTypeEncompassing {
        typealias EmotionCategory = EmotionTypeGeneral
        
        case universal = "Universal"
    }
    
}

class NegativeEmotion: Emotion {
    
    let emotion: NegativeEmotionType
    
    init(emotion: NegativeEmotionType) {
        self.emotion = emotion
    }
    
    enum NegativeEmotionType: String, EmotionType, EmotionTypeEncompassing {
        typealias EmotionCategory = NegativeEmotionType
    
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
    
    enum PositiveEmotionType: String, EmotionType, EmotionTypeEncompassing {
        typealias EmotionCategory = PositiveEmotionType
        
        case perseverance = "Perseverance"
        case discipline = "Discipline"
        case empathy = "Empathy"
        case courage = "Courage"
        
        static var allValues: [PositiveEmotionType] {
            return [PositiveEmotionType.perseverance, PositiveEmotionType.discipline, PositiveEmotionType.empathy, PositiveEmotionType.courage]
        }
        
    }

}

    


