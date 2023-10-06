//
//  AppCoordinator.swift
//  Hits
//
//  Created by Romain Le Drogo on 06/10/2023.
//

import Foundation
import UIKit

class AppCoordinator: NSObject {
    
    private enum TabbarItem: Int {
        case hits = 0
        case player
        case history
    }
    
    private var window: UIWindow?
    
    private var tabbarController: UITabBarController

    private var homeNav: UINavigationController
    private let homeVC: HomeViewController

    private var webServices = DeezerService()

    // MARK: Init
    init(window: UIWindow?) {
        self.window = window
        
        self.homeVC = HomeViewController.instantiate()
        self.homeNav = UINavigationController(rootViewController: self.homeVC)
        self.homeNav.tabBarItem = UITabBarItem(title: "Hits",
                                               image: UIImage(systemName: "chart"),
                                               tag: TabbarItem.hits.rawValue)
        // MARK: Tabbar
        self.tabbarController = UITabBarController()
        self.tabbarController.viewControllers = [self.homeNav]
        self.tabbarController.tabBar.contentMode = .scaleAspectFill
        self.tabbarController.tabBar.clipsToBounds = false

        self.window?.rootViewController = self.tabbarController
    }
    
    // MARK: Coordinator implementation
    func start() {
        self.launch()
    }
    
    fileprivate func launch() {
        
    }
    
}
