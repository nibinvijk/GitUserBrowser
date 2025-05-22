//
//  UserRepositoryViewModelTests.swift
//  GitUserBrowser
//
//  Created by Nibin Varghese on 21/05/25.
//

import XCTest
@testable import GitUserBrowser

class UserRepositoryViewModelTests: XCTestCase {
    var mockUserService: MockUserService!
    var viewModel: UserRepositoryViewModel!
    var testUser: User!
    
    @MainActor
    override func setUp() {
        super.setUp()
        mockUserService = MockUserService()
        testUser = User(login: "testuser",
                        avatar_url: "https://example.com/avatar.png",
                        name: nil,
                        followers: nil,
                        following: nil)
        viewModel = UserRepositoryViewModel(userService: mockUserService,
                                            user: testUser)
    }
    
    @MainActor
    func testFetchUserDetails() async {
        let updatedUser = User(login: "testuser",
                               avatar_url: "https://example.com/avatar.png",
                               name: "Test User",
                               followers: 100,
                               following: 50)
        mockUserService.mockUser = updatedUser
        
        let mockRepos = [
            Repository(name: "repo1",
                       language: "Swift",
                       starCount: 10,
                       description: "Description 1",
                       html_url: "https://github.com/user/repo1",
                       isFork: false),
            Repository(name: "repo2",
                       language: "JavaScript",
                       starCount: 20,
                       description: "Description 2",
                       html_url: "https://github.com/user/repo2",
                       isFork: true)
        ]
        mockUserService.mockRepositories = mockRepos
        
        
        await viewModel.fetchUserDetails()
        
        
        XCTAssertEqual(viewModel.user.name, "Test User")
        XCTAssertEqual(viewModel.user.followers, 100)
        XCTAssertEqual(viewModel.user.following, 50)
        XCTAssertEqual(viewModel.repositories.count, 1) // only repositories that are not forked are kept
        XCTAssertFalse(viewModel.isLoading)
    }
    
    @MainActor
    func testFetchRepositories() async {
        let mockRepos = [
            Repository(name: "repo1",
                       language: "Swift",
                       starCount: 10,
                       description: "Description 1",
                       html_url: "https://github.com/user/repo1",
                       isFork: false),
            Repository(name: "repo2",
                       language: "JavaScript",
                       starCount: 20,
                       description: "Description 2",
                       html_url: "https://github.com/user/repo2",
                       isFork: true),
            Repository(name: "repo3",
                       language: "Python",
                       starCount: 30,
                       description: "Description 3",
                       html_url: "https://github.com/user/repo3",
                       isFork: false)
        ]
        mockUserService.mockRepositories = mockRepos
        
        
        await viewModel.fetchRepositories()
        
        
        XCTAssertEqual(viewModel.repositories.count, 2) // Only non-forked repos
        XCTAssertEqual(viewModel.repositories[0].name, "repo1")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    @MainActor
    func testNonForkRepositoriesFilter() async {
        
        let mockRepos = [
            Repository(name: "repo1",
                       language: "Swift",
                       starCount: 10,
                       description: "Description 1",
                       html_url: "https://github.com/user/repo1",
                       isFork: false),
            Repository(name: "repo2",
                       language: "JavaScript",
                       starCount: 20,
                       description: "Description 2",
                       html_url: "https://github.com/user/repo2",
                       isFork: true),
            Repository(name: "repo3",
                       language: "Python",
                       starCount: 30,
                       description: "Description 3",
                       html_url: "https://github.com/user/repo3",
                       isFork: false)
        ]
        mockUserService.mockRepositories = mockRepos
        

        await viewModel.fetchRepositories()
        
        // Only non-fork repos
        XCTAssertEqual(viewModel.repositories.count, 2)
    }
    
    @MainActor
    func testFetchUserDetailsWithError() async {
        mockUserService.shouldThrowError = true
        mockUserService.errorToThrow = .networkError(NSError(domain: "", code: 0))
        
        
        await viewModel.fetchUserDetails()
        
        
        XCTAssertTrue(viewModel.showError)
        XCTAssertFalse(viewModel.isLoading)
        if case .networkError = viewModel.error {
            // Success
        } else {
            XCTFail("Unexpected error type")
        }
    }
}
