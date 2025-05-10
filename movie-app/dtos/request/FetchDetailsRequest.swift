//
//  fetchDetails.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 05. 10..
//

struct FetchDetailRequest {
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    
    func asRequestParams() -> [String: Any] {
        return [:]
    }
}
