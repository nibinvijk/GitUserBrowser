//
//  UserListViewModelTests.swift
//  GitUserBrowser
//
//  Created by Nibin Varghese on 21/05/25.
//

import XCTest
@testable import GitUserBrowser

class UserListViewModelTests: XCTestCase {
    var mockUserService: MockUserService!
    var viewModel: UserListViewModel!
    
    @MainActor
    override func setUp() {
        super.setUp()
        mockUserService = MockUserService()
        viewModel = UserListViewModel(userService: mockUserService)
    }
    
    @MainActor
    func testFetchUsers() async {
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
        mockUserService.mockUsers = mockUsers
        
        
        await viewModel.fetchUsers()
        
        
        XCTAssertEqual(viewModel.users.count, 2)
        XCTAssertEqual(viewModel.users[0].login, "user1")
        XCTAssertEqual(viewModel.users[1].login, "user2")
        XCTAssertNotNil(viewModel.lastUpdated)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.showError)
    }
    
    @MainActor
    func testFetchUsersWithError() async {
        mockUserService.shouldThrowError = true
        mockUserService.errorToThrow = .rateLimitExceeded
        
        
        await viewModel.fetchUsers()
        
        
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.error, APIError.rateLimitExceeded)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    @MainActor
    func testFilteredUsers() async {
        
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
                 following: nil),
            User(login: "user3",
                 avatar_url: "https://example.com/3.png",
                 name: nil,
                 followers: nil,
                 following: nil)
        ]
        mockUserService.mockUsers = mockUsers
        await viewModel.fetchUsers()
        
        
        viewModel.searchText = ""
        
        
        XCTAssertEqual(viewModel.filteredUsers.count, 3)
        
        
        viewModel.searchText = "user1"
        
        
        XCTAssertEqual(viewModel.filteredUsers.count, 1)
        XCTAssertEqual(viewModel.filteredUsers[0].login, "user1")
        
        
        viewModel.searchText = "abc"
        
        
        XCTAssertEqual(viewModel.filteredUsers.count, 0)
    }
}
