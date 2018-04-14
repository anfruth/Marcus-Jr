//
//  PickerViewController.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 3/11/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, NotificationsVC {

    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var originalButtonColor = UIColor.blue
    var meditationTimes: MeditationTimes?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentingViewController?.navigationController?.isNavigationBarHidden = true
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        
        view.insertSubview(blurEffectView, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setAsTopViewController()
        
        if let meditationTimes = meditationTimes {
            pickerView.selectRow(meditationTimes.pickerChosenDays - 1, inComponent: 0, animated: true)
        }
    }
    
    @IBAction func didSelectPickerOption(_ sender: UIButton) {
        presentingViewController?.navigationController?.isNavigationBarHidden = false
        NotificationsReceiver.sharedInstance.topViewController = presentingViewController
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIPickerView Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    // MARK: - UIPickerView Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row + 1)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let meditationTimes = meditationTimes {
            meditationTimes.pickerChosenDays = row + 1
        }
    }
    
}
