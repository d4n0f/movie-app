//
//  Movie.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 04. 15..
//

import Foundation

struct MediaItemPage {
    let page: Int
    let totalPages: Int
    let mediaItems: [MediaItem]
    let totalResults: Int?
    
    init(dto: MoviePageResponse) {
        self.page = dto.page
        self.totalPages = dto.totalPages
        self.mediaItems = dto.results.map(MediaItem.init(dto:))
        self.totalResults = nil
    }
    
    init(dto: TVPageResponse) {
        self.page = dto.page
        self.totalPages = dto.totalPages
        self.mediaItems = dto.results.map(MediaItem.init(dto:))
        self.totalResults = nil
    }
    
    init(dto: SimilarMoviePageResponse) {
        self.page = dto.page
        self.totalPages = dto.totalPages
        self.mediaItems = dto.results.map(MediaItem.init(dto:))
        self.totalResults = dto.totalResults
    }
}

struct MediaItem: Identifiable {
    let id: Int
    let title: String
    let year: String
    let duration: String
    let imageUrl: URL?
    let rating: Double
    let voteCount: Int
    
    init(id: Int) {
        self.id = id
        self.title = "-1"
        self.year = "-1"
        self.duration = "-1"
        self.imageUrl = nil
        self.rating = -1
        self.voteCount = -1
    }
    
    init(id: Int, title: String, year: String, duration: String, imageUrl: URL?, rating: Double, voteCount: Int) {
        self.id = id
        self.title = title
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = rating
        self.voteCount = voteCount
    }
    
    init(dto: MovieResponse) {
        let releaseDate: String? = dto.releaseDate
        let prefixedYear: Substring = releaseDate?.prefix(4) ?? "-"
        let year = String(prefixedYear)
        let duration = "-" // TODO: placeholder – ha lesz ilyen adat, cserélhető
        
        var imageUrl: URL? {
            dto.posterPath.flatMap {
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
        }
        
        self.id = dto.id
        self.title = dto.title
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = dto.voteAverage ?? 0.0
        self.voteCount = dto.voteCount ?? 0
        
    }
    
    init(dto: TVResponse) {
        let releaseDate: String? = dto.firstAirDate
        let prefixedYear: Substring = releaseDate?.prefix(4) ?? "-"
        let year = String(prefixedYear)
        let duration = "-" // TODO: placeholder – ha lesz ilyen adat, cserélhető
        
        var imageUrl: URL? {
            dto.posterPath.flatMap {
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
        }
        
        self.id = dto.id
        self.title = dto.name
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = dto.voteAverage ?? 0.0
        self.voteCount = dto.voteCount ?? 0
        
    }
    
    init(detail: MediaItemDetail) {
        self.id = detail.id
        self.title = detail.title
        self.year = detail.year
        self.duration = "-"
        self.imageUrl = detail.imageUrl
        self.rating = detail.rating
        self.voteCount = detail.voteCount
        
    }
    
    init(dto: SimilarMovieResponse) {
        let releaseDate: String? = dto.releaseDate
        let prefixedYear: Substring = releaseDate?.prefix(4) ?? "-"
        let year = String(prefixedYear)
        let duration = "-"
        
        var imageUrl: URL? {
            dto.posterPath.flatMap {
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
        }
        
        self.id = dto.id
        self.title = dto.title
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = dto.voteAverage ?? 0.0
        self.voteCount = dto.voteCount ?? 0
    }
    
    init(credit: CombinedCreditCast) {
        self.id = credit.id
        self.title = credit.title ?? credit.name ?? ""
        self.year = (credit.releaseDate ?? credit.firstAirDate ?? "").prefix(4).description
        self.duration = "-"
        self.imageUrl = credit.posterPath.flatMap { URL(string: "https://image.tmdb.org/t/p/w500\($0)") }
        self.rating = credit.voteAverage ?? 0.0
        self.voteCount = credit.voteCount ?? 0
    }
}
