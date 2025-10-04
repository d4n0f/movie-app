//
//  CombinedCreditsViewModel.swift
//  movie-app-live
//
//  Created by Balint Fonad on 2025. 06. 27..
//

import Foundation
import Combine
import InjectPropertyWrapper

protocol CombinedCreditsViewModelProtocol: ObservableObject {
    var combinedCredits: [CombinedCreditCast] { get }
}

class CombinedCreditsViewModel: CombinedCreditsViewModelProtocol, ErrorPresentable {
    @Published var combinedCredits: [CombinedCreditCast] = []
    @Published var alertModel: AlertModel? = nil
    
    let personIdSubject = PassthroughSubject<Int, Never>()
    
    @Inject
    private var repository: MovieRepository
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        personIdSubject
            .flatMap { [weak self] personId -> AnyPublisher<CombinedCredits, MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchParticipantDetailRequest(personId: personId)
                return self.repository.fetchCombinedCredits(req: request)
            }
            .map({ combinedCredits in
                combinedCredits.cast.sorted { $0.fixTitle < $1.fixTitle }
            })
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            }, receiveValue: { [weak self] combinedCredit in
                self?.combinedCredits = combinedCredit
            })
            .store(in: &cancellables)
    }
}
