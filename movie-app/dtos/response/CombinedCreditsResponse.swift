//
//  CombinedCreditsResponse.swift
//  movie-app-live
//
//  Created by Balint Fonad on 2025. 06. 27..
//

struct CombinedCreditsResponse: Decodable {
    let id: Int
    let cast: [CombinedCreditsCastResponse]
    
    enum CodingKeys: String, CodingKey {
        case id
        case cast
    }
}

struct CombinedCreditsCastResponse: Decodable {
    let genreIds: [Int]
    let id: Int
    let originalTitle: String?
    let posterPath: String?
    let title: String?
    let releaseDate: String?
    let popularity: Double?
    let voteCount: Int?
    let voteAverage: Double?
    let mediaType: String?
    let name: String?
    let originalName: String?
    let firstAirDate: String?
    let character: String?
    
    enum CodingKeys: String, CodingKey {
        case genreIds = "genre_ids"
        case id
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case title
        case releaseDate = "release_date"
        case popularity
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case mediaType = "media_type"
        case name
        case originalName = "original_name"
        case firstAirDate = "first_air_date"
        case character
    }
}
