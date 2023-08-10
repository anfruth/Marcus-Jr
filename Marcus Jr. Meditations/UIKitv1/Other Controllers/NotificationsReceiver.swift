//
//  NotificationsReceiver.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/19/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class RoutingState: ObservableObject {
    @Published var isActive = false
    var meditationId: String?
    var emotionText: String?
}

class NotificationsReceiver: NSObject, UNUserNotificationCenterDelegate, ObservableObject {
    
    let routingState = RoutingState()
    
    static let sharedInstance: NotificationsReceiver = NotificationsReceiver()
    
    var didReceiveLocalNotification: Bool?
    var notificationsResponse: UNNotificationResponse?
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler(.banner)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        
        // now go to correct emotion, then correct exercise
        // "\(emotion.rawValue)$\(exercise)$\(date.description)"

        let identifier = response.notification.request.identifier
        let substrings = identifier.split(separator: "$")

        let emotion = String(substrings[0])
        let exercise = String(substrings[1])
        
        routingState.isActive = true
        routingState.emotionText = emotion
        routingState.meditationId = exercise
        UINavigationBar.setAnimationsEnabled(false)
        
        completionHandler()
    }
}
