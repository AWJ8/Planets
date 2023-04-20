//
//  PlanetsViewModelTests.swift
//  PlanetsTests
//
//  Created by Aleksander Jasinski on 19/04/2023.
//

import XCTest
@testable import Planets

class MockPlanetsService: PlanetsServiceContract {
    var planets: [Planet]?
    var error: NetworkError?
    
    func getPlanets(url: String, completion: @escaping (Result<[Planets.Planet], Planets.NetworkError>) -> Void) {
        if let planets = planets {
            completion(.success(planets))
        } else if let error = error {
            completion(.failure(error))
        }
    }
}

class PlanetsViewModelTests: XCTestCase {
    var viewModel: PlanetsViewModel!
    var mockService: MockPlanetsService!

    override func setUp() {
        super.setUp()
        mockService = MockPlanetsService()
        viewModel = PlanetsViewModel(planetService: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testGetPlanetsSuccess() {
        let planet = Planet(name: "Earth")
        mockService.planets = [planet]

        let expectation = self.expectation(description: "GetPlanetsSuccess")
        viewModel.getPlanets { result in
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

    func testGetPlanetsFailure() {
        mockService.error = .invalidResponse

        let expectation = self.expectation(description: "GetPlanetsFailure")
        viewModel.getPlanets { result in
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
