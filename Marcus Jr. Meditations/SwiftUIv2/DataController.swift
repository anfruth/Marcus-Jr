//
//  DataController.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 7/8/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import Foundation
import CoreData

final class DataController: ObservableObject {
    
    static var sharedInstance = DataController()
    
    let container = NSPersistentContainer(name: "MarcusJr")
    
    private init() {
        container.loadPersistentStores() { description, error in
            if let error {
                fatalError("Failure on loading persistent store")
            }
        }
        
        container.viewContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyStoreTrumpMergePolicyType)
    }
    
}
