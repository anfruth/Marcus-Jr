//
//  OpeningViewController.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/24/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import UIKit

class OpeningViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationsReceiver.sharedInstance.delegate = self
    }

    // what if viewDidAppear before notificaiton?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleReceivingLocalNotification()
    }
    
    func viewAppearedBeforeNotification() {
        if view != nil {
            handleReceivingLocalNotification()
        }
    }
    
    func handleReceivingLocalNotification () {
        let notificationsReciver = NotificationsReceiver.sharedInstance
        if let didReceiveLocalNotification = notificationsReciver.didReceiveLocalNotification {
            if didReceiveLocalNotification {
                performSegue(withIdentifier: "toChooseEmotion", sender: self)
                notificationsReciver.didReceiveLocalNotification = nil
            }
            
        }
    }

}
