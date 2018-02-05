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

    override func viewDidLoad() {
        super.viewDidLoad()


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        if let collectionView = collectionView {
            
            let layout = EmotionViewFlowLayout()

            collectionView.delegate = layout
            collectionView.collectionViewLayout = layout
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
    
            adjustCellAttributes(cell: cell, indexPath: indexPath)
            return cell
        }
        
    
        return UICollectionViewCell()
    }
    
    private func adjustCellAttributes(cell: EmotionCell, indexPath: IndexPath) {
        
        for _ in 0..<2 {
            
            if indexPath.section == 0 {
                addAttributesOnTypeOfEmotion(TypeOfEmotion: NegativeEmotion.self, cell: cell, indexPath: indexPath)
            } else if indexPath.section == 1 {
                addAttributesOnTypeOfEmotion(TypeOfEmotion: PositiveEmotion.self, cell: cell, indexPath: indexPath)
            }
            
        }
        
    }
    
    private func addAttributesOnTypeOfEmotion<T: RawRepresentable>(TypeOfEmotion: T.Type, cell: EmotionCell, indexPath: IndexPath) where T.RawValue == String {

        if let EmotionType = TypeOfEmotion as? Emotion.Type {
            for i in 0..<EmotionType.allValues.count {
                switch indexPath.item {
                case i:
                    if let negativeEmotion = EmotionType.allValues[i] as? NegativeEmotion {
                        cell.emotionLabel?.text = negativeEmotion.rawValue
                        cell.imageView?.image = UIImage(named: negativeEmotion.rawValue)
                        
                    } else if let positiveEmotion = EmotionType.allValues[i] as? PositiveEmotion {
                        cell.emotionLabel?.text = positiveEmotion.rawValue
                        cell.imageView?.image = UIImage(named: positiveEmotion.rawValue)
                    }
                default:
                    break
                }
            }
        }
        
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
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
