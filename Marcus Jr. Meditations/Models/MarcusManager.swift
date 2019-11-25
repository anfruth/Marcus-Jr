//
//  MarcusManager.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 7/14/18.
//  Copyright © 2018 Andrew Fruth. All rights reserved.
//

// pick the correct quotation

// idea is to randomly select quotation, but to make sure all quotations are selected prior to showing a previous quotation twice.

import Foundation

struct MarcusManager {

    var quotation: String {
        return MarcusManager.retrieveAppropriateQuotation()
    }
    
    private static let numMarcusQuotations = 12 // Constant - MAKE SURE THIS IS ACCURATE.
    private static let marcusPermQuotationsKey = "marcusQuotationsRemaining"
    
    // generate by generateOriginalQuotationsRemaining, stores keys in localizable for marcus quotations.
    private static var quotationsRemaining: [String] {
        
        get {
            if let marcusQuotations = UserDefaults.standard.array(forKey: marcusPermQuotationsKey) as? [String] {
                return marcusQuotations
            } else {
                return []
            }
        }
        
        set(newQuotationsRemaining) {
            UserDefaults.standard.set(newQuotationsRemaining, forKey: marcusPermQuotationsKey)
        }
    }
    
    private static func retrieveAppropriateQuotation() -> String {
        if quotationsRemaining.isEmpty {
            generateOriginalQuotationsRemaining()
        }
        
        let randomIndex = Int(arc4random_uniform(UInt32(quotationsRemaining.count)))
        let marcusQuotationKey = quotationsRemaining.remove(at: randomIndex)
        let marcusQuotation = NSLocalizedString(marcusQuotationKey, comment: "marcus quotation")
        return marcusQuotation
    }
    
    // called when quotationsRemaining is empty
    private static func generateOriginalQuotationsRemaining() {
        var quotationsRemainingTemp: [String] = [] // copy made so setter is not called on every iteration
        
        for index in 1...numMarcusQuotations {
            let marcusQuotationKey = "\(index)Marcus"
            quotationsRemainingTemp.append(marcusQuotationKey)
        }
        
        quotationsRemaining = quotationsRemainingTemp
    }

}
