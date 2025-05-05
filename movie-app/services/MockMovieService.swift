//
//  MockMovieService.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 04. 15..
//

import Foundation
import Combine

class MockMoviesService: MoviesServiceProtocol {
    func fetchGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError> {
        Just([])
                .setFailureType(to: MovieError.self)
                .eraseToAnyPublisher()
    }
    
    func fetchTVGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError> {
        Just([])
                .setFailureType(to: MovieError.self)
                .eraseToAnyPublisher()
    }
    
    func searchMovies(req: SearchMovieRequest) async throws -> [Movie] {
        [
            Movie(id: 1,
                  title: "Mock movie1",
                  year: "2024",
                  duration: "1h 34m",
                  imageUrl: nil,
                  rating: 1.0,
                  voteCount: 1000),
            Movie(id: 2,
                  title: "Mock movie2",
                  year: "2024",
                  duration: "1h 34m",
                  imageUrl: nil,
                  rating: 1.0,
                  voteCount: 1000),
            Movie(id: 3,
                  title: "Mock movie3",
                  year: "2024",
                  duration: "1h 34m",
                  imageUrl: nil,
                  rating: 1.0,
                  voteCount: 1000),
            Movie(id: 4,
                  title: "Mock movie4",
                  year: "2024",
                  duration: "1h 34m",
                  imageUrl: nil,
                  rating: 1.0,
                  voteCount: 1000),
            Movie(id: 5,
                  title: "Mock movie5",
                  year: "2024",
                  duration: "1h 34m",
                  imageUrl: nil,
                  rating: 1.0,
                  voteCount: 1000),
            
        ]
    }
    
    
    func fetchGenres(req: FetchGenreRequest) async throws -> [Genre] {
        return [
            Genre(id: 0, name: "Action"),
            Genre(id: 1, name: "Sci-fi"),
            Genre(id: 2, name: "Fantasy"),
            Genre(id: 3, name: "Horror"),
            
        ]
    }
    
    func fetchMovies(req: FetchMoviesRequest) async throws -> [Movie] {
        return [
            Movie(id: 1,
                  title: "Mock movie1",
                  year: "2024",
                  duration: "1h 34m",
                  imageUrl: nil,
                  rating: 1.0,
                  voteCount: 1000),
            Movie(id: 2,
                  title: "Mock movie2",
                  year: "2024",
                  duration: "1h 34m",
                  imageUrl: nil,
                  rating: 1.0,
                  voteCount: 1000),
            Movie(id: 3,
                  title: "Mock movie3",
                  year: "2024",
                  duration: "1h 34m",
                  imageUrl: nil,
                  rating: 1.0,
                  voteCount: 1000),
            Movie(id: 4,
                  title: "Mock movie4",
                  year: "2024",
                  duration: "1h 34m",
                  imageUrl: nil,
                  rating: 1.0,
                  voteCount: 1000),
            Movie(id: 5,
                  title: "Mock movie5",
                  year: "2024",
                  duration: "1h 34m",
                  imageUrl: nil,
                  rating: 1.0,
                  voteCount: 1000),
            
        ]
    }
    
    func fetchTVGenres(req: FetchGenreRequest) async throws -> [Genre] {
        return [
            Genre(id: 0, name: "Action"),
            Genre(id: 1, name: "Adventure"),
            Genre(id: 2, name: "Animation"),
            Genre(id: 3, name: "Comedy"),
            
        ]
    }
    
    func fetchTVSeries(req: FetchMoviesRequest) async throws -> [TV] {
        return [
            TV(id: 1,
                  title: "Mock tv1",
                  year: "2024",
                  duration: "40m",
                  imageUrl: nil,
                  rating: 1.0,
                  voteCount: 1000),
            TV(id: 2,
                  title: "Mock tv2",
                  year: "2024",
                  duration: "40m",
                  imageUrl: nil,
                  rating: 1.0,
                  voteCount: 1000),
            TV(id: 3,
                  title: "Mock tv3",
                  year: "2024",
                  duration: "40m",
                  imageUrl: nil,
                  rating: 1.0,
                  voteCount: 1000),
            TV(id: 4,
                  title: "Mock tv4",
                  year: "2024",
                  duration: "40m",
                  imageUrl: nil,
                  rating: 1.0,
                  voteCount: 1000),
            TV(id: 5,
                  title: "Mock tv5",
                  year: "2024",
                  duration: "40m",
                  imageUrl: nil,
                  rating: 1.0,
                  voteCount: 1000),
            
        ]

    }
}
