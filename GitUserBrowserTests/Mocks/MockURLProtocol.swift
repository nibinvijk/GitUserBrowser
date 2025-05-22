//
//  MockURLProtocol.swift
//  GitUserBrowser
//
//  Created by Nibin Varghese on 21/05/25.
//

import XCTest
@testable import GitUserBrowser

final class MockURLProtocol: URLProtocol {
    static var mockResponses: [String: (data: Data?, response: HTTPURLResponse?, error: Error?)] = [:]
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let handler = MockURLProtocol.requestHandler {
            do {
                let (response, data) = try handler(request)
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: data)
                client?.urlProtocolDidFinishLoading(self)
            } catch {
                client?.urlProtocol(self, didFailWithError: error)
            }
            return
        }
        
        guard let url = request.url?.absoluteString,
              let mockResponse = MockURLProtocol.mockResponses[url] else {
            client?.urlProtocol(self, didFailWithError: APIError.invalidResponse)
            return
        }
        
        if let error = mockResponse.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        if let response = mockResponse.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let data = mockResponse.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        // Required implementation - can be empty
    }
}
