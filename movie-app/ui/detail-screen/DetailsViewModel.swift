//
//  DetailViewModel.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 05. 10..
//

import Foundation
import InjectPropertyWrapper
import Combine

protocol DetailViewModelProtocol: ObservableObject {
}

class DetailViewModel: DetailViewModelProtocol, ErrorPresentable {
    @Published var mediaItemDetail: MediaItemDetail = MediaItemDetail()
    @Published var alertModel: AlertModel? = nil
    @Published var cast: Cast = Cast()
    @Published var isFavourite: Bool = false
    
    let mediaItemIdSubject = PassthroughSubject<Int, Never>()
    let castSubject = PassthroughSubject<Int, Never>()
    let favoriteButtonTapped = PassthroughSubject<Void, Never>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        //TODO: a castSubject-et áthozni a mediaItemIdSubjectbe
        let details = mediaItemIdSubject
            .flatMap { [weak self]mediaItemId in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchDetailRequest(mediaId: mediaItemId)
                return self.service.fetchMovieDetails(req: request)
            }
        
        details
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] mediaItemDetail in
                self?.mediaItemDetail = mediaItemDetail
            }
            .store(in: &cancellables)
        
        
        let credits = castSubject
            .flatMap { [weak self] mediaId in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchMovieCreditsRequest(mediaId: mediaId)
                return self.service.fetchMovieCredits(req: request)
            }
        
        credits
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] cast in
                self?.cast = cast
            }
            .store(in: &cancellables)
        
        favoriteButtonTapped
            .flatMap { [weak self] _ -> AnyPublisher<(EditFavouriteResult, Bool), MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let isFavourite = !self.isFavourite
                let request = EditFavouriteRequest(movieId: self.mediaItemDetail.id, isFavorite: isFavourite)
                return service.editFavouriteMovies(req: request)
                    .map { result in
                    (result, isFavourite)
                }
                .eraseToAnyPublisher()
            }
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] result, isFavorite in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                if result.success {
                    self.isFavourite = isFavourite
                    if isFavorite {
                        //self.favoriteMediaStore.addFavoriteMediaItem(self.mediaItemDetail)
                    } else {
                        //self.favoruiteMediaStore.removeFavouriteMediaItem(withId: self.mediaItemDetail.id)
                    }
                }
            }
            .store(in: &cancellables)
    }
}

class DetailViewModel2: DetailViewModelProtocol, ErrorPresentable {
    @Published var alertModel: AlertModel? = nil
    @Published var mediaItem: MediaItemDetail = MediaItemDetail()
    @Published var isFavorite: Bool = false
    @Published var cast: Cast = Cast()
    
    let mediaItemIdSubject = PassthroughSubject<Int, Never>()
    let favoriteButtonTapped = PassthroughSubject<Void, Never>()
    let castSubject = PassthroughSubject<Int, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    init() {
        mediaItemIdSubject
            .flatMap { [weak self] mediaItemId -> AnyPublisher<MediaItemDetail, MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchDetailRequest(mediaId: mediaItemId)
                return self.service.fetchMovieDetails(req: request)
            }
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] mediaItem in
                self?.mediaItem = mediaItem
            }
            .store(in: &cancellables)
        
        favoriteButtonTapped
            .flatMap { [weak self] mediaItemId -> AnyPublisher<EditFavouriteResult, MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = EditFavouriteRequest(movieId: mediaItem.id, isFavorite: true)
                return service.editFavouriteMovies(req: request)
            }
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] mediaItem in
                self?.isFavorite.toggle()
            }
            .store(in: &cancellables)
        
        castSubject
            .flatMap { [weak self] mediaId -> AnyPublisher<Cast, MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchMovieCreditsRequest(mediaId: mediaId)
                return service.fetchMovieCredits(req: request)
            }
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] cast in
                self?.cast = cast
            }
            .store(in: &cancellables)
    }
}
