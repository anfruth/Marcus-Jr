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
    
    static let sharedInstance: NotificationsReceiver = NotificationsReceiver()
    
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
        
        if let topViewController = topViewController {
            handleTopControllerSetCase(topViewController: topViewController, response: response)
        } else {
            didReceiveLocalNotification = true
            notificationsResponse = response
            delegate?.handleReceivingLocalNotification() // if called prior to viewDidAppear, nothing happens and will be handled by viewDidAppaer. If called after, it will segue correctly.
        }
    }
    
    private func handleTopControllerSetCase(topViewController: UIViewController, response: UNNotificationResponse) {
        
        if let nav = topViewController.presentingViewController?.navigationController {
            // case where top vc is being presented from controller with a navigation controller
            nav.isNavigationBarHidden = false
            self.topViewController = topViewController.presentingViewController
            topViewController.dismiss(animated: false, completion: {
                self.proceedToExerciseFromNav(nav: nav, notification: response.notification)
            })
            
        } else if let nav = topViewController.navigationController {
            proceedToExerciseFromNav(nav: nav, notification: response.notification)
        }
        
    }
    
    private func proceedToExerciseFromNav(nav: UINavigationController, notification: UNNotification) {

        nav.popToRootViewController(animated: false)
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
        instantiateViewControllersToArriveAtExercise(nav: nav)
        
    }
    
    private func instantiateViewControllersToArriveAtExercise(nav: UINavigationController) {
        
        let storyboard = UIStoryboard(name: "ChooseEmotion", bundle: nil)
        if let meditationVC = storyboard.instantiateViewController(withIdentifier: "meditationList") as? MeditationListTableController {
            nav.pushViewController(meditationVC, animated: false)
            
            if let dailyExerciseContainerVC = storyboard.instantiateViewController(withIdentifier: "dailyContainerVC") as? DailyExerciseContainerViewController {
                
                if let dailyExerciseController = storyboard.instantiateViewController(withIdentifier: "dailyExerciseVC") as? DailyExerciseViewController {
                    
                    dailyExerciseContainerVC.addChild(dailyExerciseController)
                    nav.pushViewController(dailyExerciseContainerVC, animated: false)
                }
                
            }
        }
        
    }
    
    
}
