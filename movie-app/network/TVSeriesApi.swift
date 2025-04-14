//
//  MoviesApi.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 04. 12..
//

import Foundation
import Moya

enum TVSeriesApi {
    case fetchGenres(req: FetchGenreRequest)
}

extension TVSeriesApi: TargetType {
    var baseURL: URL {
        //TODO: Másik baseUrl
        let baseUrl = "https://api.themoviedb.org/3/"
        guard let baseUrl = URL(string: baseUrl) else {
            preconditionFailure("Base url not valid url")
        }
        return baseUrl
    }
    
    var path: String {
        switch self {
        case .fetchGenres: // a let elhagyható ha a paraméterrel nem dolgozunk
            return "genre/tv/list"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchGenres: // a let elhagyható ha a paraméterrel nem dolgozunk
            return .get // Method.get-et rövidítjük -> get request
        }
    }
    //TODO: Másik encoding
    var task: Moya.Task {
        switch self {
        case let .fetchGenres(req): // a let nem hagyható el, ha a paraméterrel dolgozunk
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .fetchGenres(req): // a let nem hagyható el, ha a paraméterrel dolgozunk
            return ["Authorization": req.accessToken]
        }
    }
}
