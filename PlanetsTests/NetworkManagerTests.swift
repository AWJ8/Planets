//
//  NetworkManagerTests.swift
//  PlanetsTests
//
//  Created by Aleksander Jasinski on 18/04/2023.
//

import XCTest
@testable import Planets

// Mock NetworkApi
class MockNetworkApi: NetworkApi {
    var planetsResponse: PlanetsResponse?
    var networkError: NetworkError?

    func get<T>(url: String, type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable {
        if let planetsResponse = planetsResponse as? T {
            completion(.success(planetsResponse))
        } else if let networkError = networkError {
            completion(.failure(networkError))
        }
    }
}

// Mock OfflineStorageManager
class MockOfflineStorageManager: OfflineStorageManager {
    var planets: [Planet]?

    override func savePlanets(_ planets: [Planet]) {
        self.planets = planets
    }

    override func fetchPlanets() -> [Planet] {
        return planets ?? []
    }
}

class PlanetsServiceTests: XCTestCase {
    var service: PlanetsService!
    var mockNetworkApi: MockNetworkApi!
    var mockOfflineStorageManager: MockOfflineStorageManager!

    override func setUp() {
        super.setUp()
        mockNetworkApi = MockNetworkApi()
        mockOfflineStorageManager = MockOfflineStorageManager()
        service = PlanetsService(networkManger: mockNetworkApi, offlineStorageManager: mockOfflineStorageManager)
    }

    override func tearDown() {
        service = nil
        mockNetworkApi = nil
        mockOfflineStorageManager = nil
        super.tearDown()
    }

    func testGetPlanetsApiSuccess() {
        let planet = Planet(name: "Earth")
        let response = PlanetsResponse(results: [planet])
        mockNetworkApi.planetsResponse = response

        let expectation = self.expectation(description: "GetPlanetsApiSuccess")
        service.getPlanets(url: "dummyURL") { result in
            switch result {
            case .success(let planets):
                XCTAssertEqual(planets, [planet])
            case .failure:
                XCTFail("Expected successful response")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testGetPlanetsApiFailureOfflineDataAvailable() {
        mockNetworkApi.networkError = .invalidResponse
        let planet = Planet(name: "Earth")
        mockOfflineStorageManager.planets = [planet]

        let expectation = self.expectation(description: "GetPlanetsApiFailureOfflineDataAvailable")
        service.getPlanets(url: "dummyURL") { result in
            switch result {
            case .success(let planets):
                XCTAssertEqual(planets, [planet])
            case .failure:
                XCTFail("Expected successful response")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testGetPlanetsApiFailureOfflineDataNotAvailable() {
        mockNetworkApi.networkError = .invalidResponse
        mockOfflineStorageManager.planets = nil
        
        let expectation = self.expectation(description: "GetPlanetsApiFailureOfflineDataNotAvailable")
        service.getPlanets(url: "dummyURL") { result in
            switch result {
            case .success:
                XCTFail("Expected failed response")
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.invalidResponse)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
}
