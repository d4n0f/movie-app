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
        }
        
        var text: String
        switch type {
        case .rating(value: let value):
            text = String(format: "%.1f", value)
        case .voteCount(vote: let vote):
            text = "\(vote)"
        }
        
        return HStack(spacing: 4.0) {
            Image(imageRes)
            Text(text)
                .font(Fonts.labelBold)
        }
        .padding(4.0)
        .background(Color.main.opacity(0.5))
        .cornerRadius(12)
    }
}
