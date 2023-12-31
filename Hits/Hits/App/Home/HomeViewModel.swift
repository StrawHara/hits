//
//  HomeViewModel.swift
//  Hits
//
//  Created by Romain Le Drogo on 07/10/2023.
//

import Foundation
import Combine

protocol HomeViewModelDelegate: AnyObject {
  func didUpdate()
}

final class HomeViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    private let service: DeezerServiceProtocol
    private(set) var delegate: HomeViewModelDelegate?
    
    var hits: [HitsViewModel] = []
    
    // MARK: Init
    init(service: DeezerServiceProtocol, delegate: HomeViewModelDelegate? = nil) {
        self.service = service
        self.delegate = delegate
        
        // TODO: Find real hits ids
        self.hits.append(HitsViewModel(service: service, hitID: 0, title: "Top French hits", delegate: self))
        self.hits.append(HitsViewModel(service: service, hitID: 2, title: "Top hip-hop artists", delegate: self))
        self.hits.append(HitsViewModel(service: service, hitID: 12, title: "Top happy mood hits", delegate: self))
        self.hits.append(HitsViewModel(service: service, hitID: 16, title: "Best morning hits", delegate: self))
        self.hits.append(HitsViewModel(service: service, hitID: 52, title: "Top dancing hits", delegate: self))
        self.hits.append(HitsViewModel(service: service, hitID: 54, title: "Best love songs", delegate: self))
        
        self.fetchHits()
    }
    
    // MARK: Public
    func refresh() {
        self.fetchHits()
    }
    
    // MARK: Private
    private func fetchHits() {
        self.hits.forEach { hit in
            hit.fetchArtists()
        }
    }
    
}

extension HomeViewModel: HitsViewModelDelegate {
    func didUpdate() {
        self.delegate?.didUpdate()
    }
}
