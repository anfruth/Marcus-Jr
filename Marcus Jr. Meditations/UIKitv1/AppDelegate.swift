//
//  AppDelegate.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/1/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import UIKit
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        //UNUserNotificationCenter.current().delegate = NotificationsReceiver.sharedInstance
        
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        
        let largeTitleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "SanFranciscoDisplay-Regular", size: 36) as Any
        ]
        
        let standardTitleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "SanFranciscoDisplay-Regular", size: 22) as Any
        ]
        
        navAppearance.largeTitleTextAttributes = largeTitleAttributes
        navAppearance.titleTextAttributes = standardTitleAttributes
        
        UINavigationBar.appearance().standardAppearance = navAppearance
        
        return true
    }

}

