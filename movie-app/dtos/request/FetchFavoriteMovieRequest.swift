//
//  FetchFavoriteMovieRequest.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 05. 06..
//


struct FetchFavoriteMovieRequest {
    let accessToken: String = Config.bearerToken
    let accountId: Int = Config.accountId
    
    func asRequestParams() -> [String: Any] {
        return [:]
    }
}
