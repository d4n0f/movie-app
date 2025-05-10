//
//  MovieLabel.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 04. 26..
//

import SwiftUI

enum MovieLabelType {
    case rating(_ value: Double)
    case voteCount(_ vote: Int)
    case popularity(_ popularity: Double)
    case adult(_ adult: Bool)
}

struct MovieLabel: View {
    
    let type: MovieLabelType
    
    var body: some View {
        var imageRes: ImageResource
        switch type {
        case .rating:
            imageRes = .star
        case .voteCount:
            imageRes = .heart
        case .popularity:
            imageRes = .popular
        case .adult:
            imageRes = .closeCaption
        }
        
        var text: String
        switch type {
        case .rating(let value):
            text = String(format: "%.1f", value)
        case .voteCount(let vote):
            text = "\(vote)"
        case .popularity(let popularity):
            text = "\(popularity)"
        case .adult(let adult):
            text = adult ? "available" : "unavailable"
        }
        
        return HStack(spacing: 6.0) {
            Image(imageRes)
            Text(LocalizedStringKey(text))
                .font(Fonts.labelBold)
        }
        .padding(6.0)
        .background(Color.mainLabelForeground)
        .cornerRadius(12)
    }
}
