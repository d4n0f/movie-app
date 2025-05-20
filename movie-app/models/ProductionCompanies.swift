//
//  ProductionCompanies.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 05. 12..
//

import SwiftUI

// TODO: atirni egyes szamba
struct ProductionCompany: Identifiable, Hashable {
    let id: Int
    let name: String
    let logoPath: URL?
    let originCountry: String
    
    init() {
        self.id = 0
        self.name = ""
        self.logoPath = nil
        self.originCountry = ""
    }
    
    init(id: Int, name: String, logoPath: URL?, originCountry: String) {
        self.id = id
        self.name = name
        self.logoPath = logoPath
        self.originCountry = originCountry
    }
    
    init(dto: ProductionCompanyResponse) {
        var logoPath: URL? {
            dto.logoPath.flatMap {
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
        }
        
        self.id = dto.id
        self.name = dto.name
        self.logoPath = logoPath
        self.originCountry = dto.originCountry
    }
}
