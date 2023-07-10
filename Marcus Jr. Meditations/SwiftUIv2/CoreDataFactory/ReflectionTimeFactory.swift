//
//  ReflectionTimeFactory.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 7/9/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import Foundation
import CoreData

final class ReflectionTimeFactory {
    
    static var sharedInstance = ReflectionTimeFactory(moc: DataController.sharedInstance.container.viewContext)
    
    let moc: NSManagedObjectContext
    
    private init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
    func loadReflectionTimes(from meditation: Meditation, maxReflections: Int) -> [ReflectionTimeDescription] {
        let request = ReflectionTimeDescription.fetchRequest()
        request.predicate = NSPredicate(format: "meditation == %@", meditation)
        request.fetchBatchSize = maxReflections
        
        return fetch(request: request)
    }
    
    func createReflectionTime(from meditation: Meditation, on date: Date) {
        let reflectionTimeDescription = ReflectionTimeDescription(context: moc)
        
        reflectionTimeDescription.meditationDate = date
        reflectionTimeDescription.meditation = meditation
        
        save()
    }
    
    func deleteRelectionTime(from meditation: Meditation, on date: Date) {
        let request = ReflectionTimeDescription.fetchRequest()
        request.predicate = NSPredicate(format: "meditation == %@ AND meditationDate == %@", meditation, date as NSDate)
        request.fetchBatchSize = 1
        
        guard let reflectionTimeDescription = fetch(request: request).first else { return }
        moc.delete(reflectionTimeDescription)
        
        save()
    }
    
    private func fetch(request: NSFetchRequest<ReflectionTimeDescription>) -> [ReflectionTimeDescription] {
        
        var reflectionTimes: [ReflectionTimeDescription] = []
        do {
            reflectionTimes = try moc.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        
        return reflectionTimes
    }
    
    private func save() {
        do {
            try moc.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
