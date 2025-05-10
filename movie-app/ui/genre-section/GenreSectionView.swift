//
//  ContentView.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 04. 22..
//


import SwiftUI
import Foundation
import InjectPropertyWrapper

struct GenreSectionView: View {
    @StateObject private var viewModel = GenreSectionViewModel()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topTrailing) {
                Image(.ellipse)
                    .ignoresSafeArea(edges: .top)
                
                List(viewModel.genres) { genre in // listán végigiterálás
                    ZStack {
                        NavigationLink(destination: MovieListView(genre: genre)) {
                            EmptyView()
                        }
                        .opacity(0)
                        
                        GenreSectionCell(genre: genre)
                    }
                    .listRowBackground(Color.clear) // lista sorainak hátterének kikapcsolása
                    .listRowSeparator(.hidden)// lista separatorok eltüntetése
                }
                .listStyle(.plain)
                .navigationTitle(Environment.name == .tv ? "TV" : "genreSection.title")
                .accessibilityLabel("testCollectionView")
            }
        }
        .alert(item: $viewModel.alertModel) { model in
            return Alert(
                title: Text(LocalizedStringKey(model.title)),
                message: Text(LocalizedStringKey(model.message)),
                dismissButton: .default(Text(LocalizedStringKey(model.dismissButtonTitle))) {
                    viewModel.alertModel = nil
                }
            )
        }
    }
}

#Preview {
    GenreSectionView()
}
