//
//  APIClientTests.swift
//  GitUserBrowser
//
//  Created by Nibin Varghese on 21/05/25.
//


import XCTest
@testable import GitUserBrowser

final class APIClientTests: XCTestCase {
    var mockKeychainService: MockKeychainService!
    var apiClient: APIClient!
    var urlSession: URLSession!
    
    override func setUp() {
        super.setUp()
        mockKeychainService = MockKeychainService()

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
        

        apiClient = APIClient(keychainService: mockKeychainService, urlSession: urlSession)
    }
    
    override func tearDown() {
        mockKeychainService = nil
        apiClient = nil
        urlSession = nil
        MockURLProtocol.mockResponses = [:]
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }
    
    func testPerformRequestSuccess() async throws {
        let mockUser = User(login: "testuser", avatar_url: "https://example.com/avatar.png", name: "Test User", followers: 100, following: 50)
        let userData = try JSONEncoder().encode(mockUser)
        
        MockURLProtocol.mockResponses = [
            "https://api.github.com/users/testuser": (
                data: userData,
                response: HTTPURLResponse(
                    url: URL(string: "https://api.github.com/users/testuser")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: nil
                )!,
                error: nil
            )
        ]
        
        let result: User = try await apiClient.performRequest(endpoint: "/users/testuser")
        

        XCTAssertEqual(result.login, "testuser")
        XCTAssertEqual(result.name, "Test User")
        XCTAssertEqual(result.followers, 100)
        XCTAssertEqual(result.following, 50)
    }
    
    func testPerformRequestNetworkError() async {
        let networkError = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        
        MockURLProtocol.mockResponses = [
            "https://api.github.com/users": (
                data: nil,
                response: nil,
                error: networkError
            )
        ]
        
        do {
            let _: [User] = try await apiClient.performRequest(endpoint: "/users")
            XCTFail("Expected network error")
        } catch let error as APIError {
            if case .networkError(let underlyingError) = error {
                XCTAssertEqual((underlyingError as NSError).code, NSURLErrorNotConnectedToInternet)
            } else {
                XCTFail("Wrong error type: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testPerformRequestInvalidResponse() async {
        MockURLProtocol.mockResponses = [
            "https://api.github.com/users": (
                data: Data(),
                response: HTTPURLResponse(
                    url: URL(string: "https://api.github.com/users")!,
                    statusCode: 404,
                    httpVersion: nil,
                    headerFields: nil
                )!,
                error: nil
            )
        ]
        
        do {
            let _: [User] = try await apiClient.performRequest(endpoint: "/users")
            XCTFail("Expected invalid response error")
        } catch let error as APIError {
            XCTAssertEqual(error, APIError.invalidResponse)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testPerformRequestDecodingError() async {
        let invalidData = "invalid json".data(using: .utf8)!
        
        MockURLProtocol.mockResponses = [
            "https://api.github.com/users/testuser": (
                data: invalidData,
                response: HTTPURLResponse(
                    url: URL(string: "https://api.github.com/users/testuser")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: nil
                )!,
                error: nil
            )
        ]
        
        do {
            let _: User = try await apiClient.performRequest(endpoint: "/users/testuser")
            XCTFail("Expected decoding error")
        } catch let error as APIError {
            XCTAssertEqual(error, APIError.decodingError)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
