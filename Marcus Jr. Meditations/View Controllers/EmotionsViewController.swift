//
//  EmotionsViewController.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/1/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import UIKit

protocol EmotionSettable {
    func setChoice(emotion: EmotionTypeEncompassing)
}

extension EmotionSettable {
    
    func setChoice(emotion: EmotionTypeEncompassing) {
        SelectedEmotion.choice = emotion
    }
    
}

struct SelectedEmotion {
    fileprivate(set) static var choice: EmotionTypeEncompassing?
}

class EmotionsViewController: UICollectionViewController, NotificationsVC {
    
    private let emotionCellIdentifier = "emotionCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionView = collectionView {
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 1
            layout.minimumInteritemSpacing = 1
            collectionView.collectionViewLayout = layout
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setAsTopViewController()x   
    }

    // MARK: UIContent Container Protocol

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    
        guard let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
    
        layout.invalidateLayout()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Emotion.getAllEmotionTypes().count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emotionCellIdentifier, for: indexPath) as? EmotionCell {
            
            var indexOfAllEmotionTypeArray = 0
            if indexPath.section == 1 {
               indexOfAllEmotionTypeArray = 5 // number of negativeEmotions
            }
            
            addAttributesOnTypeOfEmotion(indexOfAllEmotionTypeArray: indexOfAllEmotionTypeArray, cell: cell, indexPath: indexPath)
        
            if (indexPath.item + 1) % 3 == 2 {
                cell.backgroundColor = UIColor(red:0.30, green:0.39, blue:0.55, alpha:1.0)
            } else if (indexPath.item + 1) % 3 == 1 {
                cell.backgroundColor = UIColor(red:0.16, green:0.21, blue:0.33, alpha:1.0)
            } else {
                cell.backgroundColor = UIColor(red:0.12, green:0.12, blue:0.15, alpha:1.0)
            }
            
            return cell
        }
        
    
        return UICollectionViewCell()
    }
    
    private func addAttributesOnTypeOfEmotion(indexOfAllEmotionTypeArray: Int, cell: EmotionCell, indexPath: IndexPath) {

        for (i, emotionType) in Emotion.getAllEmotionTypes().enumerated() {
            if i - indexOfAllEmotionTypeArray == indexPath.item {
                var rawValue: String = ""
                
                if let positiveEmotionType = emotionType as? PositiveEmotionType {
                    rawValue = positiveEmotionType.rawValue
                } else if let negativeEmotionType = emotionType as? NegativeEmotionType {
                    rawValue = negativeEmotionType.rawValue
                }
                
                cell.emotionLabel?.text = rawValue
                cell.imageView?.image = UIImage(named: rawValue)
            }
        }
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? EmotionCell, let cellTitle = cell.emotionLabel.text {
            if let emotion: EmotionTypeEncompassing = Emotion.getEmotionFromRawValue(rawValue: cellTitle) {
                SelectedEmotion.choice = emotion
                performSegue(withIdentifier: "toMeditations", sender: self)
            }
        }
        
    }

}

extension EmotionsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let widthOfCollectionView = collectionView.bounds.width
        
        guard let collectionViewFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: widthOfCollectionView, height: widthOfCollectionView)
        }
        
        let lessThanHalfCollectionView = 1/2 * widthOfCollectionView - collectionViewFlowLayout.minimumInteritemSpacing / 2
        
        if UIScreen.main.traitCollection.horizontalSizeClass == .compact && UIScreen.main.traitCollection.verticalSizeClass == .compact {
            return CGSize(width: lessThanHalfCollectionView, height: lessThanHalfCollectionView / 2)
            
        } else if UIScreen.main.traitCollection.horizontalSizeClass == .compact {
            return CGSize(width: lessThanHalfCollectionView, height: lessThanHalfCollectionView)

        } else {
            let lessThanQuarterCollectionView = 1/4 * widthOfCollectionView - collectionViewFlowLayout.minimumInteritemSpacing * 3 / 4
            return CGSize(width: lessThanQuarterCollectionView, height: lessThanQuarterCollectionView)
        }
    }
    
}
