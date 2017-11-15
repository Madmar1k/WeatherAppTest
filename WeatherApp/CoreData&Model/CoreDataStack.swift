//
//  CoreDataStack.swift
//  WeatherApp
//
//  Created by Michil Khodulov on 13.11.2017.
//  Copyright © 2017 Michil Khodulov. All rights reserved.
//

import CoreData

class CoreDataStack: NSObject {
    
    // Singleton
    static let shared = CoreDataStack()
    private override init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
