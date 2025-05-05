//
//  TVResponse.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 05. 05..
//

struct TVListResponse: Decodable {
    let results: [TVResponse]
}

struct TVResponse: Decodable {
    let id: Int
    let name: String
    let firstAirDate: String?
    let posterPath: String?
    let voteAverage: Double?
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case firstAirDate = "first_air_date"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
