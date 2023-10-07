//
//  ArtistDetailsCoordinator.swift
//  Hits
//
//  Created by Romain Le Drogo on 07/10/2023.
//

import Foundation
import UIKit

protocol ArtistDetailsCoordinatorDelegate: AnyObject {
    func playSong(song: Song)
    func addToPlayList(songs: [Song])
}

final class ArtistDetailsCoordinator: NSObject {
    
    private let parentViewController: UIViewController
        
    private var artistDetailsVC: ArtistDetailsViewController? = nil
    private var artistViewModel: ArtistDetailsViewModel? = nil
    
    private var deezerService: DeezerService
    private var audioManager: AudioManager
    
    init(deezerService: DeezerService, audioManager: AudioManager,
         parentViewController: UIViewController) {
        self.deezerService = deezerService
        self.audioManager = audioManager
        
        self.parentViewController = parentViewController

        super.init()
    }
    
    func showArtist(artistID: Int) {
        let artistDetailsVC = ArtistDetailsViewController.instantiate()
        self.artistViewModel = ArtistDetailsViewModel(artistID: artistID, service: self.deezerService, delegate: self)
        
        self.artistDetailsVC = artistDetailsVC
        self.artistDetailsVC?.setup(viewModel: self.artistViewModel, delegate: self)

        (self.parentViewController as? UINavigationController)?.pushViewController(artistDetailsVC, animated: true)
    }

}

extension ArtistDetailsCoordinator: ArtistDetailsViewModelDelegate {
    func didUpdate() {
        self.artistDetailsVC?.refresh()
    }
}

extension ArtistDetailsCoordinator: ArtistDetailsCoordinatorDelegate {
    func playSong(song: Song) {
        self.audioManager.play(song: song)
    }
    
    func addToPlayList(songs: [Song]) {
        self.audioManager.addToPlaylist(songs: songs)
    }
    
}
