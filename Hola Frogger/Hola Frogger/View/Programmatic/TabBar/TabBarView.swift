//
//  TabBarView.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 4/11/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import Foundation
import UIKit

class TabBarView {
    
    static func createTabBar() -> UITabBarController {
        let tabBar = UITabBarController()
        tabBar.viewControllers = [
            createHomeNavC(),
            createIdentifyVC(),
            createChallengeVC(),
            createMapVC(),
            createNewsNavC()
        ]
        UITabBar.appearance().tintColor = UIColor.raspberryPieTint()
        return tabBar
    }
    
    static private func createHomeNavC() -> UINavigationController {
        let homeVC          = HomeVC()
        homeVC.title        = "Home"
        homeVC.tabBarItem   = UITabBarItem(title: "Home",
                                           image: UIImage(systemName: "house"),
                                           tag: 0)
        return UINavigationController(rootViewController: homeVC)
    }
    
    static private func createIdentifyVC() -> UIViewController {
        let identifyVC        = IdentifyVC()
        identifyVC.tabBarItem = UITabBarItem(title: "Identify",
                                             image: UIImage(systemName: "camera.viewfinder"),
                                             tag: 1)
        return identifyVC
    }
    
    static private func createMapVC() -> UIViewController {
        let mapVC        = MapVC()
        mapVC.tabBarItem = UITabBarItem(title: "Map",
                                        image: UIImage(systemName: "map"),
                                        tag: 2)
        return mapVC
    }
    
    static private func createChallengeVC() -> UIViewController {
        let challengeVC        = ChallengeVC()
        challengeVC.tabBarItem = UITabBarItem(title: "Challenge",
                                              image: UIImage(systemName: "gamecontroller"),
                                              tag: 3)
        return challengeVC
    }
    
    static private func createNewsNavC() -> UINavigationController {
        let newsVC          = NewsVC()
        newsVC.title        = "News"
        newsVC.tabBarItem   = UITabBarItem(title: "News", image: UIImage(systemName: "dot.radiowaves.left.and.right"), tag: 4)
        
        return UINavigationController(rootViewController: newsVC)
    }
}
