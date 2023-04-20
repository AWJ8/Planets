//
//  OfflineStorageManager.swift
//  Planets
//
//  Created by Aleksander Jasinski on 19/04/23.
//

import CoreData

protocol OfflineStorageContract {
    func savePlanets(_ planets: [Planet])
    func fetchPlanets() -> [Planet]
}

class OfflineStorageManager: OfflineStorageContract {
    
    let persistentContainer: NSPersistentContainer
    init(persistentContainer: NSPersistentContainer = CoreDataStackManager.shared.persistentContainer) {
        self.persistentContainer = persistentContainer
    }

    // Save an array of Planet objects to the persistent container.
    func savePlanets(_ planets: [Planet]) {
        PlanetEntity.savePlanets(planets, moc: persistentContainer.viewContext)
    }

    // Fetch an array of Planet objects from the persistent container.
    func fetchPlanets() -> [Planet] {
        return PlanetEntity.fetchPlanets(moc: persistentContainer.viewContext)
    }
}
