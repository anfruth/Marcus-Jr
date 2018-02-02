//
//  EmotionModel.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/1/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import Foundation



class Emotion {
    
    enum DirectionOfEmotion {
        case positive
        case negative
    }
    
    let directionOfEmotion: DirectionOfEmotion
    
    init(directionOfEmotion: DirectionOfEmotion) {
        self.directionOfEmotion = directionOfEmotion
    }
}

class NegativeEmotion: Emotion {
    
    enum TypeOfNegativeEmotion {
        case loss
        case anger
        case sadness
        case anxiety
        case envy
    }
    
    let emotion: TypeOfNegativeEmotion
    
    init(emotion: TypeOfNegativeEmotion) {
        self.emotion = emotion
        super.init(directionOfEmotion: .negative)
    }
    
}


class PositiveEmotion: Emotion {

    enum typeOfPositiveEmotion {
        case perserverance
        case discipline
        case empathy
        case courage
    }
    
}

