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
    
    weak var delegate: OpeningViewController?
    
    static var sharedInstance: NotificationsReceiver = NotificationsReceiver()
    
    weak var topViewController: UIViewController? {
        didSet(oldVC) {
            if oldVC == nil {
                if let response = notificationsResponse {
                    determineIfTopViewControllerFlow(response: response)
                    notificationsResponse = nil
                }
            }
        }
    }
    
    var didReceiveLocalNotification: Bool?
    var notificationsResponse: UNNotificationResponse?
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler(.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        // navigationController case
        determineIfTopViewControllerFlow(response: response)
        completionHandler()
    }
    
    private func determineIfTopViewControllerFlow(response: UNNotificationResponse) {
        if let topViewController = topViewController, let nav = topViewController.navigationController {
            proceedToExerciseFromNav(topViewController: topViewController, nav: nav, notification: response.notification)
        } else {
            didReceiveLocalNotification = true
            notificationsResponse = response
            delegate?.handleReceivingLocalNotification() // if called prior to viewDidAppear, nothing happens and will be handled by viewDidAppaer. If called after, it will segue correctly.
        }
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
            
            if let dailyExerciseContainerVC = storyboard.instantiateViewController(withIdentifier: "dailyContainerVC") as? DailyExerciseContainerViewController {
                
                if let dailyExerciseController = storyboard.instantiateViewController(withIdentifier: "dailyExerciseVC") as? DailyExerciseViewController {
                    
                    dailyExerciseContainerVC.addChildViewController(dailyExerciseController)
                    nav.pushViewController(dailyExerciseContainerVC, animated: true)
                }
                
            }
        }
        
        
    }
    
    
}
