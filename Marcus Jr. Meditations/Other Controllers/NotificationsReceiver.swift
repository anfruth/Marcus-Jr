//
//  File.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/19/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class NotificationsReceiver: NSObject, UNUserNotificationCenterDelegate, EmotionSettable, ExerciseSettable {
    
    static var sharedInstance: NotificationsReceiver = NotificationsReceiver()
    
    weak var topViewController: UIViewController?
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler(.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        // navigationController case
        if let topViewController = topViewController, let nav = topViewController.navigationController {
            proceedToExerciseFromNav(topViewController: topViewController, nav: nav, notification: response.notification)
        } else {
            if let nav = UIStoryboard(name: "ChooseEmotion", bundle: nil).instantiateViewController(withIdentifier: "meditationsNav") as? UINavigationController {
                if let topViewController = nav.visibleViewController {
                    proceedToExerciseFromNav(topViewController: topViewController, nav: nav, notification: response.notification)
                }
            }
        }
        
        completionHandler()
    }
    
    private func proceedToExerciseFromNav(topViewController: UIViewController, nav: UINavigationController, notification: UNNotification) {
        
        nav.popToRootViewController(animated: true)
            // now go to correct emotion, then correct exercise
            // "\(emotion.rawValue)$\(exercise)$\(date.description)"
            
        let identifier = notification.request.identifier
        let substrings = identifier.split(separator: "$")
        
        let emotion = substrings[0]
        let exercise = substrings[1]
        
        if let emotion = Emotion.getEmotionFromRawValue(rawValue: "\(emotion)") {
            setChoice(emotion: emotion)
        }
        
        setExerciseKey(exerciseKey: "\(exercise)")
        
        let storyboard = UIStoryboard(name: "ChooseEmotion", bundle: nil)
        if let meditationVC = storyboard.instantiateViewController(withIdentifier: "meditationList") as? MeditationListTableController {
            nav.pushViewController(meditationVC, animated: true)
            
            if let dailyExerciseController = storyboard.instantiateViewController(withIdentifier: "dailyExerciseVC") as? DailyExerciseViewController {
                nav.pushViewController(dailyExerciseController, animated: true)
            }
        }
        
        
    }
    
    
}
