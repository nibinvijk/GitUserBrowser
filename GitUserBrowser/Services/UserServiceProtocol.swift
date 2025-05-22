//
//  UserServiceProtocol.swift
//  GitUserBrowser
//
//  Created by Nibin Varghese on 16/05/25.
//

protocol UserServiceProtocol {
    func fetchUsers() async throws -> [User]
    func fetchDetails(for username: String) async throws -> User
    func fetchRepositories(for username: String) async throws -> [Repository]
}
