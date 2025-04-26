//
//  GenreSectionCell.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 04. 26..
//

import SwiftUI

struct GenreSectionCell: View {
    var genre: Genre
    
    var body: some View {
        HStack {
            Text(genre.name)
                .font(Fonts.title)
                .foregroundColor(.primary)
                .accessibilityLabel(genre.name)
            Spacer()
            Image(.rightArrow)
        }
    }
}
