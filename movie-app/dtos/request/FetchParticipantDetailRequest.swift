//
//  FetchParticipantDetailRequest.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 06. 14..
//

import Foundation

struct FetchParticipantDetailRequest {
    let accessToken: String = Config.bearerToken
    let personId: Int
    
    func asRequestParams() -> [String: Any] {
        return [:]
    }
}
