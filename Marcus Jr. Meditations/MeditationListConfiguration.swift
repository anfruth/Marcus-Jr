//
//  MeditationListConfiguration.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/10/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import Foundation

struct MeditationListConfiguration {
    
    static func getOrderedMeditationsByEmotion<T: EmotionType>(orderByEmotion: T) -> [String] {
        var keys: [String] = []
        
        for (key, emotionList) in dict {

            for emotion in emotionList {
                if let emotion = emotion as? T {
                    if orderByEmotion == emotion {
                        keys.append(key)
                    }
                }
            }
            
        }
        
        return keys
        
    }
    
    static let dict: [String: [EmotionTypeEncompassing]] = [
        
       "What_is1":                  [Emotion.EmotionTypeGeneral.universal],
       "Be_unattached2":            [Emotion.EmotionTypeGeneral.universal],
       "Desire_things3":            [Emotion.EmotionTypeGeneral.universal],
       "Nothing_is4":               [Emotion.EmotionTypeGeneral.universal],
       "Remind_yourself5":          [NegativeEmotion.NegativeEmotionType.loss, NegativeEmotion.NegativeEmotionType.anger, NegativeEmotion.NegativeEmotionType.sadness],
       "Our_view6":                 [NegativeEmotion.NegativeEmotionType.anxiety, NegativeEmotion.NegativeEmotionType.sadness],
       "Do_not7":                   [NegativeEmotion.NegativeEmotionType.loss, NegativeEmotion.NegativeEmotionType.envy],
       "Be_ready8":                 [NegativeEmotion.NegativeEmotionType.loss],
       "Seek the9":                 [PositiveEmotion.PositiveEmotionType.perseverance, PositiveEmotion.PositiveEmotionType.discipline],
       "You_cannot10":              [NegativeEmotion.NegativeEmotionType.loss, NegativeEmotion.NegativeEmotionType.envy],
       "The_price11":               [NegativeEmotion.NegativeEmotionType.anxiety],
       "Be_indifferent12":          [NegativeEmotion.NegativeEmotionType.anxiety],
       "Do_not13":                  [NegativeEmotion.NegativeEmotionType.anxiety, NegativeEmotion.NegativeEmotionType.sadness],
       "Be_indifferent14":          [NegativeEmotion.NegativeEmotionType.anxiety, NegativeEmotion.NegativeEmotionType.envy],
       "Be_kind15":                 [PositiveEmotion.PositiveEmotionType.empathy],
       "Act_the16":                 [NegativeEmotion.NegativeEmotionType.sadness, NegativeEmotion.NegativeEmotionType.envy],
       "Every_circumstance17":      [NegativeEmotion.NegativeEmotionType.anxiety, NegativeEmotion.NegativeEmotionType.sadness],
       "Seek_freedom18":            [NegativeEmotion.NegativeEmotionType.envy],
       "You_decide19":              [NegativeEmotion.NegativeEmotionType.anger],
       "Death_makes20":             [NegativeEmotion.NegativeEmotionType.loss, NegativeEmotion.NegativeEmotionType.anxiety, NegativeEmotion.NegativeEmotionType.sadness, PositiveEmotion.PositiveEmotionType.courage],
       "Be_prepared21":             [NegativeEmotion.NegativeEmotionType.sadness, NegativeEmotion.NegativeEmotionType.anxiety],
       "Externals_should22":        [NegativeEmotion.NegativeEmotionType.sadness, NegativeEmotion.NegativeEmotionType.anxiety],
       "Do_not23":                  [PositiveEmotion.PositiveEmotionType.discipline, PositiveEmotion.PositiveEmotionType.courage],
       "The_price24":               [PositiveEmotion.PositiveEmotionType.perseverance, PositiveEmotion.PositiveEmotionType.courage],
       "React_the25":               [NegativeEmotion.NegativeEmotionType.loss, NegativeEmotion.NegativeEmotionType.sadness],
       "The_evil26":                [NegativeEmotion.NegativeEmotionType.anger],
       "Don't_let27":               [NegativeEmotion.NegativeEmotionType.anger, NegativeEmotion.NegativeEmotionType.anxiety, NegativeEmotion.NegativeEmotionType.sadness],
       "Understand_the28":          [PositiveEmotion.PositiveEmotionType.perseverance, PositiveEmotion.PositiveEmotionType.discipline, PositiveEmotion.PositiveEmotionType.courage],
       "Be_good29":                 [NegativeEmotion.NegativeEmotionType.anger, PositiveEmotion.PositiveEmotionType.empathy],
       "Good_and30":                [NegativeEmotion.NegativeEmotionType.anger, NegativeEmotion.NegativeEmotionType.sadness],
       "Be_indifferent31":          [NegativeEmotion.NegativeEmotionType.anxiety],
       "Think_clearly32":           [PositiveEmotion.PositiveEmotionType.discipline, PositiveEmotion.PositiveEmotionType.perseverance],
       "Do_good33":                 [PositiveEmotion.PositiveEmotionType.courage, PositiveEmotion.PositiveEmotionType.perseverance],
       "Appreciate_others34":       [PositiveEmotion.PositiveEmotionType.empathy],
       "Know_your35":               [NegativeEmotion.NegativeEmotionType.sadness, NegativeEmotion.NegativeEmotionType.loss],
       "Guard_against36":           [PositiveEmotion.PositiveEmotionType.discipline],
       "Moderation_is37":           [NegativeEmotion.NegativeEmotionType.sadness, NegativeEmotion.NegativeEmotionType.anger],
       "Perceive_your38":           [PositiveEmotion.PositiveEmotionType.discipline],
       "Your_main39":               [PositiveEmotion.PositiveEmotionType.discipline],
       "Do_not40":                  [NegativeEmotion.NegativeEmotionType.anger, PositiveEmotion.PositiveEmotionType.empathy],
       "Use_wisdom41":              [NegativeEmotion.NegativeEmotionType.anger, PositiveEmotion.PositiveEmotionType.empathy],
       "Superficial_qualities42":   [NegativeEmotion.NegativeEmotionType.envy],
       "Dont_judge43":              [PositiveEmotion.PositiveEmotionType.empathy, NegativeEmotion.NegativeEmotionType.anger],
       "Don't_talk44":              [PositiveEmotion.PositiveEmotionType.discipline],
       "Do_not45":                  [PositiveEmotion.PositiveEmotionType.discipline],
       "You_should46":              [NegativeEmotion.NegativeEmotionType.envy],
       "Action_matters47":          [PositiveEmotion.PositiveEmotionType.perseverance, PositiveEmotion.PositiveEmotionType.discipline],
       "Put_your48":                [PositiveEmotion.PositiveEmotionType.perseverance, PositiveEmotion.PositiveEmotionType.discipline],
       "Action_over49":             [PositiveEmotion.PositiveEmotionType.perseverance, PositiveEmotion.PositiveEmotionType.discipline]
    
    ]
    
}
