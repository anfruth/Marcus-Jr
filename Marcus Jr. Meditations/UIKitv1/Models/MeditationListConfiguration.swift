//
//  MeditationListConfiguration.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/10/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import Foundation

struct MeditationListConfiguration {
    
    private(set) static var universalEmotionKeys: [String] = getOrderedMeditationsByEmotion(orderByEmotion: EmotionTypeGeneral.universal)
    
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
        
        return keys.sorted() // reorder these keys by number in key
        
    }
    
    static let dict: [String: [EmotionTypeEncompassing]] = [
        
       "00What_is":                  [EmotionTypeGeneral.universal],
       "01Be_unattached":            [EmotionTypeGeneral.universal],
       "02Desire_things":            [EmotionTypeGeneral.universal],
       "03Nothing_is":               [EmotionTypeGeneral.universal],
       "04Remind_yourself":          [NegativeEmotionType.loss, NegativeEmotionType.anger, NegativeEmotionType.sadness],
       "05Our_view":                 [NegativeEmotionType.anxiety, NegativeEmotionType.sadness],
       "06Do_not":                   [NegativeEmotionType.loss, NegativeEmotionType.envy],
       "07Be_ready":                 [NegativeEmotionType.loss],
       "08Seek the":                 [PositiveEmotionType.perseverance, PositiveEmotionType.discipline],
       "09You_cannot":               [NegativeEmotionType.loss, NegativeEmotionType.envy],
       "10The_price":               [NegativeEmotionType.anxiety],
       "11Be_indifferent":          [NegativeEmotionType.anxiety],
       "12Do_not":                  [NegativeEmotionType.anxiety, NegativeEmotionType.sadness],
       "13Be_indifferent":          [NegativeEmotionType.anxiety, NegativeEmotionType.envy],
       "14Be_kind":                 [PositiveEmotionType.empathy],
       "15Act_the":                 [NegativeEmotionType.sadness, NegativeEmotionType.envy],
       "16Every_circumstance":      [NegativeEmotionType.anxiety, NegativeEmotionType.sadness],
       "17Seek_freedom":            [NegativeEmotionType.envy],
       "18You_decide":              [NegativeEmotionType.anger],
       "19Death_makes":             [NegativeEmotionType.loss, NegativeEmotionType.anxiety, NegativeEmotionType.sadness, PositiveEmotionType.courage],
       "20Be_prepared":             [NegativeEmotionType.sadness, NegativeEmotionType.anxiety],
       "21Externals_should":        [NegativeEmotionType.sadness, NegativeEmotionType.anxiety],
       "22Do_not":                  [PositiveEmotionType.discipline, PositiveEmotionType.courage],
       "23The_price":               [PositiveEmotionType.perseverance, PositiveEmotionType.courage],
       "24React_the":               [NegativeEmotionType.loss, NegativeEmotionType.sadness],
       "25The_evil":                [NegativeEmotionType.anger],
       "26Don't_let":               [NegativeEmotionType.anger, NegativeEmotionType.anxiety, NegativeEmotionType.sadness],
       "27Understand_the":          [PositiveEmotionType.perseverance, PositiveEmotionType.discipline, PositiveEmotionType.courage],
       "28Be_good":                 [NegativeEmotionType.anger, PositiveEmotionType.empathy],
       "29Good_and":                [NegativeEmotionType.anger, NegativeEmotionType.sadness],
       "30Be_indifferent":          [NegativeEmotionType.anxiety],
       "31Think_clearly":           [PositiveEmotionType.discipline, PositiveEmotionType.perseverance],
       "32Do_good":                 [PositiveEmotionType.courage, PositiveEmotionType.perseverance],
       "33Appreciate_others":       [PositiveEmotionType.empathy],
       "34Know_your":               [NegativeEmotionType.sadness, NegativeEmotionType.loss],
       "35Guard_against":           [PositiveEmotionType.discipline],
       "36Moderation_is":           [NegativeEmotionType.sadness, NegativeEmotionType.anger],
       "37Perceive_your":           [PositiveEmotionType.discipline],
       "38Your_main":               [PositiveEmotionType.discipline],
       "39Do_not":                  [NegativeEmotionType.anger, PositiveEmotionType.empathy],
       "40Use_wisdom":              [NegativeEmotionType.anger, PositiveEmotionType.empathy],
       "41Superficial_qualities":   [NegativeEmotionType.envy],
       "42Dont_judge":              [PositiveEmotionType.empathy, NegativeEmotionType.anger],
       "43Don't_talk":              [PositiveEmotionType.discipline],
       "44Do_not":                  [PositiveEmotionType.discipline],
       "45You_should":              [NegativeEmotionType.envy],
       "46Action_matters":          [PositiveEmotionType.perseverance, PositiveEmotionType.discipline],
       "47Put_your":                [PositiveEmotionType.perseverance, PositiveEmotionType.discipline],
    ]
    
}
