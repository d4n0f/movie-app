//
//  FetchSimilarMovieRequest.swift
//  movie-app-live
//
//  Created by Balint Fonad on 2025. 06. 19..
//

import Foundation

struct FetchSimilarMediaItemRequest {
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    let page: Int
    
    func asRequestParams() -> [String: Any] {
        return [
            "page": page
        ]
    }
}
