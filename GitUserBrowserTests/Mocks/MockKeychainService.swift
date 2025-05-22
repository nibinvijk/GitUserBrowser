//
//  MockKeychainService.swift
//  GitUserBrowser
//
//  Created by Nibin Varghese on 21/05/25.
//

import XCTest
@testable import GitUserBrowser

final class MockKeychainService: KeychainService {
    var mockToken: String?
    
    override func retrieveToken() -> String? {
        return mockToken
    }
    
    override func saveToken(_ token: String) -> Bool {
        mockToken = token
        return true
    }
    
    override func deleteToken() -> Bool {
        mockToken = nil
        return true
    }
}
