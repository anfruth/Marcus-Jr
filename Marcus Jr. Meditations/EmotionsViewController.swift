//
//  EmotionsViewController.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/1/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

import UIKit

class EmotionsViewController: UICollectionViewController {
    
    private let emotionCellIdentifier = "emotionCell"
    private var selectedEmotion: String?

    override func viewDidLoad() {
        super.viewDidLoad()


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        if let collectionView = collectionView {
            
            let layout = UICollectionViewFlowLayout()
            collectionView.collectionViewLayout = layout
            
            layout.headerReferenceSize = CGSize(width: collectionView.bounds.width, height: CGFloat(100))
        }
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
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
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 5 // negative emotions
        }
        
        return 4 // positive emotions
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emotionCellIdentifier, for: indexPath) as? EmotionCell {
            
            var indexOfAllEmotionTypeArray = 0
            if indexPath.section == 1 {
               indexOfAllEmotionTypeArray = 5 // number of negativeEmotions
            }
            
            addAttributesOnTypeOfEmotion(indexOfAllEmotionTypeArray: indexOfAllEmotionTypeArray, cell: cell, indexPath: indexPath)
            return cell
        }
        
    
        return UICollectionViewCell()
    }
    
    private func addAttributesOnTypeOfEmotion(indexOfAllEmotionTypeArray: Int, cell: EmotionCell, indexPath: IndexPath) {

        for (i, emotionType) in Emotion.getAllEmotionTypes().enumerated() {
            if i - indexOfAllEmotionTypeArray == indexPath.item {
                var rawValue: String = ""
                
                if let positiveEmotionType = emotionType as? PositiveEmotion.PositiveEmotionType {
                    rawValue = positiveEmotionType.rawValue
                } else if let negativeEmotionType = emotionType as? NegativeEmotion.NegativeEmotionType {
                    rawValue = negativeEmotionType.rawValue
                }
                
                cell.emotionLabel?.text = rawValue
                cell.imageView?.image = UIImage(named: rawValue)
            }
        }
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? EmotionCell {
            selectedEmotion = cell.emotionLabel?.text
            let dailyMeditationStoryboard = UIStoryboard(name: "ChooseEmotion", bundle: Bundle.main)
            if let dailyMeditationListVC = dailyMeditationStoryboard.instantiateViewController(withIdentifier: "meditationList") as? MeditationListTableController {
            
                navigationController?.pushViewController(dailyMeditationListVC, animated: true)
                dailyMeditationListVC.emotionTitle = selectedEmotion
            }
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader {
            
            if indexPath.section == 0 {
                sectionHeader.sectionTitle?.text = "Tackle Your Negative Emotions"
            } else {
                sectionHeader.sectionTitle?.text = "Improve Your Character"
            }
            
            return sectionHeader
        }
        
        return UICollectionReusableView()
        
    }

}

extension EmotionsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthOfCollectionView = collectionView.bounds.width
        
        if UIScreen.main.traitCollection.horizontalSizeClass == .compact {
            return CGSize(width: widthOfCollectionView, height: widthOfCollectionView)
            
        } else if UIScreen.main.traitCollection.horizontalSizeClass == .regular {
            let lessThanHalfCollectionView = 0.495 * widthOfCollectionView
            return CGSize(width: lessThanHalfCollectionView, height: lessThanHalfCollectionView)
            
        } else {
            return CGSize()
        }
    }
    
}
