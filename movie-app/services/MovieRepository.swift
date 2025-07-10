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
import Alamofire

protocol MovieRepository {
    func fetchGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError>
    func fetchTVGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError>
    func searchMovies(req: SearchMediaItemRequest) -> AnyPublisher<[MediaItem], MovieError>
    func searchTVs(req: SearchMediaItemRequest) -> AnyPublisher<[MediaItem], MovieError>
    func fetchMovies(req: FetchMediaListRequest) -> AnyPublisher<MediaItemPage, MovieError>
    func fetchTV(req: FetchMediaListRequest) -> AnyPublisher<MediaItemPage, MovieError>
    func fetchFavoriteMovies(req: FetchFavoriteMediaItemRequest, fromLocal: Bool) -> AnyPublisher<[MediaItem], MovieError>
    func editFavoriteMovie(req: EditFavouriteRequest) -> AnyPublisher<ModifyMediaResult, MovieError>
    func fetchMovieDetail(req: FetchDetailRequest) -> AnyPublisher<MediaItemDetail, MovieError>
    func fetchTVDetail(req: FetchDetailRequest) -> AnyPublisher<MediaItemDetail, MovieError>
    func fetchMovieCredits(req: FetchMediaItemCreditsRequest) -> AnyPublisher<[CastMember], MovieError>
    func fetchTVCredits(req: FetchMediaItemCreditsRequest) -> AnyPublisher<[CastMember], MovieError>
    func fetchCastDetail(req: FetchParticipantDetailRequest) -> AnyPublisher<CastDetail, MovieError>
    func fetchCompanyDetail(req: FetchParticipantDetailRequest) -> AnyPublisher<CastDetail, MovieError>
    func fetchMovieReviews(req: FetchMediaItemReviewRequest) -> AnyPublisher<[MediaItemReview], MovieError>
    func fetchSimilarMovie(req: FetchSimilarMediaItemRequest) -> AnyPublisher<MediaItemPage, MovieError>
    func fetchCombinedCredits(req: FetchParticipantDetailRequest) -> AnyPublisher<CombinedCredits, MovieError>
    func addRating(req: AddReviewRequest) -> AnyPublisher<ModifyMediaResult, MovieError>
}

class MovieRepositoryImpl: MovieRepository {
    
    @Inject
    var moya: MoyaProvider<MultiTarget>!
    
    @Inject
    private var store: MediaItemStoreProtocol
    
    @Inject
    private var networkMonitor: NetworkMonitorProtocol
    
    @Inject
    private var detailStore: MediaItemDetailStoreProtocol
    
    @Inject
    private var castMemberStore: CastMemberStoreProtocol
    
    @Inject
    private var reviewStore: ReviewStoreProtocol
    
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
    
