//
//  MoviesApi.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 04. 12..
//

import Foundation
import Moya

enum MoviesApi {
    case fetchGenres(req: FetchGenreRequest)
    case fetchTVGenres(req: FetchGenreRequest)
    case fetchMovies(req: FetchMediaListRequest)
    case searchMovies(req: SearchMediaItemRequest)
    case searchTVs(req: SearchMediaItemRequest)
    case fetchTVSeries(req: FetchMediaListRequest)
    case fetchFavoriteMovies(req: FetchFavoriteMediaItemRequest)
    case editFavouriteMovies(req: EditFavouriteRequest)
    case fetchDetails(req: FetchDetailRequest)
    case fetchTVDetails(req: FetchDetailRequest)
    case fetchMovieCredits(req: FetchMediaItemCreditsRequest)
    case fetchTVCredits(req: FetchMediaItemCreditsRequest)
    case fetchCastDetail(req: FetchParticipantDetailRequest)
    case fetchCompanyDetail(req: FetchParticipantDetailRequest)
    case fetchMovieReviews(req: FetchMediaItemReviewRequest)
    case fetchSimilarMovies(req: FetchSimilarMediaItemRequest)
    case fetchCombinedCredits(req: FetchParticipantDetailRequest)
    case addRating(req: AddReviewRequest)
}

extension MoviesApi: TargetType {
    var baseURL: URL {
        // TODO: Másik baseurl
        let baseUrl = "https://api.themoviedb.org/3/"
        guard let baseUrl = URL(string: baseUrl) else {
            preconditionFailure("Base url not valid url")
        }
        return baseUrl
    }
    
    var path: String {
        switch self {
        case .fetchGenres:
            return "genre/movie/list"
        case .fetchTVGenres:
            return "genre/tv/list"
        case .fetchMovies:
            return "discover/movie"
        case .searchMovies:
            return "search/movie"
        case .searchTVs:
            return "search/tv"
        case .fetchTVSeries:
            return "discover/tv"
        case let .fetchFavoriteMovies(req):
            return "account/\(req.accountId)/favorite/movies"
        case .editFavouriteMovies(req: let req):
            return "account/\(req.accountId)/favorite"
        case .fetchDetails(req: let req):
            return "movie/\(req.mediaId)"
        case .fetchTVDetails(req: let req):
            return "tv/\(req.mediaId)"
        case .fetchMovieCredits(let req):
            return "movie/\(req.mediaId)/credits"
        case .fetchTVCredits(req: let req):
            return "tv/\(req.mediaId)/credits"
        case .fetchCastDetail(req: let req):
            return "person/\(req.personId)"
        case .fetchCompanyDetail(req: let req):
            return "company/\(req.personId)"
        case .fetchMovieReviews(req: let req):
            return "movie/\(req.mediaId)/reviews"
        case .fetchSimilarMovies(req: let req):
            return "movie/\(req.mediaId)/similar"
        case .fetchCombinedCredits(req: let req):
            return "person/\(req.personId)/combined_credits"
        case .addRating(req: let req):
            return "movie/\(req.mediaId)/rating"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchGenres,.fetchTVGenres, .fetchMovies, .searchMovies, .searchTVs, .fetchTVSeries, .fetchFavoriteMovies, .fetchDetails, .fetchMovieCredits, .fetchCastDetail, .fetchCompanyDetail, .fetchMovieReviews, .fetchSimilarMovies, .fetchCombinedCredits, .fetchTVDetails, .fetchTVCredits:
            return .get
        case .editFavouriteMovies, .addRating:
            return .post
        }
    }
    
    // TODO: Másik encoding
    var task: Task {
        switch self {
        case .fetchGenres(let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .fetchTVGenres(let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchMovies(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .searchMovies(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .searchTVs(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .fetchTVSeries(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchFavoriteMovies(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .editFavouriteMovies(req: let req):
            let request = EditFavouriteBodyRequest(movieId: req.movieId, isFavorite: req.isFavorite)
//            print("<<<<\(request)")
            return .requestJSONEncodable(request)
        case .fetchDetails(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .fetchTVDetails(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .fetchMovieCredits(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .fetchTVCredits(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .fetchCastDetail(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .fetchCompanyDetail(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .fetchMovieReviews(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .fetchSimilarMovies(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .fetchCombinedCredits(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .addRating(req: let req):
            let request = AddReviewBodyRequest(movieId: req.mediaId, rating: req.rating)
//            print("<<<<\(request)")
            return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case let .fetchGenres(req):
            return ["Authorization": req.accessToken]
        case let .fetchTVGenres(req):
            return ["Authorization": req.accessToken]
        case let .fetchMovies(req):
            return ["Authorization": req.accessToken]
        case let .searchMovies(req):
            return [
                "Authorization": req.accessToken,
                "accept": "application/json"
            ]
        case let .searchTVs(req):
            return [
                "Authorization": req.accessToken,
                "accept": "application/json"
            ]
        case .fetchTVSeries(req: let req):
            return ["Authorization": req.accessToken]
        case let .fetchFavoriteMovies(req):
            return ["Authorization": req.accessToken]
        case .editFavouriteMovies(req: let req):
            return [
                "Authorization": req.accessToken,
                "accept": "application/json"
            ]
        case .fetchDetails(req: let req):
            return ["Authorization": req.accessToken]
        case .fetchTVDetails(req: let req):
            return ["Authorization": req.accessToken]
        case .fetchMovieCredits(req: let req):
            return ["Authorization": req.accessToken]
        case .fetchTVCredits(req: let req):
            return ["Authorization": req.accessToken]
        case .fetchCastDetail(req: let req):
            return ["Authorization": req.accessToken]
        case .fetchCompanyDetail(req: let req):
            return ["Authorization": req.accessToken]
        case .fetchMovieReviews(req: let req):
            return ["Authorization": req.accessToken]
        case .fetchSimilarMovies(req: let req):
            return ["Authorization": req.accessToken]
        case .fetchCombinedCredits(req: let req):
            return ["Authorization": req.accessToken]
        case .addRating(req: let req):
            return [
                "Authorization": req.accessToken,
                "accept": "application/json"
            ]
        }
    }
}
