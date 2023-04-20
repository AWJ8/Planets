//
//  PlanetsResponse.swift
//  Planets
//
//  Created by Aleksander Jasinski on 18/04/2023.
//

import Foundation

struct PlanetsResponse: Decodable {
    let results: [Planet]
}
