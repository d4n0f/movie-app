//
//  MovieListView.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 04. 15..
//

import SwiftUI
import InjectPropertyWrapper

struct TVListView: View {
    @StateObject private var viewModel = MediaItemListViewModel()
    let genre: Genre
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: LayoutConst.largePadding) {
                ForEach(viewModel.mediaItems) { movie in
                    MediaItemCell(movie: movie)
                }
            }
            .padding(.horizontal, LayoutConst.normalPadding)
            .padding(.top, LayoutConst.normalPadding)
        }
        .navigationTitle(genre.name)
        .alert(item: $viewModel.alertModel) { model in
            return Alert(
                title: Text(LocalizedStringKey(model.title)),
                message: Text(LocalizedStringKey(model.message)),
                dismissButton: .default(Text(LocalizedStringKey(model.dismissButtonTitle))) {
                    viewModel.alertModel = nil
                }
            )
        }
        .onAppear {
            viewModel.genreIdSubject.send(genre.id)
        }
    }
}

#Preview {
    MediaItemListView(genre: Genre(id: 28, name: "Action") )
}



#Preview {
    TVListView(genre: Genre(id: 80, name: "Crime"))
}
