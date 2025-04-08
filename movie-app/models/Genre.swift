//
//  Genre.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 04. 08..
//

// egyediség, hashcode, equals (utobbi ketto Java referencia)
struct Genre: Identifiable, Hashable, Equatable {
    let id: Int
    let name: String
}
