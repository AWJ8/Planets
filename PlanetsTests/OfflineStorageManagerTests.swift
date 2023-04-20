//
//  OfflineStorageManagerTests.swift
//  PlanetsTests
//
//  Created by Aleksander Jasinski on 19/04/2023.
//

import XCTest
@testable import Planets
import CoreData

class OfflineStorageManagerTests: XCTestCase {
    
    var offlineStorageManager: OfflineStorageManager!
    var mockPersistentContainer: NSPersistentContainer!
    
    override func setUp() {
        super.setUp()

        // Create an in-memory Core Data stack for testing
        guard let modelURL = Bundle(for: type(of: self)).url(forResource: "Planets", withExtension: "momd"),
              let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to find or load data model")
        }
        
        mockPersistentContainer = NSPersistentContainer(name: "Planets", managedObjectModel: managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        mockPersistentContainer.persistentStoreDescriptions = [description]
        mockPersistentContainer.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }

        // Initialize the OfflineStorageManager with the mock stack
        offlineStorageManager = OfflineStorageManager(persistentContainer: mockPersistentContainer)
    }

    
    override func tearDown() {
        offlineStorageManager = nil
        mockPersistentContainer = nil
        
        super.tearDown()
    }
    
    func arraysContainSameElements<T: Equatable>(array1: [T], array2: [T]) -> Bool {
        return array1.count == array2.count && array1.allSatisfy { element in array2.contains(element) }
    }

    func testSaveAndFetchPlanets() {
        let planets = [
            Planet(name: "Earth"),
            Planet(name: "Mars")
        ]
        
        // Save the planets
        offlineStorageManager.savePlanets(planets)
        
        // Fetch the planets
        let fetchedPlanets = offlineStorageManager.fetchPlanets()
        
        // Test if the saved planets and fetched planets match
        XCTAssertTrue(arraysContainSameElements(array1: planets, array2: fetchedPlanets))
    }

    
    func testFetchEmptyPlanets() {
        // Fetch planets when there are none saved
        let fetchedPlanets = offlineStorageManager.fetchPlanets()
        
        // Test if the fetched planets array is empty
        XCTAssertTrue(fetchedPlanets.isEmpty)
    }
}
