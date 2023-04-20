//
//  PlanetsViewModel.swift
//  Planets
//
//  Created by Aleksander Jasinski on 19/04/23.
//

import Foundation

protocol PlanetsViewModelInput {
    func getPlanets(completion: @escaping (Result<[Planet], NetworkError>) -> Void)
}

final class PlanetsViewModel {
    
    private let planetService: PlanetsServiceContract
    
    init(planetService: PlanetsServiceContract = PlanetsService()) {
        self.planetService = planetService
    }
}

extension PlanetsViewModel: PlanetsViewModelInput {
    // Fetch planets from the planet service and pass the result to the completion handler.
    func getPlanets(completion: @escaping (Result<[Planet], NetworkError>) -> Void) {
        planetService.getPlanets(url: Constants.url) { result in
            completion(result)
        }
    }
}
