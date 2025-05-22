//
//  UserService.swift
//  GitUserBrowser
//
//  Created by Nibin Varghese on 16/05/25.
//

class UserService: UserServiceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }
    
    func fetchUsers() async throws -> [User] {
        return try await apiClient.performRequest(endpoint: "/users")
    }
    
    func fetchDetails(for username: String) async throws -> User {
        return try await apiClient.performRequest(endpoint: "/users/\(username)")
    }
    
    func fetchRepositories(for username: String) async throws -> [Repository] {
        return try await apiClient.performRequest(endpoint: "/users/\(username)/repos")
    }
}
