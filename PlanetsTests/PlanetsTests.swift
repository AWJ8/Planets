//
//  PlanetsTests.swift
//  PlanetsTests
//
//  Created by Aleksander Jasinski on 18/04/2023.
//

import XCTest
@testable import Planets

class PlanetTests: XCTestCase {
    func testPlanetInitialization() {
        let planet = Planet(name: "Tatooine")
        XCTAssertEqual(planet.name, "Tatooine")
    }
}
