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
    
    @AppStorage("color-scheme") var colorScheme: Theme = .light
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .preferredColorScheme(ColorScheme(theme: colorScheme))
        }
    }
}

