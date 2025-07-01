//
//  FetchMediaItemReviewRequest.swift
//  movie-app-live
//
//  Created by Balint Fonad on 2025. 06. 19..
//

import Foundation

struct FetchMediaItemReviewRequest{
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    
    func asRequestParams() -> [String: Any]{
        return [:]
    }
}