    func searchMovies(req: SearchMediaItemRequest) -> AnyPublisher<[MediaItem], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.searchMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { $0.results.map(MediaItem.init(dto:)) }
        )
    }
    
    func searchTVs(req: SearchMediaItemRequest) -> AnyPublisher<[MediaItem], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.searchTVs(req: req)),
            decodeTo: TVPageResponse.self,
            transform: { $0.results.map(MediaItem.init(dto:)) }
        )
    }
    
    func fetchMovies(req: FetchMediaListRequest) -> AnyPublisher<MediaItemPage, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { MediaItemPage(dto: $0) }
        )
    }
    
    func fetchTV(req: FetchMediaListRequest) -> AnyPublisher<MediaItemPage, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchTVSeries(req: req)),
            decodeTo: TVPageResponse.self,
            transform: { MediaItemPage(dto: $0) }
        )
    }
    
    func fetchFavoriteMovies(req: FetchFavoriteMediaItemRequest, fromLocal: Bool) -> AnyPublisher<[MediaItem], MovieError> {
        
        let serviceResponse: AnyPublisher<[MediaItem], MovieError> = self.requestAndTransform(
            target: MultiTarget(MoviesApi.fetchFavoriteMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { $0.results.map(MediaItem.init(dto:)) }
        )
            .handleEvents(receiveOutput: { [weak self]mediaItems in
                self?.store.saveMediaItems(mediaItems)
            })
            .eraseToAnyPublisher()
        
        let localResponse: AnyPublisher<[MediaItem], MovieError> = store.mediaItems
        
        return networkMonitor.isConnected
            .flatMap { isConnected -> AnyPublisher<[MediaItem], MovieError> in
                if isConnected {
                    return serviceResponse
                } else {
                    return localResponse
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchMovieDetail(req: FetchDetailRequest) -> AnyPublisher<MediaItemDetail, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchDetails(req: req)),
            decodeTo: MovieDetailResponse.self,
            transform: { MediaItemDetail(dto: $0) }
        )
    }
    
    func fetchTVDetail(req: FetchDetailRequest) -> AnyPublisher<MediaItemDetail, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchTVDetails(req: req)),
            decodeTo: TVDetailResponse.self,
            transform: { MediaItemDetail(dto: $0) }
        )
    }
    
    func fetchMovieCredits(req: FetchMediaItemCreditsRequest) -> AnyPublisher<[CastMember], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchMovieCredits(req: req)),
            decodeTo: MovieCreditsResponse.self,
            transform: { dto in
                dto.cast.map(CastMember.init(dto:))
            }
        )
    }
    
    func fetchTVCredits(req: FetchMediaItemCreditsRequest) -> AnyPublisher<[CastMember], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchTVCredits(req: req)),
            decodeTo: MovieCreditsResponse.self,
            transform: { $0.cast.map(CastMember.init(dto:)) }
        )
    }
    
    func editFavoriteMovie(req: EditFavouriteRequest) -> AnyPublisher<ModifyMediaResult, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.editFavouriteMovies(req: req)),
            decodeTo: ModifyMediaResultResponse.self,
            transform: { response in
                ModifyMediaResult(dto: response)
            }
        )
    }
    
    func fetchCastDetail(req: FetchParticipantDetailRequest) -> AnyPublisher<CastDetail, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchCastDetail(req: req)),
            decodeTo: CastDetailResponse.self,
            transform: { response in
                CastDetail(dto: response)
            }
        )
    }
    
    func fetchCompanyDetail(req: FetchParticipantDetailRequest) -> AnyPublisher<CastDetail, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchCompanyDetail(req: req)),
            decodeTo: CompanyDetailResponse.self,
            transform: { response in
                CastDetail(dto: response)
            }
        )
    }
    
    func fetchMovieReviews(req: FetchMediaItemReviewRequest) -> AnyPublisher<[MediaItemReview], MovieError> {
            return networkMonitor.isConnected
                .flatMap { isConnected -> AnyPublisher<[MediaItemReview], MovieError> in
                    if isConnected {
                        return self.requestAndTransform(
                            target: MultiTarget(MoviesApi.fetchMovieReviews(req: req)),
                            decodeTo: MediaItemReviewPageResponse.self,
                            transform: { dto in
                                dto.results.map(MediaItemReview.init(dto:))
                            }
                        )
                        .handleEvents(receiveOutput: { [weak self]reviews in
                            self?.reviewStore.saveReviews(reviews, forMovieId: req.mediaId)
                        })
                        .eraseToAnyPublisher()
                    } else {
                        return self.reviewStore.getReviews(fromMovieId: req.mediaId)
                    }
                }
                .eraseToAnyPublisher()
        }
    
    func fetchSimilarMovie(req: FetchSimilarMediaItemRequest) -> AnyPublisher<MediaItemPage, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchSimilarMovies(req: req)),
            decodeTo: SimilarMoviePageResponse.self,
            transform: { MediaItemPage(dto: $0) }
        )
    }
    
    func fetchCombinedCredits(req: FetchParticipantDetailRequest) -> AnyPublisher<CombinedCredits, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchCombinedCredits(req: req)),
            decodeTo: CombinedCreditsResponse.self,
            transform: { CombinedCredits(dto: $0) }
        )
    }
    
    func addRating(req: AddReviewRequest) -> AnyPublisher<ModifyMediaResult, MovieError> {
            requestAndTransform(
                target: MultiTarget(MoviesApi.addRating(req: req)),
                decodeTo: ModifyMediaResultResponse.self,
                transform: { response in
                    ModifyMediaResult(dto: response)
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
                            future(.failure(MovieError.mappingError(message: error.localizedDescription)))
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
                case .failure(let error):
                    if error.isNoInternetError {
                        future(.failure(MovieError.noInternetError))
                    } else {
                        future(.failure(MovieError.unexpectedError))
                    }
                    
                }
            }
        }
        return future
            .eraseToAnyPublisher()
            
    }
    
    func fetchFavoriteMovies2(req: FetchFavoriteMediaItemRequest, fromLocal: Bool = false) -> AnyPublisher<[MediaItem], MovieError> {
            networkMonitor.isConnected
                .flatMap { [weak self]isConnected in
                    guard let self = self else {
                        preconditionFailure("There is no self")
                    }
                    if !isConnected || fromLocal {
                        return self.store.mediaItems
                    }
                    return self.requestAndTransform(
                        target: MultiTarget(MoviesApi.fetchFavoriteMovies(req: req)),
                        decodeTo: MoviePageResponse.self,
                        transform: { $0.results.map(MediaItem.init(dto:)) }
                    )
                    
                }
                .handleEvents(receiveOutput: { [weak self]mediaItems in
                    guard let self = self else {
                        preconditionFailure("There is no self")
                    }
                    self.store.saveMediaItems(mediaItems)
                })
                .eraseToAnyPublisher()
        }
}

extension MoyaError {
    var isNoInternetError: Bool {
        if case let .underlying(error, _) = self {
            // Ha AFError
            if let afError = error as? AFError {
                if let urlError = afError.underlyingError as? URLError {
                    return urlError.code == .notConnectedToInternet
                } else if let nsError = afError.underlyingError as NSError? {
                    return nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorNotConnectedToInternet
                }
            }
        }
        return false
    }
}
