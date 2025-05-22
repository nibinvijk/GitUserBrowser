//
//  GitUserBrowserUITests.swift
//  GitUserBrowserUITests
//
//  Created by Nibin Varghese on 15/05/25.
//

import XCTest

final class GitUserBrowserUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-UITestMock")
        app.launch()
    }
    
    func testMockUserAppearsAndNavigatesToDetail() throws {
        // TODO: Need to fix this UI test
        /// Tried to access the cell, but the api is throwing error while performing UI Test, so tried to add a `launchArguments` and injected  mock user data in the `UserListViewModel` based on the  `launchArguments`
        /// Also noted that setting `.accessibilityIdentifier("UserCell_\(user.login)")` in UserListView for the `UserRowView` is not working as expected and it  is  applied to the inner child views, so this test is failing at the moment.
        /// `I can resolve this with some additional time. For the time being, I am keeping it disabled`
        
        let userCell = app.otherElements["UserCell_mojombo"]
        XCTAssertTrue(userCell.waitForExistence(timeout: 10), "Expected mock user 'mojombo' not found")
        

        userCell.tap()
        
        
        let profileTitle = app.navigationBars["Profile"]
        XCTAssertTrue(profileTitle.waitForExistence(timeout: 5), "Did not navigate to Profile view")
        

        let nameText = app.staticTexts["Tom Preston"]
        XCTAssertTrue(nameText.waitForExistence(timeout: 5), "Expected user name not visible")
        
        let usernameText = app.staticTexts["@mojombo"]
        XCTAssertTrue(usernameText.exists, "Expected login not visible")
        
        let followersText = app.staticTexts["1200"]
        let followingText = app.staticTexts["300"]
        XCTAssertTrue(followersText.exists && followingText.exists, "Expected followers/following count not visible")
    }
    
    // for Debug purpose
    func testPrintVisibleElements() throws {
        sleep(3)
        print(app.debugDescription)
    }
}
