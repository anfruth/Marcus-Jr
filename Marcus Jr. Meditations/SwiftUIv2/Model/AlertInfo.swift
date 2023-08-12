//
//  AlertInfo.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 8/12/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import Foundation

struct AlertInfo {
    let title: String
    let message: String
    let acceptActionOption: String
    let declineActionOption: String?
    ///  Bool is true if  settings url should be opened.
    let acceptAction: (() -> Bool)?
    let declineAction: (() -> Void)?
}
