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
    
    let toChooseEmotionSegueID = "toChooseEmotion"
    var toChooseSeguePerformed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationsReceiver.sharedInstance.delegate = self
    }

    // what if viewDidAppear before notificaiton?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleReceivingLocalNotification()
        
        if !toChooseSeguePerformed {
            let marcusManager = MarcusManager()
            self.marcusQuotationLabel.text = marcusManager.quotation
            
            UIView.animate(withDuration: 3.0, animations: {
                self.marcusQuotationView.alpha = 1
            })
        }
    }
    
    @IBAction func beginButtonClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: toChooseEmotionSegueID, sender: self)
        toChooseSeguePerformed = true
    }
    
    
    func handleReceivingLocalNotification() {
        let notificationsReceiver = NotificationsReceiver.sharedInstance
        
        if let didReceiveLocalNotification = notificationsReceiver.didReceiveLocalNotification, didReceiveLocalNotification {
            performSegue(withIdentifier: toChooseEmotionSegueID, sender: self)
            toChooseSeguePerformed = true
            notificationsReceiver.didReceiveLocalNotification = nil
        }
    }

}
