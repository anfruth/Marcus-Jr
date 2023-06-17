//
//  MarcusJrApp.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/5/22.
//  Copyright © 2022 Andrew Fruth. All rights reserved.
//

import SwiftUI
@main
struct LandmarksApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            OpeningMarcusView(marcusQuotation: MarcusManager().quotation)
        }
    }
}
