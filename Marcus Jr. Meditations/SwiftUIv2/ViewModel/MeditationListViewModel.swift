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
    
    init(emotion: Emotion) {
        self.emotion = emotion
    }
    
    var emotionText: String {
        return emotion.rawValue
    }
    
}
