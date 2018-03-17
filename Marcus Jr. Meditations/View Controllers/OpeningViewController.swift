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
    
    func handleReceivingLocalNotification () {
        let notificationsReceiver = NotificationsReceiver.sharedInstance
        
        if let didReceiveLocalNotification = notificationsReceiver.didReceiveLocalNotification {
            if didReceiveLocalNotification {
                performSegue(withIdentifier: "toChooseEmotion", sender: self)
                notificationsReceiver.didReceiveLocalNotification = nil
            }
            
        }
    }

}
