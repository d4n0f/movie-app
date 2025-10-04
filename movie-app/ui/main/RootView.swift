//
//  RootView.swift
//  movie-app-live
//
//  Created by Balint Fonad on 2025. 05. 15..
//

import SwiftUI
import Combine

struct RootView: View {
    @State var selectedTab: TabType = TabType.genre
    @StateObject private var viewModel = RootViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            MainTabView(selectedTab: $selectedTab)
            
            OfflineBannerView()
                .padding(.top, viewModel.isBannerAppear ? 0.0 : -200.0)
                .animation(.easeInOut(duration: 1), value: viewModel.isBannerAppear)

        }
    }
}
