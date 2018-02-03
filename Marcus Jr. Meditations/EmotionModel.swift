//
//  EmotionModel.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/1/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import Foundation

protocol Emotion {
    static var allValues: [Emotion] { get }
}

enum NegativeEmotion: String, Emotion {
    
    case loss = "Loss"
    case anger = "Anger"
    case sadness = "Sadness"
    case anxiety = "Anxiety"
    case envy = "Envy"
    
    static var allValues: [Emotion] {
        return [NegativeEmotion.loss, NegativeEmotion.anger, NegativeEmotion.sadness, NegativeEmotion.anxiety, NegativeEmotion.envy]
    }
}

enum PositiveEmotion: String, Emotion {
    
    case perseverance = "Perseverance"
    case discipline = "Discipline"
    case empathy = "Empathy"
    case courage = "Courage"
    
    static var allValues: [Emotion] = [PositiveEmotion.perseverance, PositiveEmotion.discipline, PositiveEmotion.empathy, PositiveEmotion.courage]
}
    


