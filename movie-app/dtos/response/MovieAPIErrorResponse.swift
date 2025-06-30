//
//  MovieAPIErrorResponse.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 06. 27..
//

struct MovieAPIErrorResponse: Decodable {
    let statusCode: Int
    let statusMessage: String
    let success: Bool
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case success = "success"
    }
}
