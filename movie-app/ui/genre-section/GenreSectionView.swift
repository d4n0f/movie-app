//
//  ContentView.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 04. 22..
//


import SwiftUI
import InjectPropertyWrapper

struct GenreSectionView: View {
    @StateObject private var viewModel = GenreSectionViewModelImpl()
    
    var body: some View {
        let title = Environments.name == .tv ? "TV" : "genreSection.title".localized()
        NavigationView {
            ZStack(alignment: .topTrailing) {
                Image(.ellipse)
                    .ignoresSafeArea(edges: .top)
                
                List {
                    if let motd = viewModel.motdMovie {
                        GenreMotdCell(mediaItem: motd)
                            .background(Color.clear)
                            .listStyle(.plain)
                    }
                    
                    ForEach(viewModel.genres) { genre in
                        ZStack {
                            NavigationLink(destination: MediaItemListView(genre: genre)) {
                                EmptyView()
                            }
                            .opacity(0)
                            
                            GenreSectionCell(
                                genre: genre,
                                movies: viewModel.movies[genre.id] ?? [],
                                onExpand: {
                                    viewModel.loadMovies(for: genre)
                                }
                            )
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                }
                .padding(.bottom, LayoutConst.maxPadding)
                .listStyle(.plain)
                .navigationTitle(title)
                .accessibilityLabel("testCollectionView")
            }
        }
        .showAlert(model: $viewModel.alertModel)
        .onAppear{
            viewModel.loadGenres()
            viewModel.genresAppeared()
        }
    }
}

#Preview {
    GenreSectionView()
}
