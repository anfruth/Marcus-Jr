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
    let pickerView = UIPickerView()
    var originalButtonColor = UIColor.blue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        pickerView.backgroundColor = UIColor.white
        view.addSubview(pickerView)
    
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        let viewMargins = view.safeAreaLayoutGuide
        pickerView.widthAnchor.constraint(equalTo: viewMargins.widthAnchor).isActive = true
        pickerView.centerXAnchor.constraint(equalTo: viewMargins.centerXAnchor).isActive = true
        
        let selectButtonMargins = selectButton.safeAreaLayoutGuide
        pickerView.bottomAnchor.constraint(equalTo: selectButtonMargins.topAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setAsTopViewController()
        pickerView.selectRow(MeditationTimes.pickerChosenDays - 1, inComponent: 0, animated: true)
    }
    
    @IBAction func didSelectPickerOption(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        presentingViewController?.navigationController?.navigationBar.isUserInteractionEnabled = true
        presentingViewController?.navigationController?.navigationBar.tintColor = originalButtonColor
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
        MeditationTimes.pickerChosenDays = row + 1
    }
    
}
