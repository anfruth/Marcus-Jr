//
//  DailyMeditationCell.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/7/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import UIKit

class DailyMeditationCell: UITableViewCell {
    
    @IBOutlet weak var labelForDescription: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        labelForDescription?.attributedText = nil
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 50
        
        if let attributedText: NSMutableAttributedString = labelForDescription.attributedText as? NSMutableAttributedString {
            attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length - 1))
            
            labelForDescription.attributedText = attributedText
        }
        
    }

}

