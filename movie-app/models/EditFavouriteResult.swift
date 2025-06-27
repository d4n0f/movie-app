//
//  EditFavouriteResult.swift
//  movie-app-live
//
//  Created by Balint Fonad on 2025. 05. 13..
//

struct EditFavouriteResult {
    let success: Bool
    let statusCode: Int
    let statusMessage: String
    
    init(dto: EditFavouriteResponse) {
        self.success = dto.success
        self.statusCode = dto.statusCode
        self.statusMessage = dto.statusMessage
    }
}
