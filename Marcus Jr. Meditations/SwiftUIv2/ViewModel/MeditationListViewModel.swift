//
//  MeditationListViewModel.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 6/17/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import Foundation

final class MeditationListViewModel {
    
    let emotion: Emotion
    let meditations: [Meditation]
    
    init(emotion: Emotion, meditations: [Meditation]) {
        self.emotion = emotion
        self.meditations = meditations
    }
    
    var emotionText: String {
        return emotion.rawValue
    }
    
}
