//
//  ReactiveMoviesServiceProtocol.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 05. 06..
//

import Foundation
import Moya
import InjectPropertyWrapper
import Combine

protocol ReactiveMoviesServiceProtocol {
    func fetchGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError>
    func fetchTVGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError>
    func searchMovies(req: SearchMovieRequest) -> AnyPublisher<[MediaItem], MovieError>
    func fetchMovies(req: FetchMediaListRequest) -> AnyPublisher<[MediaItem], MovieError>
    func fetchTV(req: FetchMediaListRequest) -> AnyPublisher<[MediaItem], MovieError>
    func fetchFavoriteMovies(req: FetchFavoriteMovieRequest, fromLocal: Bool) -> AnyPublisher<[MediaItem], MovieError>
    func editFavouriteMovies(req: EditFavouriteRequest) -> AnyPublisher<EditFavouriteResult, MovieError>
    func fetchMovieDetails(req: FetchDetailRequest) -> AnyPublisher<MediaItemDetail, MovieError>
    func fetchMovieCredits(req: FetchMovieCreditsRequest) -> AnyPublisher<Cast, MovieError>
}

class ReactiveMoviesService: ReactiveMoviesServiceProtocol {
    
    @Inject
    var moya: MoyaProvider<MultiTarget>!
    
    @Inject
    private var store: MediaItemStoreProtocol
    
    func fetchGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchGenres(req: req)),
            decodeTo: GenreListResponse.self,
            transform: { $0.genres.map(Genre.init(dto:)) }
        )
    }
    
    func fetchTVGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchTVGenres(req: req)),
            decodeTo: GenreListResponse.self,
            transform: { $0.genres.map(Genre.init(dto:)) }
        )
    }
    
    func searchMovies(req: SearchMovieRequest) -> AnyPublisher<[MediaItem], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.searchMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { $0.results.map(MediaItem.init(dto:)) }
        )
    }
    
    func fetchMovies(req: FetchMediaListRequest) -> AnyPublisher<[MediaItem], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { $0.results.map(MediaItem.init(dto:)) }
        )
    }
    
    func fetchTV(req: FetchMediaListRequest) -> AnyPublisher<[MediaItem], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchTVSeries(req: req)),
            decodeTo: TVPageResponse.self,
            transform: { $0.results.map(MediaItem.init(dto:)) }
        )
    }
    
    func fetchFavoriteMovies(req: FetchFavoriteMovieRequest, fromLocal: Bool = false) -> AnyPublisher<[MediaItem], MovieError> {
        if fromLocal {
            self.store.mediaItems
        } else {
            requestAndTransform(
                target: MultiTarget(MoviesApi.fetchFavoriteMovies(req: req)),
                decodeTo: MoviePageResponse.self,
                transform: { $0.results.map(MediaItem.init(dto:)) }
            ) // ugyan ugy csinalunk mindent majd az alabbi kod side effektként mukodve elmenti a választ egy local db-be
            .handleEvents(receiveOutput: { [weak self] mediaItems in // handleEvents -> side-effektént működő cucc
                self?.store.saveMediaItems(mediaItems)
            })
            .eraseToAnyPublisher() // varázs kód, átalakítja amit kell AnyPublisherbe
        }
    }
    
    func editFavouriteMovies(req: EditFavouriteRequest) -> AnyPublisher<EditFavouriteResult, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.editFavouriteMovies(req: req)),
            decodeTo: EditFavouriteResponse.self,
            transform: { response in
                EditFavouriteResult(dto: response)
            }
        )
    }
    
    //TODO: Reafctorn and create a domain model to AddFavoriteResponse    
//    func editFavouriteMovies(req: EditFavouriteRequest) -> AnyPublisher<EditFavouriteResult, MovieError> {
//        requestAndTransform(
//            target: MultiTarget(MoviesApi.editFavouriteMovies(req: req)),
//            decodeTo: EditFavouriteResult.self,
//            transform: { response in
//                response
//            }
//        )
//    }
    
    func fetchMovieDetails(req: FetchDetailRequest) -> AnyPublisher<MediaItemDetail, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchDetails(req: req)),
            decodeTo: MovieDetailResponse.self,
            transform: {MediaItemDetail( dto: $0) }
        )
    }
    
    func fetchMovieCredits(req: FetchMovieCreditsRequest) -> AnyPublisher<Cast, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchMovieCredits(req: req)),
            decodeTo: MovieCreditResponse.self,
            transform: { response in
                print("DEBUG: API Válasz: \(response)")
                return Cast(dto: response)
            }
        )
    }
    
    private func requestAndTransform<ResponseType: Decodable, Output>(
        target: MultiTarget,
        decodeTo: ResponseType.Type,
        transform: @escaping (ResponseType) -> Output
    ) -> AnyPublisher<Output, MovieError> {
        let future = Future<Output, MovieError> { future in
            self.moya.request(target) { result in
                switch result {
                case .success(let response):
                    switch response.statusCode {
                    case 200..<300:
                        do {
                            let decoded = try JSONDecoder().decode(decodeTo, from: response.data)
                            let output = transform(decoded)
                            future(.success(output))
                        } catch {
                            future(.failure(MovieError.unexpectedError))
                        }
                    case 400..<500:
                        future(.failure(MovieError.clientError))
                    default:
                        if let apiError = try? JSONDecoder().decode(MovieAPIErrorResponse.self, from: response.data) {
                            if apiError.statusCode == 7 {
                                future(.failure(MovieError.invalidApiKeyError(message: apiError.statusMessage)))
                            } else {
                                future(.failure(MovieError.unexpectedError))
                            }
                        } else {
                            future(.failure(MovieError.unexpectedError))
                        }
                    }
                case .failure:
                    future(.failure(MovieError.unexpectedError))
                }
            }
        }
        return future
            .eraseToAnyPublisher()
            
    }
}
