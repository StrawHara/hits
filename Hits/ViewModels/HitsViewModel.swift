//
//  HitsViewModel.swift
//  Hits
//
//  Created by Romain Le Drogo on 06/10/2023.
//

import Foundation
import Combine

final class ArtistsViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    let service: DeezerServiceProtocol
    
    @Published var artists: [Artist] = []
    
    init(service: DeezerServiceProtocol) {
        self.service = service
    }
    
    func fetchArtists() {
        self.service.getArtists()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { data in
                print(data)
                
            }, receiveValue: {[weak self] data in
                print(data)
                self?.artists = data
            }).store(in: &cancellables)
    }
    
}
