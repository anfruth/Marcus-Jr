//
//  MeditationNavigating.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 8/4/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import Foundation

protocol MeditationNavigating {
    func route(using meditationId: String, through emotionText: String)
}
