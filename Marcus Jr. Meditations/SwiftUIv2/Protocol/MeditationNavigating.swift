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

extension MeditationNavigating {
    
    private var routingState: RoutingState {
        return NotificationsReceiver.sharedInstance.routingState
    }
    
    func handleRoutingOnAppear() {
        if routingState.isActive {
            handleRoutingOnChange()
        }
    }
    
    func handleRoutingOnChange() {
        if let meditationId = routingState.meditationId, let emotionText = routingState.emotionText {
            route(using: meditationId, through: emotionText)
        }
    }
}
