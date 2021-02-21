//
//  APIError.swift
//  CodeChallenge
//
//  Created by Cesar Brenes on 19/2/21.
//

import Foundation
// Is necessary to add the Equatable to the enum because this is enum with associated value and this is necessary in the case we need to compare 2 elements are the same
enum APIError: Error, Equatable {
    
    case networkError(Error)
    case jsonParsingError(Error)
    case invalidStatusCode(Int)
    case invalidURL
    case paginationError
    
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.networkError, .networkError):
            return true
        case (.jsonParsingError, .jsonParsingError):
        return true
        case (.invalidStatusCode, .invalidStatusCode):
        return true
        case (.invalidURL, .invalidURL):
            return true
        case (.paginationError, .paginationError):
            return true
        default:
            return false
        }
    }
}
