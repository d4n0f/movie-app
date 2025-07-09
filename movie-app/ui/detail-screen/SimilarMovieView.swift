//
//  SimilarMovieView.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 07. 01..
//

import SwiftUI
import Lottie

struct SimilarMovieView: View {
    @StateObject var viewModel = DetailViewModel()
    
    let similarMovies: [MediaItem]
    
    var body: some View {
        Text("similar.movies.title")
            .font(Fonts.title)
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(similarMovies) { movie in
                    NavigationLink(destination: DetailView(mediaItem: movie)) {
                        MediaItemCell(movie: movie)
                            .frame(width: 180)
                            .frame(alignment: .leading)
                            .foregroundColor(.invertedMain)
                    }
                }
                if viewModel.isLoading {
                    LottieView(animation: .named("loading"))
                        .playing(loopMode: .loop)
                        .frame(width: 50, height: 50)
                }
            }
            .padding(.bottom, LayoutConst.normalPadding)
        }
    }
}
