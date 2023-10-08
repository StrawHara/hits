//
//  HitsViewModel.swift
//  Hits
//
//  Created by Romain Le Drogo on 06/10/2023.
//

import Foundation
import Combine

protocol HitsViewModelDelegate: AnyObject {
  func didUpdate()
}

final class HitsViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    private let service: DeezerServiceProtocol
    private(set) var title: String
    private(set) var hitID: Int
    private(set) var delegate: HitsViewModelDelegate?
    
    private(set) var artists: [Artist] = []
    
    init(service: DeezerServiceProtocol, hitID: Int, title: String, delegate: HitsViewModelDelegate? = nil) {
        self.service = service
        self.hitID = hitID
        self.title = title
        self.delegate = delegate
    }
    
    func fetchArtists() {
        self.service.getHitsArtists(hitID: self.hitID)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { data in
            }, receiveValue: {[weak self] data in
                self?.artists = data
                self?.delegate?.didUpdate()
            }).store(in: &cancellables)
    }
    
}
