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
    case searchMovies(req: SearchMovieRequest)
    case fetchTVSeries(req: FetchMediaListRequest)
    case fetchFavoriteMovies(req: FetchFavoriteMovieRequest)
    case editFavouriteMovies(req: EditFavouriteRequest)
    case fetchDetails(req: FetchDetailRequest)
    case fetchMovieCredits(req: FetchMovieCreditsRequest)
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
        case .fetchTVSeries:
            return "discover/tv"
        case let .fetchFavoriteMovies(req):
            return "account/\(req.accountId)/favorite/movies"
        case .editFavouriteMovies(req: let req):
            return "account/\(req.accountId)/favorite"
        case .fetchDetails(req: let req):
            return "movie/\(req.mediaId)"
        case .fetchMovieCredits(let req):
            return "movie/\(req.mediaId)/credits"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchGenres,.fetchTVGenres, .fetchMovies, .searchMovies, .fetchTVSeries, .fetchFavoriteMovies, .fetchDetails, .fetchMovieCredits:
            return .get
        case .editFavouriteMovies:
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
        case .fetchTVSeries(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchFavoriteMovies(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .editFavouriteMovies(req: let req):
                    //return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.httpBody)
                    let request = EditFavouriteRequest(movieId: req.movieId, isFavorite: req.isFavorite)
                        return .requestJSONEncodable(request)
        case .fetchDetails(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .fetchMovieCredits(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
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
        case .fetchMovieCredits(req: let req):
            return ["Authorization": req.accessToken]
        }
    }
}
