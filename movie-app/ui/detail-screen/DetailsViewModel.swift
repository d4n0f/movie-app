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
    @Published var credits: [CastMember] = []
    @Published var isFavorite: Bool = false
    @Published var reviews: [MediaItemReview] = []
    @Published var similarMovies: [MediaItem] = []
    @Published var alertModel: AlertModel? = nil
    @Published var isLoading: Bool = false
    
    let mediaItemSubject = PassthroughSubject<MediaItem, Never>()
    let favoriteButtonTapped = PassthroughSubject<Void, Never>()
    let reachedBottomSubject = CurrentValueSubject<Void, Never>(())
    
    private var currentPage: Int = 0
    private var totalPages: Int = Int.max
    
    @Inject
    private var repository: MovieRepository
    
    @Inject
    private var mediaItemStore: MediaItemStoreProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
        let mediaItemSubject = mediaItemSubject.share()
        
        let details = mediaItemSubject
            .flatMap { [weak self]mediaItem in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchDetailRequest(mediaId: mediaItem.id)
                return Environments.name == .tv ? self.repository.fetchTVDetail(req: request) :
                                                  self.repository.fetchMovieDetail(req: request)
            }
        
        let credits = mediaItemSubject
            .flatMap { [weak self]mediaItem in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchMediaItemCreditsRequest(mediaId: mediaItem.id)
                return Environments.name == .tv ? self.repository.fetchTVCredits(req: request) : self.repository.fetchMovieCredits(req: request)
            }
        
        let reviews = mediaItemSubject
            .flatMap { [weak self]mediaItem in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchMediaItemReviewRequest(mediaId: mediaItem.id)
                return self.repository.fetchMovieReviews(req: request)
            }
        
        //TODO: Pagination
        let similars = mediaItemSubject
            .flatMap { [weak self]mediaItem in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                self.isLoading = true
                self.currentPage += 1
                let request = FetchSimilarMediaItemRequest(mediaId: mediaItem.id, page: self.currentPage)
                return self.repository.fetchSimilarMovie(req: request)
            }
        
        Publishers.CombineLatest4(details, credits, reviews, similars)
            .filter { [weak self]_ in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                return self.currentPage < self.totalPages
            }
            .handleEvents(receiveOutput: { [weak self]_ in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                self.isLoading = true
            })
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                    self?.isLoading = false
                }
            } receiveValue: { [weak self] details, credits, reviews, similars in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                self.mediaItemDetail = details
                self.credits = credits
                self.reviews = reviews.prefix(4).map { $0 }
                self.isFavorite = self.mediaItemStore.isMediaItemStored(withId: details.id)
                
                self.similarMovies.append(contentsOf: similars.mediaItems)
                self.totalPages = similars.totalPages
                self.isLoading = false
            }
            .store(in: &cancellables)
        
        favoriteButtonTapped
            .flatMap { [weak self] _ -> AnyPublisher<(ModifyMediaResult, Bool), MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let isFavorite = !self.isFavorite
                let request = EditFavouriteRequest(movieId: self.mediaItemDetail.id, isFavorite: isFavorite)
                return repository.editFavoriteMovie(req: request)
                    .map { result in
                    (result, isFavorite)
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
                    self.isFavorite = isFavorite
                    if isFavorite {
                        self.mediaItemStore.saveMediaItems([MediaItem(detail: self.mediaItemDetail)])
                    } else {
                        self.mediaItemStore.deleteMediaItem(withId: self.mediaItemDetail.id)
                    }
                }
            }
            .store(in: &cancellables)
    }
}
