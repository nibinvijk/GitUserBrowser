//
//  MockFileManagerService.swift
//  GitUserBrowser
//
//  Created by Nibin Varghese on 21/05/25.
//

import XCTest
@testable import GitUserBrowser

final class MockFileManagerService: FileManagerService {
    var mockToken: String?
    
    override func getTokenFromPlist(fileName: String = "Keys") -> String? {
        return mockToken
    }
}
