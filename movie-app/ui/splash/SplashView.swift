//
//  SplashView.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 06. 30..
//

import Lottie
import SwiftUI

struct SplashView: View {
    
    @State private var showRootView = false
    @State var selectedTab: TabType = TabType.genre
    
    var body: some View {
        if showRootView {
            RootView(selectedTab: selectedTab)
                .environmentObject(LanguageManager.shared)
        } else {
            CustomLottieView(name: "movies.lottie", completion: {
                showRootView = true
            })
        }
    }
}
