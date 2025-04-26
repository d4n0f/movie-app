//
//  ContentView.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 04. 22..
//


import SwiftUI
import InjectPropertyWrapper

protocol GenreSectionViewModelProtocol: ObservableObject {
    
}

class GenreSectionViewModel: GenreSectionViewModelProtocol {
    @Published var genres: [Genre] = []
    
    @Inject
    private var movieService: MoviesServiceProtocol
    
    func fetchGenres() async {
   
        do {
            let request = FetchGenreRequest()
            let genres = Environment.name == .tv ?
            try await movieService.fetchTVGenres(req: request) : try await movieService.fetchGenres(req: request)
            DispatchQueue.main.async {
                self.genres = genres
            }
        } catch {
            print("Error fetching genres: \(error)")
        }
    }
}


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
                        
                        HStack { // vízszintes Stack
                            Text(genre.name)
                                .font(Fonts.title) // betűtípus beállítása
                                .foregroundStyle(.primaryText) // szöveg szín
                            Spacer() // bal és jobb szélre igazítás
                            Image(.rightArrow) // jobb oldali nyíl
                        }
                    }
                    .listRowBackground(Color.clear) // lista sorainak hátterének kikapcsolása
                    .listRowSeparator(.hidden)// lista separatorok eltüntetése
                }
                .listStyle(.plain)
                .navigationTitle(Environment.name == .dev ? "DEV" : (Environment.name == .prod ? "PROD" : "TV"))
            }
        }
        .onAppear() {
            Task {
                await viewModel.fetchGenres()
            }
        }
    }
}

#Preview {
    GenreSectionView()
}
