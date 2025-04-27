//
//  MovieError.swift
//  movie-app-live
//
//  Created by Balint Fonad on 2025. 04. 26..
//

import Foundation

enum MovieError: Error {
    case invalidApiKeyError(message: String)
    case clientError
    case unexpectedError
    
    var domain: String {
        switch self {
        case .invalidApiKeyError, .unexpectedError, .clientError:
            return "MovieError"
        }
    }
}

extension MovieError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidApiKeyError(let message):
            //return "Invalid API key"
            return message
        case .unexpectedError:
            return "Unexpected error occurred"
        case .clientError:
            return "Client error"
        }
    }
}

//extension MovieError: Equatable {
//    public static func == (lhs: MovieError, rhs: MovieError) -> Bool {
//        switch (lhs, rhs) {
//        case (.invalidApiKeyError, .invalidApiKeyError):
//            return true
//        case (.unexpectedError, .unexpectedError):
//            return true
//        case (.clientError, .clientError):
//            return true
//        default:
//            return false
//        }
//    }
//}
