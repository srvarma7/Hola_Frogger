//
//  SceneDelegate.swift
//  TabView
//
//  Created by Varma on 12/04/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    private var storyboard: Bool    = false
    private var fullAPP: Bool       = true
    private var selecetedVC         = FrogDetailsVC()
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        
        if !storyboard {
            // Open application via code
            
            guard let windowScene = (scene as? UIWindowScene) else { return }
                        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
            window?.windowScene         = windowScene
//            window?.rootViewController  = createTabBar()
            window?.rootViewController  = fullAPP ? createTabBar() : selecetedVC
            window?.makeKeyAndVisible()
        }
        
        
    }
    
    private func createHomeNavC() -> UINavigationController {
        let homeVC          = HomeVC()
        homeVC.title        = "Home"
        homeVC.tabBarItem   = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        return UINavigationController(rootViewController: homeVC)
    }

    private func createNewsNavC() -> UINavigationController {
        let homeVC          = NewsVC()
        homeVC.title        = "News"
        homeVC.tabBarItem   = UITabBarItem(title: "News", image: UIImage(systemName: "dot.radiowaves.left.and.right"), tag: 0)
        return UINavigationController(rootViewController: homeVC)
    }
    
//    private func createsNewsNavC() -> UINavigationController {
//        let homeVC          = NewsVC()
//        homeVC.title        = "News"
//        homeVC.tabBarItem   = UITabBarItem(tabBarSystemItem: .search, tag: 1)
//
//        return UINavigationController(rootViewController: homeVC)
//    }
    
    private func createTabBar() -> UITabBarController {
        let tabBar = UITabBarController()
        tabBar.viewControllers = [createHomeNavC(), createNewsNavC()]
        UITabBar.appearance().tintColor = UIColor.raspberryPieTint()
        return tabBar
    }
    
//        let nav1 = UINavigationController()
//           let mainView = ViewController(nibName: nil, bundle: nil) //ViewController = Name of your controller
//           nav1.viewControllers = [mainView]
//           self.window!.rootViewController = nav1
        
        //change the layout for the first time using this application
        // guard let windowScene = (scene as? UIWindowScene) else { return }
        
        //  let infoDictionary = Bundle.main.infoDictionary
        //  let currentAppVersion = infoDictionary!["CFBundleShortVersionString"] as! String
        
        //get version number
        //   let userDefaults = UserDefaults.standard
        //  let appVersion = userDefaults.string(forKey: "appVersion")
        
        //  if appVersion == nil || appVersion != currentAppVersion {
        //save the latest version number
        //     userDefaults.setValue(currentAppVersion, forKey: "appVersion")
        
        //     self.window = UIWindow(windowScene: windowScene)
        //    window?.rootViewController = GuideViewController()
        //      window?.makeKeyAndVisible()
        //   }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

