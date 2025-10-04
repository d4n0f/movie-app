//
//  RootViewModel.swift
//  movie-app-live
//
//  Created by Balint Fonad on 2025. 05. 16..
//

import Foundation
import InjectPropertyWrapper
import Combine

class RootViewModel: ObservableObject {
    
    @Inject
    private var networkMonitor: NetworkMonitorProtocol
    
    @Published var isBannerAppear: Bool = false
    
    let offlineNannerApperSubject = PassthroughSubject<Void, Error>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        networkMonitor.isConnected
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self]isConnected in
                if !isConnected {
                    self?.isBannerAppear = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                        self?.isBannerAppear = false
                    }
                }
            })
            .store(in: &cancellables)
    }
}
