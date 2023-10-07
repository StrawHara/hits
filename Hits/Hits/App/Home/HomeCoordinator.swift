//
//  HomeCoordinator.swift
//  Hits
//
//  Created by Romain Le Drogo on 07/10/2023.
//

import UIKit

final class HomeCoordinator: NSObject {
    
    private(set) var homeNav: UINavigationController
    
    private let homeVC: HomeViewController
    private var homeVM: HomeViewModel?
    //    private let artistDetailsVC:

    private var deezerService: DeezerService
    
    init(deezerService: DeezerService) {
        self.deezerService = deezerService
        
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
        self.homeVC.setup(viewModel: self.homeVM)
    }

}

extension HomeCoordinator: HomeViewModelDelegate {
    func didUpdate() {
        self.homeVC.refresh()
    }
}
