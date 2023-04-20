//
//  NetworkManager.swift
//  Planets
//
//  Created by Aleksander Jasinski on 18/04/2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case apiError
    case parsingFailed
    case invalidResponse
}

// Generic 'get' method that retrieves data from a given URL.
protocol NetworkApi {
    func get<T: Decodable>(url: String, type:T.Type, completion: @escaping (Result<T, NetworkError>) -> Void)
}

final class NetworkManager {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
}

extension NetworkManager: NetworkApi {
    func get<T>(url: String, type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        
        // Convert the string to a URL object, and handle fails.
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            // If there's an error, call the completion handler with an 'apiError' error.
            if let _ = error {
                completion(.failure(.apiError))
                return
            }
            
            // Ensure there's data.
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            // Attempt to decode the data as the specified type.
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(.parsingFailed))
            }
        }
        // Resume the task to start the network request.
        task.resume()
    }
}
