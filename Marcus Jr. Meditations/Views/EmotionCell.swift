//
//  EmotionCell.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/1/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import UIKit

class EmotionCell: UICollectionViewCell {
    
    @IBOutlet weak var emotionLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        emotionLabel?.text = ""
    }
    
}
