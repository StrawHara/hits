//
//  HomeCoordinator.swift
//  Hits
//
//  Created by Romain Le Drogo on 07/10/2023.
//

import UIKit

protocol HomeCoordinatorDelegate: AnyObject {
    func showArtistDetails(artistID: Int)
}

final class HomeCoordinator: NSObject {
    
    private(set) var homeNav: UINavigationController
    
    private let homeVC: HomeViewController
    private var homeVM: HomeViewModel?

    private var deezerService: DeezerService
    private var audioManager: AudioManager
    
    init(deezerService: DeezerService, audioManager: AudioManager) {
        self.deezerService = deezerService
        self.audioManager = audioManager
        
        self.homeVC = HomeViewController.instantiate()
        self.homeNav = UINavigationController(rootViewController: self.homeVC)
        self.homeNav.tabBarItem = UITabBarItem(title: "Hits", // TODO: Trad
                                               image: UIImage(systemName: "chart.bar.fill"),
                                               tag: TabbarItem.hits.rawValue)
        
        super.init()
        
        self.start()
    }
    
    // MARK: Coordinator implementation
    func start() {
        self.homeVM = HomeViewModel(service: self.deezerService, delegate: self)
        self.homeVC.setup(viewModel: self.homeVM, delegate: self)
    }

}

extension HomeCoordinator: HomeViewModelDelegate {
    func didUpdate() {
        self.homeVC.refresh()
    }
}

extension HomeCoordinator: HomeCoordinatorDelegate {
    func showArtistDetails(artistID: Int) {
        let artistCoordinator = ArtistDetailsCoordinator(deezerService: self.deezerService, audioManager: self.audioManager, parentViewController: self.homeNav)
        artistCoordinator.showArtist(artistID: artistID)
    }
}
