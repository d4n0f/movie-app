//
//  FetchParticipantDetailRequest.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 06. 14..
//

import Foundation

protocol AccessTokenProtocol {
    var accessToken: String { get }
}

extension AccessTokenProtocol {
    var bearerToken: String {
        return "Bearer \(accessToken)"
    }
}

struct FetchParticipantDetailRequest: AccessTokenProtocol {
    var accessToken: String
    let personId: Int
    
    func asRequestParams() -> [String: Any] {
        return [:]
    }
}
