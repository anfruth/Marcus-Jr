//
//  RoutingActive.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 8/5/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import Foundation
import SwiftUI

struct RoutingActive: EnvironmentKey {
    static var defaultValue = false
}

extension EnvironmentValues {
    var routingActive: Bool {
        get { self[RoutingActive.self] }
        set { self[RoutingActive.self]  = newValue }
    }
}
