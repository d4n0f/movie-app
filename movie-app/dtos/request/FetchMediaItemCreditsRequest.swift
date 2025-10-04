//
//  FetchMovieCreditsRequest.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 05. 10..
//

struct FetchMediaItemCreditsRequest {
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    
    func asRequestParams() -> [String: Any] {
        return [:]
    }
}
