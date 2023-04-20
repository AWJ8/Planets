//
//  PlanetEntityMapper.swift
//  Planets
//
//  Created by Aleksander Jasinski on 19/04/23.
//
//  This extension adds a helper method to the PlanetEntity class for converting a PlanetEntity object to a Planet object.

import Foundation

extension PlanetEntity {
    // Convert the PlanetEntity object to a Planet object.
    func mapToPlanet() -> Planet {
        return Planet(name: self.name ?? "")
    }
}
