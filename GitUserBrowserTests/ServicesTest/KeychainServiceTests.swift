//
//  KeychainServiceTests.swift
//  GitUserBrowser
//
//  Created by Nibin Varghese on 21/05/25.
//

import XCTest
@testable import GitUserBrowser

class KeychainServiceTests: XCTestCase {
    var keychainService: KeychainService!
    
    override func setUp() {
        super.setUp()
        keychainService = KeychainService()
        
        let _ = keychainService.deleteToken()
    }
    
    func testSaveAndRetrieveToken() {
        let token = "test_token_12345"
        
        
        let saveResult = keychainService.saveToken(token)
        let retrievedToken = keychainService.retrieveToken()
        
        
        XCTAssertTrue(saveResult)
        XCTAssertEqual(retrievedToken, token)
    }
    
    func testDeleteToken() {
        let token = "token_to_delete"
        _ = keychainService.saveToken(token)
        
        
        let deleteResult = keychainService.deleteToken()
        let retrievedToken = keychainService.retrieveToken()
        
        
        XCTAssertTrue(deleteResult)
        XCTAssertNil(retrievedToken)
    }
}
