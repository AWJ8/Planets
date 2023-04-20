//
//  PlanetsService.swift
//  Planets
//
//  Created by Aleksander Jasinski on 19/04/23.
//

import Foundation

protocol PlanetsServiceContract {
    func getPlanets(url: String, completion: @escaping (Result<[Planet], NetworkError>) -> Void)
}
final class PlanetsService {
    
    private let networkManger: NetworkApi
    private let offlineStorageManager: OfflineStorageManager

    init(networkManger: NetworkApi = NetworkManager(), offlineStorageManager: OfflineStorageManager = OfflineStorageManager()) {
        self.networkManger = networkManger
        self.offlineStorageManager = offlineStorageManager
    }
}

extension PlanetsService: PlanetsServiceContract {
    func getPlanets(url: String, completion: @escaping (Result<[Planet], NetworkError>) -> Void) {
        networkManger.get(url: url, type: PlanetsResponse.self) { [weak self] result in
            switch result {
            case .success(let resopnse):
                self?.offlineStorageManager.savePlanets(resopnse.results)
                completion(.success(resopnse.results))
            case .failure(let error):
                
                // reading data from core data since api failed
                guard let  planets = self?.offlineStorageManager.fetchPlanets() , planets.count > 0 else {
                    // if no data stored in core data calling failure completion
                    completion(.failure(error))
                    return
                }
                // returning data from core data
                completion(.success(planets))
            }
        }
    }
}
