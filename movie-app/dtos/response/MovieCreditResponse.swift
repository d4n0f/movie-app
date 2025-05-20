//
//  MovieCreditResponse.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 05. 10..
//

struct MovieCreditResponse: Decodable {
    let id: Int
    let cast: [CastResponse]
    
    enum CodingKeys: String, CodingKey {
        case id
        case cast
    }
}
