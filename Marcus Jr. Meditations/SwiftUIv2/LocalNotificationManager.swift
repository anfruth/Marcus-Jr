//
//  LocalNotififcationManager.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 8/1/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import Foundation
import UserNotifications

protocol MeditationNotifiable {
    func addNotification(using configuration: NotificationConfig)
    func deleteNotifications(with configurations: [NotificationConfig])
}

struct NotificationConfig {
    let exercise: String
    let date: Date
    let emotion: String
}

final class LocalNotificationManager: MeditationNotifiable {
    
    func addNotification(using configuration: NotificationConfig) {
        let content = getContentForNotification(for: configuration.exercise)
        let trigger = getTriggerForNotification(date: configuration.date)

        let identifier = "\(configuration.emotion)$\(configuration.exercise)$\(configuration.date.description)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (error) in
            #if DEBUG
                if let error = error {
                    print(error.localizedDescription)
                }
            #endif
        }
    }
    
    func deleteNotifications(with configurations: [NotificationConfig]) {
        let ids = configurations.map {
            return "\($0.emotion)$\($0.exercise)$\($0.date.description)"
        }
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
    }
    
    private func getContentForNotification(for exercise: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Time to Meditate!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: NSLocalizedString(exercise, comment: "The meditation title"), arguments: nil)
        content.categoryIdentifier = "meditationCategory"
        content.sound = UNNotificationSound.default

        return content
    }
    
    private func getTriggerForNotification(date: Date) -> UNCalendarNotificationTrigger {
        let calendar = Calendar.current
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute]
        let dateComponents = calendar.dateComponents(components, from: date)
        return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    }
}
