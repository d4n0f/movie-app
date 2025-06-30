//
//  ViewModelAssembly.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 06. 30..
//


import Swinject
import Foundation
import Combine

class ViewModelAssembly: Assembly {

    func assemble(container: Container) {
        container.register((any MovieListViewModelProtocol).self) { _ in
            return MovieListViewModel()
        }.inObjectScope(.transient)
        
        container.register((any GenreSectionViewModel).self) { _ in
            return GenreSectionViewModelImpl()
        }.inObjectScope(.container)
        
        container.register((any SearchViewModelProtocol).self) { _ in
            return SearchViewModel()
        }.inObjectScope(.transient)
        
        container.register((any FavoritesViewModelProtocol).self) { _ in
            return FavoritesViewModel()
        }.inObjectScope(.transient)
        
        container.register((any SettingsViewModelProtocol).self) { _ in
            return SettingsViewModel()
        }.inObjectScope(.transient)
    }
}
