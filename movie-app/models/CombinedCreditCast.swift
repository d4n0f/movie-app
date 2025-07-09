//
//  CombinedCreditCast.swift
//  movie-app-live
//
//  Created by Balint Fonad on 2025. 06. 27..
//

import Foundation

struct CombinedCredits: Decodable {

    let cast: [CombinedCreditCast]
    
    init(dto: CombinedCreditsResponse) {
        cast = dto.cast.map(CombinedCreditCast.init(dto:))
    }
}

struct CombinedCreditCast: Identifiable, Decodable {
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
    
    init() {
        self.genreIds = []
        self.id = 0
        self.originalTitle = nil
        self.posterPath = nil
        self.title = nil
        self.releaseDate = nil
        self.popularity = nil
        self.voteCount = nil
        self.mediaType = nil
        self.name = nil
        self.originalName = nil
        self.firstAirDate = nil
        self.character = nil
        self.voteAverage = nil
    }
    
    init(dto: CombinedCreditsCastResponse) {
        let releaseDate: String? = dto.releaseDate
        let prefixedYear: Substring = releaseDate?.prefix(4) ?? "-"
        let year = String(prefixedYear)
        
        let releaseDateTV: String? = dto.firstAirDate
        let prefixedYearTV: Substring = releaseDateTV?.prefix(4) ?? "-"
        let yearTV = String(prefixedYearTV)
        
        var posterPath: URL? {
            dto.posterPath.flatMap {
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
        }
        
        self.genreIds = dto.genreIds
        self.id = dto.id
        self.originalTitle = dto.originalTitle
        self.posterPath = dto.posterPath
        self.title = dto.title
        self.releaseDate = year
        self.popularity = dto.popularity
        self.firstAirDate = yearTV
        self.mediaType = dto.mediaType
        self.name = dto.name
        self.originalName = dto.originalName
        self.character = dto.character
        self.voteCount = dto.voteCount
        self.voteAverage = dto.voteAverage
    }
    
    var fixTitle: String {
        originalTitle ?? title ?? name ?? ""
    }
}
