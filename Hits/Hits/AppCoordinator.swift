//
//  AppCoordinator.swift
//  Hits
//
//  Created by Romain Le Drogo on 06/10/2023.
//

import Foundation
import UIKit

enum TabbarItem: Int {
    case hits = 0
    case player
    case history
}

final class AppCoordinator: NSObject {
    
    private var window: UIWindow?
    
    private var tabbarController: UITabBarController

    private let homeCoordinator: HomeCoordinator

    private var playerNav: UINavigationController
    private let playerVC: PlayerViewController

    private var historyNav: UINavigationController
    private let historyVC: HistoryViewController

    private var deezerService = DeezerService()
    private var audioManager = AudioManager()
    private var coreDataStack = CoreDataStack()

    // MARK: Init
    init(window: UIWindow?) {
        self.window = window
        
        self.audioManager.setup(coreDataStack: self.coreDataStack)

        self.homeCoordinator = HomeCoordinator(deezerService: self.deezerService, audioManager: self.audioManager)

        self.playerVC = PlayerViewController.instantiate()
        self.playerNav = UINavigationController(rootViewController: self.playerVC)
        self.playerNav.tabBarItem = UITabBarItem(title: "Player", // TODO: Trad
                                                 image: UIImage(systemName: "play.circle.fill"), // TODO: pause.circle.fill
                                                 tag: TabbarItem.player.rawValue)

        self.historyVC = HistoryViewController()
        self.historyVC.setup(coreDataStack: self.coreDataStack, audioManager: self.audioManager)
        self.historyNav = UINavigationController(rootViewController: self.historyVC)
        self.historyNav.tabBarItem = UITabBarItem(title: "History", // TODO: Trad
                                               image: UIImage(systemName: "list.triangle"),
                                               tag: TabbarItem.history.rawValue)

        // MARK: Tabbar
        self.tabbarController = UITabBarController()
        self.tabbarController.viewControllers = [self.homeCoordinator.homeNav, self.playerNav, self.historyNav]
        self.tabbarController.tabBar.contentMode = .scaleAspectFill
        self.tabbarController.tabBar.clipsToBounds = false

        self.window?.rootViewController = self.tabbarController
    }
    
    // MARK: Coordinator implementation
    func start() {}

}
