//
//  NotificationsVCProtocol.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/19/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import UIKit

protocol NotificationsVC: class {
    
    func setAsTopViewController()
    
}

extension NotificationsVC {
    
    func setAsTopViewController() {
        if let currentVC = self as? UIViewController {
            NotificationsReceiver.sharedInstance.topViewController = currentVC
        }
    }
    
}

