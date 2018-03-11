//
//  PickerViewController.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 3/11/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController {

    @IBOutlet weak var selectButton: UIButton!
    let pickerView = UIPickerView()
    var pickerChosenDays: Int = 1 // consider making a model so as to rely on copy data in segues
    var originalButtonColor = UIColor.blue
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        pickerView.selectRow(pickerChosenDays - 1, inComponent: 0, animated: true)
    }
    
    @IBAction func didSelectPickerOption(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        presentingViewController?.navigationController?.navigationBar.isUserInteractionEnabled = true
        presentingViewController?.navigationController?.navigationBar.tintColor = originalButtonColor
    }
    
}
