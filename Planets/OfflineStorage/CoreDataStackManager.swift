//
//  CoreDataManager.swift
//  Planets
//
//  Created by Aleksander Jasinski on 19/04/23.
//
//  This class manages the Core Data stack and provides a shared instance for easy access.

import Foundation
import CoreData

final class CoreDataStackManager {
    
    // MARK: - Core Data stack
    
    // Shared instance of the CoreDataStackManager for use throughout the app.
    static let shared = CoreDataStackManager()
    
    // Create a lazy-loaded NSPersistentContainer for the "Planets" data model.
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Planets")
        
        // Load the persistent stores and handle any errors that may occur.
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        // Return the configured container.
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    // Save any changes in the managed object context to the persistent store.
    func saveContext () {
        // Get the managed object context from the persistent container.
        let context = persistentContainer.viewContext
        
        // Check if there are any changes in the context.
        if context.hasChanges {
            do {
                // Attempt to save the changes to the persistent store.
                try context.save()
            } catch {
                // Handle any errors that may occur during the save operation.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
