//
//  AppDelegate.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/1/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // should put alert letting people know why we need alerts
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if !granted {
                // show option of setting meditation times, but when click button to set, shows alert saying have to enable notifications in settings. Click here: settings link.
                // can check before button pressed if notifications allow it ( so maybe this isn't needed at all!)
            }
            
            let goToMeditationAction = UNNotificationAction(identifier: "goToMeditation", title: "Go to Meditation", options: .foreground)
            
            // localize.
            let meditationCategory = UNNotificationCategory(identifier: "meditationCategory", actions: [goToMeditationAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "Time to Meditate. Head on over to your daily meditation.", options: UNNotificationCategoryOptions(rawValue: 0))
            
            center.setNotificationCategories([meditationCategory])
        }
        
        center.delegate = NotificationsReceiver.sharedInstance
        
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

