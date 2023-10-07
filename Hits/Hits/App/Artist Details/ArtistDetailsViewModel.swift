//
//  ArtistDetailsViewModel.swift
//  Hits
//
//  Created by Romain Le Drogo on 07/10/2023.
//

import Foundation
import Combine

protocol ArtistDetailsViewModelDelegate: AnyObject {
  func didUpdate()
}

final class ArtistDetailsViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    private let service: DeezerServiceProtocol
    private(set) var delegate: ArtistDetailsViewModelDelegate?
    
    private let artistID: Int
    var artist: Artist? = nil
    var songs: [Song] = []
    
    // MARK: Init
    init(artistID: Int, service: DeezerServiceProtocol, delegate: ArtistDetailsViewModelDelegate? = nil) {
        self.artistID = artistID
        self.service = service
        self.delegate = delegate
                
        self.refresh()
    }
    
    // MARK: Public
    func refresh() {
        self.fetchArtist()
        self.fetchArtistTopSongs()
    }
    
    // MARK: Private
    private func fetchArtist() {
        self.service.getArtist(artistID: self.artistID)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { data in
            }, receiveValue: {[weak self] data in
                self?.artist = data
                self?.delegate?.didUpdate()
            }).store(in: &cancellables)
    }

    private func fetchArtistTopSongs() {
        self.service.getArtistTopSongs(artistID: self.artistID)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { data in
            }, receiveValue: {[weak self] data in
                self?.songs = data
                self?.delegate?.didUpdate()
            }).store(in: &cancellables)
    }

}
