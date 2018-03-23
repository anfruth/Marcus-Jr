//
//  NotificationsSetup.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 3/22/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class NotificationsSetup {
    
    static let sharedInstance = NotificationsSetup()
    
    func giveAppPromptForNotifications(authorizationStatus: UNAuthorizationStatus, completionHandler: @escaping (Bool) -> ()) -> UIAlertController? {
        
        var alert = UIAlertController()
        
        if authorizationStatus == .notDetermined {
            makeNotDeterminedAlert(alert: &alert, completionHandler: completionHandler)
            
        } else if authorizationStatus == .denied {
            makeDeniedAlert(alert: &alert)
            
        } else {
            return nil
        }
        
        alert.addAction(UIAlertAction(title: "Skip", style: .default, handler: nil))
        
        return alert
    }
    
    private func makeNotDeterminedAlert(alert: inout UIAlertController, completionHandler:  @escaping (Bool) -> ()) {
        
        alert = UIAlertController(title: "Enable Notifications", message: "Allow the app to send you reminders to meditate based on the times you choose. Without enabling, no reminders will be sent and you will be unable to set meditation times.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Enable Notifications", style: .default, handler: { _ in
            NotificationsSetup.sharedInstance.giveSystemPromptForNotifications(completionHandler: completionHandler)
        }))
    }
    
    private func makeDeniedAlert(alert: inout UIAlertController) {
        
        alert = UIAlertController(title: "Enable Notifications in Settings", message: "Enable permanent banner notifications in settings in order to set meditation times. You may choose temporary banners, but they are not recommended. Marcus Jr. Meditations -> Notifications -> Show as Banners -> Persistent.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Turn On Notifications", style: .default, handler: { _ in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
    }
    
    private func giveSystemPromptForNotifications(completionHandler: @escaping (Bool) -> ()) {
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                let goToMeditationAction = UNNotificationAction(identifier: "goToMeditation", title: "Go to Meditation", options: .foreground)
                
                // localize.
                let meditationCategory = UNNotificationCategory(identifier: "meditationCategory", actions: [goToMeditationAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "Time to Meditate. Head on over to your daily meditation.", options: UNNotificationCategoryOptions(rawValue: 0))
                
                center.setNotificationCategories([meditationCategory])
                center.delegate = NotificationsReceiver.sharedInstance
                
                completionHandler(true)
            }
        }

    }
    
    func suggestPermanentNotifications(completionHandler: @escaping () -> ()) -> UIAlertController {
        
        let alert = UIAlertController(title: "Turn on Permanent Notifications", message: " Go to Settings to turn on permanent notifications so your meditation time reminder doesn't disappear. Marcus Jr. Meditations -> Notifications -> Show as Banners -> Persistent.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                completionHandler()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Skip", style: .default, handler: { _ in
            completionHandler()
        }))
        
        return alert
    }
    
}
