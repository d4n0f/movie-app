//
//  CombinedCreditsView.swift
//  movie-app-live
//
//  Created by Balint Fonad on 2025. 06. 27..
//

import SwiftUI

struct CombinedCreditsView: View {
    @StateObject private var viewModel = CombinedCreditsViewModel()
    let personId: Int
    
    let columns = [
        GridItem(.flexible(), spacing: LayoutConst.normalPadding),
        GridItem(.flexible(), spacing: LayoutConst.normalPadding)
    ]

    var body: some View {
        Text("combined.credits.title".localized())
            .font(Fonts.title)
            .padding(.top, LayoutConst.normalPadding)
            .frame(alignment: .leading)
        
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: LayoutConst.largePadding) {
                ForEach(viewModel.combinedCredits) { credit in
                        NavigationLink(destination: DetailView(mediaItem: MediaItem(credit: credit))) {
                            MediaItemCell(movie: MediaItem(credit: credit))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
            }
            .padding(.top, LayoutConst.smallPadding)
        }
        .onAppear {
            viewModel.personIdSubject.send(personId)
        }
    }
}
