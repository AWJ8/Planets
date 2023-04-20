//
//  Planet.swift
//  Planets
//
//  Created by Aleksander Jasinski on 18/04/2023.
//

import Foundation

struct Planet: Decodable {
    let name: String
}

//  Equatable extension for testing
extension Planet: Equatable {
    static func == (lhs: Planet, rhs: Planet) -> Bool {
        return lhs.name == rhs.name
    }
}
