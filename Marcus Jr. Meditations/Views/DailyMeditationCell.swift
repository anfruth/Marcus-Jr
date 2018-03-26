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
        labelForDescription?.textColor = .black
        
    }

}

