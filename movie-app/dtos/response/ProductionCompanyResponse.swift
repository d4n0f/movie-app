//
//  ProductionCompanyResponse.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 05. 10..
//

struct ProductionCompanyResponse: Decodable, Hashable {
    let id: Int
    let name: String
    let logoPath: String?
    let originCountry: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}
