//
//  CastMember.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 05. 10..
//

import Foundation

struct CastMember: Identifiable, Hashable {
    let adult: Bool
    let gender: Int
    let id: Int
    let knownForDepartment: String
    let name: String
    let originalName: String
    let popularity: Double
    let profilePath: URL?
    let castId: Int
    let character: String
    let creditId: String
    let order: Int
    
    init() {
        self.adult = false
        self.gender = 0
        self.id = 0
        self.knownForDepartment = ""
        self.name = ""
        self.originalName = ""
        self.popularity = 0
        self.profilePath = nil
        self.castId = 0
        self.character = ""
        self.creditId = ""
        self.order = 0
    }
    
    init(adult: Bool,
         gender: Int,
         id: Int,
         knownForDepartment: String,
         name: String,
         originalName: String,
         popularity: Double,
         profilePath: URL?,
         castId: Int,
         character: String,
         creditId: String,
         order: Int
    ) {
        self.adult = adult
        self.gender = gender
        self.id = id
        self.knownForDepartment = knownForDepartment
        self.name = name
        self.originalName = originalName
        self.popularity = popularity
        self.profilePath = profilePath
        self.castId = castId
        self.character = character
        self.creditId = creditId
        self.order = order
    }
    
    init(dto: CastResponse) {
        var profilePath: URL? {
            dto.profilePath.flatMap {
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
        }
        
        self.adult = dto.adult
        self.gender = dto.gender
        self.id = dto.id
        self.knownForDepartment = dto.knownForDepartment
        self.name = dto.name
        self.originalName = dto.originalName
        self.popularity = dto.popularity
        self.profilePath = profilePath
        self.castId = dto.castId
        self.character = dto.character
        self.creditId = dto.creditId
        self.order = dto.order
    }
}
