//
//  APIClient.swift
//  GitUserBrowser
//
//  Created by Nibin Varghese on 16/05/25.
//

import Foundation

protocol APIClientProtocol {
    func performRequest<T: Codable>(endpoint: String) async throws -> T
}

class APIClient: APIClientProtocol {
    private let baseUrl = "https://api.github.com"
    private let keychainService: KeychainService
    private let urlSession: URLSession
    
    init(keychainService: KeychainService = KeychainService(), urlSession: URLSession = URLSession.shared) {
        self.keychainService = keychainService
        self.urlSession = urlSession
    }
    
    func performRequest<T: Codable>(endpoint: String) async throws -> T {
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw APIError.invalidResponse
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.setValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
        
        // Token handling - Add personal token to the Keys.plist file to include the same in the request header
        if let token = keychainService.retrieveToken(), !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            if httpResponse.statusCode == 403,
                let rateLimitHeader = httpResponse.allHeaderFields["X-RateLimit-Remaining"] as? String, rateLimitHeader == "0" {
                throw APIError.rateLimitExceeded
            }
            
            guard httpResponse.statusCode == 200 else {
                throw APIError.invalidResponse
            }
            
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw APIError.decodingError
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
}
