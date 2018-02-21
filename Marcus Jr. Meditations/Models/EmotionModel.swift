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
        
        if let lhs = lhs as? EmotionTypeGeneral, let rhs = rhs as? EmotionTypeGeneral {
            return lhs.rawValue == rhs.rawValue
        } else if let lhs = lhs as? NegativeEmotionType, let rhs = rhs as? NegativeEmotionType {
            return lhs.rawValue == rhs.rawValue
        } else if let lhs = lhs as? PositiveEmotionType, let rhs = rhs as? PositiveEmotionType {
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
            emotion = NegativeEmotionType.loss
        case "Anger":
            emotion = NegativeEmotionType.anger
        case "Sadness":
            emotion = NegativeEmotionType.sadness
        case "Anxiety":
            emotion = NegativeEmotionType.anxiety
        case "Envy":
            emotion = NegativeEmotionType.envy
        case "Perseverance":
            emotion = PositiveEmotionType.perseverance
        case "Discipline":
            emotion = PositiveEmotionType.discipline
        case "Empathy":
            emotion = PositiveEmotionType.empathy
        case "Courage":
            emotion = PositiveEmotionType.courage
        default:
            break
        }
        
        return emotion
        
    }
    
    static func getRawValue(from emotion: EmotionTypeEncompassing) -> String? {
        
        if let emotion = emotion as? EmotionTypeGeneral {
            return emotion.rawValue
        } else if let emotion = emotion as? NegativeEmotionType {
            return emotion.rawValue
        } else if let emotion = emotion as? PositiveEmotionType {
            return emotion.rawValue
        }
        
        return nil
        
    }
    
    static func getAllEmotionTypes() -> [EmotionTypeEncompassing] {
        
        return NegativeEmotionType.allValues as [EmotionTypeEncompassing] + PositiveEmotionType.allValues as [EmotionTypeEncompassing]
    }
}

enum EmotionTypeGeneral: String, EmotionType, EmotionTypeEncompassing {
    typealias EmotionCategory = EmotionTypeGeneral
    
    case universal = "Universal"
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

    


