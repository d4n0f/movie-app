//
//  AddFavoriteRequest.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 05. 06..
//


struct AddFavoriteRequest {
    let accessToken: String = Config.bearerToken
    let accountId: Int = Config.accountId
    let movieId: Int
    
    func asRequestParams() -> [String: Any] {
        return [:]
    }
}
