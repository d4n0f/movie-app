//
//  MovieCreditsResponse.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 05. 10..
//

struct MovieCreditsResponse: Decodable {
    let id: Int
    let cast: [CastMemberResponse]
    
    enum CodingKeys: String, CodingKey {
        case id
        case cast
    }
}
