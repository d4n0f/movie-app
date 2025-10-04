//
//  Genre.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 04. 12..
//

// egyediség, hashcode, equals (utobbi ketto Java referencia)
struct Genre: Identifiable, Hashable, Equatable {
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    init(dto: GenreResponse) {
        self.id = dto.id
        self.name = dto.name
    }

}
