//
//  GenreService.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 04. 14..
//

import Foundation
import Moya

protocol GenreServiceProtocol {
    func fetchGenres(req: FetchGenreRequest) async throws -> [Genre]
}
