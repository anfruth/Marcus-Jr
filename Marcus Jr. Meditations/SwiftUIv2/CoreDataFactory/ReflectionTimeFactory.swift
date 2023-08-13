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
    
    func createReflectionTime(from meditation: Meditation, on date: Date, emotion: EmotionDescription) {
        let reflectionTimeDescription = ReflectionTimeDescription(context: moc)
        
        reflectionTimeDescription.meditationDate = date
        reflectionTimeDescription.meditation = meditation
        reflectionTimeDescription.routedEmotion = emotion
        
        save()
    }
    
    func getReflectionTime(from meditation: Meditation, on date: Date) -> ReflectionTimeDescription? {
        let request = ReflectionTimeDescription.fetchRequest()
        request.predicate = NSPredicate(format: "meditation == %@ AND meditationDate == %@", meditation, date as NSDate)
        request.fetchBatchSize = 1
        
        guard let reflectionTimeDescription = fetch(request: request).first else { return nil }
        return reflectionTimeDescription
    }
    
    
    func delete(reflectionTime: ReflectionTimeDescription) {
        moc.delete(reflectionTime)
        save()
    }
    
    func deleteAllRelectionTime(from meditation: Meditation) throws {
        // consider adding back reflection times in case merge fails to avoid invalid state
        meditation.reflectionTimes?.forEach {
            guard let reflectionTime = $0 as? ReflectionTimeDescription else { return }
            reflectionTime.routedEmotion = nil
        }
        meditation.reflectionTimes = nil
        save()
        
        let request: NSFetchRequest<any NSFetchRequestResult> = NSFetchRequest(entityName: "ReflectionTimeDescription")
        request.predicate = NSPredicate(format: "meditation == %@", meditation)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        deleteRequest.resultType = .resultTypeObjectIDs
        
        let batchResults = try moc.execute(deleteRequest) as? NSBatchDeleteResult
        let changes = [NSDeletedObjectsKey: batchResults?.result as? [NSManagedObjectID] ?? []]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [moc])
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
