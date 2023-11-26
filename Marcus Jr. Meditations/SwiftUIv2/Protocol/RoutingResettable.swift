//
//  RoutingResettable.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 11/25/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import Foundation
import UIKit

protocol RoutingResettable {
    func completeRouting()
}

extension RoutingResettable {
    func completeRouting() {
        NotificationsReceiver.sharedInstance.routingState.isActive = false
        NotificationsReceiver.sharedInstance.routingState.meditationId = nil
        NotificationsReceiver.sharedInstance.routingState.emotionText = nil
        UINavigationBar.setAnimationsEnabled(true)
    }
}
