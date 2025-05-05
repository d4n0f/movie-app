//
//  MovieListView.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 04. 15..
//

import SwiftUI
import InjectPropertyWrapper

struct TVListView: View {
    @StateObject private var viewModel = TVListViewModel()
    let genre: Genre
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: LayoutConst.normalPadding)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: LayoutConst.largePadding) {
                ForEach(viewModel.tvSeries) { tv in
                    TVCellView(tv: tv)
                }
            }
            .padding(.horizontal, LayoutConst.normalPadding)
            .padding(.top, LayoutConst.normalPadding)
        }
        .navigationTitle(genre.name)
        .onAppear {
            Task {
                await viewModel.loadTVSeries(by: genre.id)
            }
        }
    }
}


#Preview {
    TVListView(genre: Genre(id: 80, name: "Crime"))
}
