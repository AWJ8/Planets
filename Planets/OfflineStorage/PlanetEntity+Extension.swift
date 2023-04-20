//
//  Planet+Extension.swift
//  Planets
//
//  Created by Aleksander Jasinski on 19/04/23.
//
//  This extension adds helper methods for managing PlanetEntity objects in the Core Data store.

import Foundation
import CoreData

extension PlanetEntity {
    
    // Save an array of Planet objects to the managed object context, replacing any existing objects.
    static func savePlanets(_ planets: [Planet], moc: NSManagedObjectContext) {
        deletePlanets(moc: moc)
        
        planets.forEach {
            let planetEntity = NSEntityDescription.insertNewObject(forEntityName: "PlanetEntity", into: moc) as? PlanetEntity
            planetEntity?.name = $0.name
        }
        
        // Save the changes to the managed object context.
        CoreDataStackManager.shared.saveContext()
    }

    // Fetch an array of Planet objects from the managed object context.
    static func fetchPlanets(moc: NSManagedObjectContext) -> [Planet] {
        let fr = PlanetEntity.fetchRequest()
        let planetEntaties = try? moc.fetch(fr)
        
        // Convert the array of PlanetEntity objects to an array of Planet objects.
        return planetEntaties?.map { $0.mapToPlanet() } ?? []
    }

    // Delete all PlanetEntity objects from the managed object context.
    static func deletePlanets(moc: NSManagedObjectContext) {
        let fr = PlanetEntity.fetchRequest()
        let planetEntaties = try? moc.fetch(fr)
        
        // Iterate through the array of PlanetEntity objects and delete each one from the managed object context.
        planetEntaties?.forEach {
            moc.delete($0)
        }
    }
}
