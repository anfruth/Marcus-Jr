//
//  MeditationListConfiguration.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/10/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import Foundation

struct MeditationListConfiguration {
    
    static func castedEmotionType(emotions: [Any]) -> [EmotionType] {
        var emotionList: [EmotionType] = []
    
        for emotion in emotions {
            if let emotion = emotion as? EmotionType {
                emotionList.append(emotion)
            } else {
                fatalError("Meditation List Not Configured Correctly")
            }
        }
        
        return emotionList
    }
    
    static let dict: [Int: [EmotionType]] = [1: castedEmotionType(emotions: [Emotion.EmotionTypeGeneral.universal]),
                                             
       2: castedEmotionType(emotions: [Emotion.EmotionTypeGeneral.universal]),
       3: castedEmotionType(emotions: [Emotion.EmotionTypeGeneral.universal]),
       4: castedEmotionType(emotions: [Emotion.EmotionTypeGeneral.universal]),
       5: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.loss, NegativeEmotion.NegativeEmotionType.anger, NegativeEmotion.NegativeEmotionType.sadness]),
       6: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.anxiety, NegativeEmotion.NegativeEmotionType.sadness]),
       7: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.loss, NegativeEmotion.NegativeEmotionType.envy]),
       8: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.loss]),
       9: castedEmotionType(emotions: [PositiveEmotion.PositiveEmotionType.perseverance, PositiveEmotion.PositiveEmotionType.discipline]),
       10: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.loss, NegativeEmotion.NegativeEmotionType.envy]),
       11: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.anxiety]),
       12: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.anxiety]),
       13: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.anxiety, NegativeEmotion.NegativeEmotionType.sadness]),
       14: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.anxiety, NegativeEmotion.NegativeEmotionType.envy]),
       15: castedEmotionType(emotions: [PositiveEmotion.PositiveEmotionType.empathy]),
       16: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.sadness, NegativeEmotion.NegativeEmotionType.envy]),
       17: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.anxiety, NegativeEmotion.NegativeEmotionType.sadness]),
       18: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.envy]),
       19: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.anger]),
       20: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.loss, NegativeEmotion.NegativeEmotionType.anxiety, NegativeEmotion.NegativeEmotionType.sadness, PositiveEmotion.PositiveEmotionType.courage]),
       21: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.sadness, NegativeEmotion.NegativeEmotionType.anxiety]),
       22: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.sadness, NegativeEmotion.NegativeEmotionType.anxiety]),
       23: castedEmotionType(emotions: [PositiveEmotion.PositiveEmotionType.discipline, PositiveEmotion.PositiveEmotionType.courage]),
       24: castedEmotionType(emotions: [PositiveEmotion.PositiveEmotionType.perseverance, PositiveEmotion.PositiveEmotionType.courage]),
       25: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.loss, NegativeEmotion.NegativeEmotionType.sadness]),
       26: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.anger]),
       27: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.anger, NegativeEmotion.NegativeEmotionType.anxiety, NegativeEmotion.NegativeEmotionType.sadness]),
       28: castedEmotionType(emotions: [PositiveEmotion.PositiveEmotionType.perseverance, PositiveEmotion.PositiveEmotionType.discipline, PositiveEmotion.PositiveEmotionType.courage]),
       29: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.anger, PositiveEmotion.PositiveEmotionType.empathy]),
       30: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.anger, NegativeEmotion.NegativeEmotionType.sadness]),
       31: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.anxiety]),
       32: castedEmotionType(emotions: [PositiveEmotion.PositiveEmotionType.discipline, PositiveEmotion.PositiveEmotionType.perseverance]),
       33: castedEmotionType(emotions: [PositiveEmotion.PositiveEmotionType.courage, PositiveEmotion.PositiveEmotionType.perseverance]),
       34: castedEmotionType(emotions: [PositiveEmotion.PositiveEmotionType.empathy]),
       35: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.sadness, NegativeEmotion.NegativeEmotionType.loss]),
       36: castedEmotionType(emotions: [PositiveEmotion.PositiveEmotionType.discipline]),
       37: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.sadness, NegativeEmotion.NegativeEmotionType.anger]),
       38: castedEmotionType(emotions: [PositiveEmotion.PositiveEmotionType.discipline]),
       39: castedEmotionType(emotions: [PositiveEmotion.PositiveEmotionType.discipline]),
       40: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.anger, PositiveEmotion.PositiveEmotionType.empathy]),
       41: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.anger, PositiveEmotion.PositiveEmotionType.empathy]),
       42: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.envy]),
       43: castedEmotionType(emotions: [PositiveEmotion.PositiveEmotionType.empathy, NegativeEmotion.NegativeEmotionType.anger]),
       44: castedEmotionType(emotions: [PositiveEmotion.PositiveEmotionType.discipline]),
       45: castedEmotionType(emotions: [PositiveEmotion.PositiveEmotionType.discipline]),
       46: castedEmotionType(emotions: [NegativeEmotion.NegativeEmotionType.envy]),
       47: castedEmotionType(emotions: [PositiveEmotion.PositiveEmotionType.perseverance, PositiveEmotion.PositiveEmotionType.discipline]),
       48: castedEmotionType(emotions: [PositiveEmotion.PositiveEmotionType.perseverance, PositiveEmotion.PositiveEmotionType.discipline]),
       49: castedEmotionType(emotions: [PositiveEmotion.PositiveEmotionType.perseverance, PositiveEmotion.PositiveEmotionType.discipline])]
    
}
