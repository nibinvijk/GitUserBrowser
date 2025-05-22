//
//  RepositoryModelTest.swift
//  GitUserBrowserTests
//
//  Created by Nibin Varghese on 21/05/25.
//

import XCTest
@testable import GitUserBrowser

final class RepositoryModelTest: XCTestCase {

    func testRepositoryModel() {
        let repoData: [String: Any] = [
            "name": "test-repo",
            "language": "Swift",
            "stargazers_count": 50,
            "description": "Test repository",
            "html_url": "https://github.com/testuser/test-repo",
            "fork": false
        ]
        
        
        let jsonData = try! JSONSerialization.data(withJSONObject: repoData)
        let repo = try! JSONDecoder().decode(Repository.self, from: jsonData)
        

        XCTAssertEqual(repo.name, "test-repo")
        XCTAssertEqual(repo.language, "Swift")
        XCTAssertEqual(repo.starCount, 50)
        XCTAssertEqual(repo.description, "Test repository")
        XCTAssertEqual(repo.repoURL?.absoluteString, "https://github.com/testuser/test-repo")
        XCTAssertFalse(repo.isFork)
        XCTAssertEqual(repo.id, "test-repo")
    }
}
