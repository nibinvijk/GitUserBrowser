//
//  UserModelTest.swift
//  GitUserBrowserTests
//
//  Created by Nibin Varghese on 21/05/25.
//

import XCTest
@testable import GitUserBrowser

final class UserModelTest: XCTestCase {
    func testUserModel() {
        let userData: [String: Any] = [
            "login": "testuser",
            "avatar_url": "https://github.com/avatar.png",
            "name": "Test User",
            "followers": 100,
            "following": 50
        ]
        
        
        let jsonData = try! JSONSerialization.data(withJSONObject: userData)
        let user = try! JSONDecoder().decode(User.self, from: jsonData)
        

        XCTAssertEqual(user.login, "testuser")
        XCTAssertEqual(user.name, "Test User")
        XCTAssertEqual(user.followers, 100)
        XCTAssertEqual(user.following, 50)
        XCTAssertEqual(user.avatarURL?.absoluteString, "https://github.com/avatar.png")
        XCTAssertEqual(user.id, "testuser")
    }
}
