//
//  MockUserService.swift
//  GitUserBrowserTests
//
//  Created by Nibin Varghese on 21/05/25.
//

import XCTest
@testable import GitUserBrowser

final class MockUserService: UserServiceProtocol {
    var mockUsers: [User] = []
    var mockUser: User?
    var mockRepositories: [Repository] = []
    var shouldThrowError = false
    var errorToThrow: APIError = .invalidResponse
    
    func fetchUsers() async throws -> [User] {
        if shouldThrowError {
            throw errorToThrow
        }
        return mockUsers
    }
    
    func fetchDetails(for username: String) async throws -> User {
        if shouldThrowError {
            throw errorToThrow
        }
        guard let user = mockUser else {
            throw APIError.invalidData
        }
        return user
    }
    
    func fetchRepositories(for username: String) async throws -> [Repository] {
        if shouldThrowError {
            throw errorToThrow
        }
        return mockRepositories
    }
}
