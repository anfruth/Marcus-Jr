//
//  MeditationViewModel.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 7/1/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import Foundation

final class MeditationViewModel {
    
    private let meditation: Meditation
    
    init(meditation: Meditation) {
        self.meditation = meditation
    }
    
    var commentaryAvailable: Bool {
        return commentary != (meditation.localizedId ?? "") + "_commentary"
    }
    
    var actionAvailable: Bool {
        action != (meditation.localizedId ?? "") + "_action"
    }
    
    var enchiridionChapter: String {
        return NSLocalizedString((meditation.localizedId ?? "") + "_title", comment: "Enchiridion Chapter")
    }
    
    var quotation: String {
        return "\"" + NSLocalizedString((meditation.localizedId ?? "") + "_quotation", comment: "Enchiridion Quotation") + "\""
    }
    
    var commentary: String {
        return NSLocalizedString((meditation.localizedId ?? "") + "_commentary", comment: "Meditation Commentary")
    }
    
    var action: String {
        return NSLocalizedString((meditation.localizedId ?? "") + "_action", comment: "Meditation Action")
    }
    
}
