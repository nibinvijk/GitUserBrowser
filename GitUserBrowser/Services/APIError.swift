//
//  APIError.swift
//  GitUserBrowser
//
//  Created by Nibin Varghese on 16/05/25.
//

import Foundation

enum APIError: Error, LocalizedError, Equatable {

    case invalidResponse
    case invalidData
    case decodingError
    case networkError(Error)
    case rateLimitExceeded
    
    var errorDescription: String? {
        switch self {
            case .invalidResponse:
                return "Invalid server response"
            case .invalidData:
                return "Invalid data received"
            case .decodingError:
                return "Error decoding data"
            case .networkError(let error):
                return "Network error: \(error.localizedDescription)"
            case .rateLimitExceeded:
                return "GitHub API rate limit exceeded. Please try again later."
        }
    }
    
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
            case (.invalidResponse, .invalidResponse),
                (.invalidData, .invalidData),
                (.decodingError, .decodingError),
                (.rateLimitExceeded, .rateLimitExceeded):
                return true
            case (.networkError(let lhsError), .networkError(let rhsError)):
                return lhsError.localizedDescription == rhsError.localizedDescription
            default:
                return false
        }
    }
}
