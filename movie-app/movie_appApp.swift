//
//  movie_appApp.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 04. 22..
//

import SwiftUI

@main
struct movie_app_liveApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State var selectedTab: TabType = TabType.genre
    
    @AppStorage("color-scheme") var colorSchemeRawValue: String = "light"
    
    var colorScheme: ColorScheme {
        if colorSchemeRawValue == "light" {
            return .light
        } else {
            return .dark
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(selectedTab: selectedTab)
                .preferredColorScheme(colorScheme)
        }
    }
}

