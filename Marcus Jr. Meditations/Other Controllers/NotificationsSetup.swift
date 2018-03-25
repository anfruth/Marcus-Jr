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
    
    // alert strings
    private let notDeterminedTitle = "Not_determined_title"
    private let notDeterminedTitleComment = "not determined alert title"
    private let notDeterminedMessage = "Not_determined_message"
    private let notDeterminedMessageComment = "not determined alert message"
    private let notDeterminedOptionTitle = "Not_determined_option_title"
    private let notDeterminedOptionTitleComment = "title of option for not determined alert"
    private let deniedTitleComment = "denied alert title"
    private let deniedMessage = "Denied_message"
    private let deniedMessageComment = "Denied alert messsage"
    private let deniedOptionTitleComment = "title of option for denied alert"
    private let systemPlaceholder = "System_placeholder"
    private let systemPlaceholderComment = "system placeholder for hidden previews"
    private let permanentTitle = "Permanent_title"
    private let permanentTitleComment = "permanent alert title"
    private let permanentMessage = "Permanent_message"
    private let permanentMessageComment = "permanent alert message"
    private let skipTitle = "Skip"
    private let settingsTitle = "Settings"

    func giveAppPromptForNotifications(authorizationStatus: UNAuthorizationStatus, completionHandler: @escaping (Bool) -> ()) -> UIAlertController? {
        
        var alert = UIAlertController()
        
        if authorizationStatus == .notDetermined {
            makeNotDeterminedAlert(alert: &alert, completionHandler: completionHandler)
            
        } else if authorizationStatus == .denied {
            makeDeniedAlert(alert: &alert, completionHandler: nil)
            
        } else {
            return nil
        }
        
        alert.addAction(UIAlertAction(title: skipTitle, style: .default, handler: nil))
        
        return alert
    }
    
    private func makeNotDeterminedAlert(alert: inout UIAlertController, completionHandler:  @escaping (Bool) -> ()) {
        
        alert = UIAlertController(title: NSLocalizedString(notDeterminedTitle, comment: notDeterminedTitleComment), message: NSLocalizedString(notDeterminedMessage, comment: notDeterminedMessageComment), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString(notDeterminedOptionTitle, comment: notDeterminedOptionTitleComment), style: .default, handler: { _ in
            NotificationsSetup.sharedInstance.giveSystemPromptForNotifications(completionHandler: completionHandler)
        }))
    }
    
    func makeDeniedAlert(alert: inout UIAlertController, completionHandler: (() -> ())?) {
        
        alert = UIAlertController(title: NSLocalizedString(notDeterminedTitle, comment: deniedTitleComment), message: NSLocalizedString(deniedMessage, comment: deniedMessageComment), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString(notDeterminedOptionTitle, comment: deniedOptionTitleComment), style: .default, handler: { _ in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                completionHandler?()
            }
        }))
    }
    
    private func giveSystemPromptForNotifications(completionHandler: @escaping (Bool) -> ()) {
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                let goToMeditationAction = UNNotificationAction(identifier: "goToMeditation", title: "Go to Meditation", options: .foreground)
                
                // localize.
                let meditationCategory = UNNotificationCategory(identifier: "meditationCategory", actions: [goToMeditationAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: NSLocalizedString(self.systemPlaceholder, comment: self.systemPlaceholderComment), options: UNNotificationCategoryOptions(rawValue: 0))
                
                center.setNotificationCategories([meditationCategory])
                center.delegate = NotificationsReceiver.sharedInstance
                
                completionHandler(true)
            }
        }

    }
    
    func suggestPermanentNotifications(completionHandler: @escaping () -> ()) -> UIAlertController {
        
        let alert = UIAlertController(title: NSLocalizedString(permanentTitle, comment: permanentTitleComment), message: NSLocalizedString(permanentMessage, comment: permanentMessageComment), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: settingsTitle, style: .default, handler: { _ in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                completionHandler()
            }
        }))
        
        alert.addAction(UIAlertAction(title: skipTitle, style: .default, handler: { _ in
            completionHandler()
        }))
        
        return alert
    }
    
}
