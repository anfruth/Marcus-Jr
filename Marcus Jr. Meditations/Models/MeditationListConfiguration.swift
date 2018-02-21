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
        
       "What_is1":                  [EmotionTypeGeneral.universal],
       "Be_unattached2":            [EmotionTypeGeneral.universal],
       "Desire_things3":            [EmotionTypeGeneral.universal],
       "Nothing_is4":               [EmotionTypeGeneral.universal],
       "Remind_yourself5":          [NegativeEmotionType.loss, NegativeEmotionType.anger, NegativeEmotionType.sadness],
       "Our_view6":                 [NegativeEmotionType.anxiety, NegativeEmotionType.sadness],
       "Do_not7":                   [NegativeEmotionType.loss, NegativeEmotionType.envy],
       "Be_ready8":                 [NegativeEmotionType.loss],
       "Seek the9":                 [PositiveEmotionType.perseverance, PositiveEmotionType.discipline],
       "You_cannot10":              [NegativeEmotionType.loss, NegativeEmotionType.envy],
       "The_price11":               [NegativeEmotionType.anxiety],
       "Be_indifferent12":          [NegativeEmotionType.anxiety],
       "Do_not13":                  [NegativeEmotionType.anxiety, NegativeEmotionType.sadness],
       "Be_indifferent14":          [NegativeEmotionType.anxiety, NegativeEmotionType.envy],
       "Be_kind15":                 [PositiveEmotionType.empathy],
       "Act_the16":                 [NegativeEmotionType.sadness, NegativeEmotionType.envy],
       "Every_circumstance17":      [NegativeEmotionType.anxiety, NegativeEmotionType.sadness],
       "Seek_freedom18":            [NegativeEmotionType.envy],
       "You_decide19":              [NegativeEmotionType.anger],
       "Death_makes20":             [NegativeEmotionType.loss, NegativeEmotionType.anxiety, NegativeEmotionType.sadness, PositiveEmotionType.courage],
       "Be_prepared21":             [NegativeEmotionType.sadness, NegativeEmotionType.anxiety],
       "Externals_should22":        [NegativeEmotionType.sadness, NegativeEmotionType.anxiety],
       "Do_not23":                  [PositiveEmotionType.discipline, PositiveEmotionType.courage],
       "The_price24":               [PositiveEmotionType.perseverance, PositiveEmotionType.courage],
       "React_the25":               [NegativeEmotionType.loss, NegativeEmotionType.sadness],
       "The_evil26":                [NegativeEmotionType.anger],
       "Don't_let27":               [NegativeEmotionType.anger, NegativeEmotionType.anxiety, NegativeEmotionType.sadness],
       "Understand_the28":          [PositiveEmotionType.perseverance, PositiveEmotionType.discipline, PositiveEmotionType.courage],
       "Be_good29":                 [NegativeEmotionType.anger, PositiveEmotionType.empathy],
       "Good_and30":                [NegativeEmotionType.anger, NegativeEmotionType.sadness],
       "Be_indifferent31":          [NegativeEmotionType.anxiety],
       "Think_clearly32":           [PositiveEmotionType.discipline, PositiveEmotionType.perseverance],
       "Do_good33":                 [PositiveEmotionType.courage, PositiveEmotionType.perseverance],
       "Appreciate_others34":       [PositiveEmotionType.empathy],
       "Know_your35":               [NegativeEmotionType.sadness, NegativeEmotionType.loss],
       "Guard_against36":           [PositiveEmotionType.discipline],
       "Moderation_is37":           [NegativeEmotionType.sadness, NegativeEmotionType.anger],
       "Perceive_your38":           [PositiveEmotionType.discipline],
       "Your_main39":               [PositiveEmotionType.discipline],
       "Do_not40":                  [NegativeEmotionType.anger, PositiveEmotionType.empathy],
       "Use_wisdom41":              [NegativeEmotionType.anger, PositiveEmotionType.empathy],
       "Superficial_qualities42":   [NegativeEmotionType.envy],
       "Dont_judge43":              [PositiveEmotionType.empathy, NegativeEmotionType.anger],
       "Don't_talk44":              [PositiveEmotionType.discipline],
       "Do_not45":                  [PositiveEmotionType.discipline],
       "You_should46":              [NegativeEmotionType.envy],
       "Action_matters47":          [PositiveEmotionType.perseverance, PositiveEmotionType.discipline],
       "Put_your48":                [PositiveEmotionType.perseverance, PositiveEmotionType.discipline],
       "Action_over49":             [PositiveEmotionType.perseverance, PositiveEmotionType.discipline]
    
    ]
    
}
