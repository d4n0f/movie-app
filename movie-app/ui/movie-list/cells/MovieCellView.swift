//
//  MovieCellView.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 04. 26..
//

import SwiftUI

struct MovieCellView: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: LayoutConst.smallPadding) {
            ZStack(alignment: .topLeading) {
                HStack(alignment: .center) {
                    AsyncImage(url: movie.imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ZStack {
                                Color.gray.opacity(0.3)
                                ProgressView()
                            }

                        case let .success(image):
                            image
                                .resizable()
                                .scaledToFill()

                        case .failure(let error):
                            ZStack {
                                Color.red.opacity(0.3)
                                Image(systemName: "photo")
                                    .foregroundColor(.white)
                            }
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(height: 100)
                    .frame(maxHeight: 180)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
                }
                
                HStack(spacing: LayoutConst.normalPadding) {
                    MovieLabel(type: .rating(movie.rating))
                    MovieLabel(type: .voteCount(movie.voteCount))
                }
                .padding(LayoutConst.smallPadding)
            }

            Text(movie.title)
                .font(Fonts.subheading)
                .lineLimit(2)

            Text("\(movie.year)")
                .font(Fonts.paragraph)

            Text("\(movie.duration)")
                .font(Fonts.caption)

            Spacer()
        }
    }
}
