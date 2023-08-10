//
//  EmotionRouting.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 8/4/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import Foundation

protocol EmotionRouting {
    var emotion: String { get }
    func isRoutedEmotionCorrect(from emotionText: String) -> Bool
}

extension EmotionRouting {
    func isRoutedEmotionCorrect(from emotionText: String) -> Bool {
        guard let emotionFromRawValue = Emotion(rawValue: emotionText) else { return false }
        return emotionFromRawValue.rawValue == emotion
    }
}
