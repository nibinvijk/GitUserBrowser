//
//  UserServiceTests.swift
//  GitUserBrowser
//
//  Created by Nibin Varghese on 21/05/25.
//

import XCTest
@testable import GitUserBrowser

class UserServiceTests: XCTestCase {
    var mockAPIClient: MockAPIClient!
    var userService: UserService!
    
    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        userService = UserService(apiClient: mockAPIClient)
    }
    
    func testFetchUsers() async throws {
        let mockUsers = [
            User(login: "user1",
                 avatar_url: "https://example.com/1.png",
                 name: nil,
                 followers: nil,
                 following: nil),
            User(login: "user2",
                 avatar_url: "https://example.com/2.png",
                 name: nil,
                 followers: nil,
                 following: nil)
        ]
        mockAPIClient.mockUsers = mockUsers
        
        
        let result = try await userService.fetchUsers()
        
        
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].login, "user1")
        XCTAssertEqual(result[1].login, "user2")
    }
    
    func testFetchDetails() async throws {
        let mockUser = User(login: "testuser",
                            avatar_url: "https://example.com/avatar.png",
                            name: "Test User",
                            followers: 100,
                            following: 50)
        mockAPIClient.mockUser = mockUser
        

        let result = try await userService.fetchDetails(for: "testuser")
        
        
        XCTAssertEqual(result.login, "testuser")
        XCTAssertEqual(result.name, "Test User")
        XCTAssertEqual(result.followers, 100)
        XCTAssertEqual(result.following, 50)
    }
    
    func testFetchRepositories() async throws {
        let mockRepos = [
            Repository(name: "repo1",
                       language: "Swift",
                       starCount: 10,
                       description: "Description 1",
                       html_url: "https://github.com/user/repo1",
                       isFork: false),
            Repository(name: "repo2",
                       language: "C++",
                       starCount: 20,
                       description: "Description 2",
                       html_url: "https://github.com/user/repo2",
                       isFork: true)
        ]
        mockAPIClient.mockRepositories = mockRepos
        

        let result = try await userService.fetchRepositories(for: "testuser")
        

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].name, "repo1")
        XCTAssertEqual(result[1].name, "repo2")
    }
    
    func testFetchUsersWithError() async {
        mockAPIClient.shouldThrowError = true
        mockAPIClient.errorToThrow = .rateLimitExceeded
        

        do {
            _ = try await userService.fetchUsers()
            XCTFail("Expected rate limit exceeded error")
        } catch let error as APIError {
            XCTAssertEqual(error, APIError.rateLimitExceeded)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
