//
//  ContentView.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 04. 22..
//

import SwiftUI

class GenreSectionViewModel: ObservableObject {
    @Published var genres: [Genre] = []
    
    private var movieService: GenreServiceProtocol = MoviesService()
    private var tvService: GenreServiceProtocol = TVSeriesService()
    private var service: GenreServiceProtocol?
    
    func fetchGenres() async {
        // megnézi, hogy melyik sémát használjuk és az alapján választja ki a filmeket/sorozatokat
        if Environment.name == .dev || Environment.name == .prod {
            service = movieService
        } else {
            service = tvService
        }
        
        // mivel a service optional ezért le kell kezelni, hogy nehogy nil legyen benne
        guard let service = service else {
                print("Service is not available")
                return
            }
        
        do {
            let request = FetchGenreRequest()
            let genres = try await service.fetchGenres(req: request)
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
                    .offset(x: 0, y: -153)
                
                List(viewModel.genres) { genre in // listán végigiterálás
                    ZStack {
                        NavigationLink(destination: Color.gray) {
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
