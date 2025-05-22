//
//  MockAPIClient 2.swift
//  GitUserBrowser
//
//  Created by Nibin Varghese on 21/05/25.
//

import XCTest
@testable import GitUserBrowser

final class MockAPIClient: APIClientProtocol {
    var mockUsers: [User] = []
    var mockUser: User?
    var mockRepositories: [Repository] = []
    var shouldThrowError = false
    var errorToThrow: APIError = .invalidResponse
    
    func performRequest<T: Codable>(endpoint: String) async throws -> T {
        if shouldThrowError {
            throw errorToThrow
        }
        
        if endpoint == "/users" {
            return mockUsers as! T
        } else if endpoint.contains("/users/") && endpoint.contains("/repos") {
            return mockRepositories as! T
        } else if endpoint.contains("/users/") {
            guard let user = mockUser else {
                throw APIError.invalidData
            }
            return user as! T
        }
        
        throw APIError.invalidResponse
    }
}
