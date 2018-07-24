//
//  OpeningViewController.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/24/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import UIKit

class OpeningViewController: UIViewController {
    
    @IBOutlet weak var marcusQuotationView: UIView!
    @IBOutlet weak var marcusQuotationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationsReceiver.sharedInstance.delegate = self
    }

    // what if viewDidAppear before notificaiton?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleReceivingLocalNotification()
    }
    
    @IBAction func beginButtonClicked(_ sender: UIButton) {
        
        UIView.animate(withDuration: 1.0, animations: {
            let marcusManager = MarcusManager()
            self.marcusQuotationLabel.text = marcusManager.quotation
            self.marcusQuotationView.alpha = 1
        }, completion: { (completed) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0, execute: {
                self.performSegue(withIdentifier: "toChooseEmotion", sender: self)
            })
        })
        
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
