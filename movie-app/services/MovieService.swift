//
//  MovieServices.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 04. 12..
//

import Foundation
import Moya
import InjectPropertyWrapper

protocol MoviesServiceProtocol {
    func fetchGenres(req: FetchGenreRequest) async throws -> [Genre]
    func fetchTVGenres(req: FetchGenreRequest) async throws -> [Genre]
}

class MoviesService: MoviesServiceProtocol {
    
    @Inject
    var moya: MoyaProvider<MultiTarget>!
    
    func fetchGenres(req: FetchGenreRequest) async throws -> [Genre] {
        return try await withCheckedThrowingContinuation { continuation in
            moya.request(MultiTarget(MoviesApi.fetchGenres(req: req))) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedResponse = try JSONDecoder().decode(GenreListResponse.self, from: response.data)
                        
                        // mappelés => jobb megoldás mint a ciklusok
                        let genres = decodedResponse.genres.map { genreResponse in
                            Genre(dto: genreResponse)
                        }
                        
                        continuation.resume(returning: genres)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    
    func fetchTVGenres(req: FetchGenreRequest) async throws -> [Genre] {
        return try await withCheckedThrowingContinuation { continuation in
            moya.request(MultiTarget(MoviesApi.fetchTVGenres(req: req))) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedResponse = try JSONDecoder().decode(GenreListResponse.self, from: response.data)
                        
                        // mappelés => jobb megoldás mint a ciklusok
                        let genres = decodedResponse.genres.map { genreResponse in
                            Genre(dto: genreResponse)
                        }
                        
                        continuation.resume(returning: genres)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
