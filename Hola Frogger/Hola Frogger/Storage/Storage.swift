//
//  Storage.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 2/11/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import Foundation

struct Keys {
    static let hasLaunchedAppForFirstTime   = "com.hasLaunchedApp_For_FirstTime"
    static let homeScreenDemoComplete       = "com.home_Screen_Demo_Complete"
    static let exploreScreenDemoComplete    = "com.explore_Screen_Demo_Complete"
    static let detailsScreenDemoComplete    = "com.details_Screen_Demo_Complete"
    static let identifyScreenDemoComplete   = "com.identify_Screen_Demo_Complete"
    static let challengeScreenDemoComplete  = "com.challenge_Screen_Demo_Complete"
    static let mapScreenDemoComplete        = "com.map_Screen_Demo_Complete"
    static let newsScreenDemoComplete       = "com.news_Screen_Demo_Complete"
}

struct AppStorage {
    
    static let defaults = UserDefaults.standard
    
    static var hasLaunchedAppForFirstTime: Bool {
        get {
            return defaults.bool(forKey: Keys.hasLaunchedAppForFirstTime)
        }
        set {
            defaults.set(newValue, forKey: Keys.hasLaunchedAppForFirstTime)
        }
    }
    
    static var homeScreenDemoComplete: Bool {
        get {
            return defaults.bool(forKey: Keys.homeScreenDemoComplete)
        }
        set {
            defaults.set(newValue, forKey: Keys.homeScreenDemoComplete)
        }
    }
    
    static var exploreScreenDemoComplete: Bool {
        get {
            return defaults.bool(forKey: Keys.exploreScreenDemoComplete)
        }
        set {
            defaults.set(newValue, forKey: Keys.exploreScreenDemoComplete)
        }
    }
    
    static var detailsScreenDemoComplete: Bool {
        get {
            return defaults.bool(forKey: Keys.detailsScreenDemoComplete)
        }
        set {
            defaults.set(newValue, forKey: Keys.detailsScreenDemoComplete)
        }
    }
    
    static var identifyScreenDemoComplete: Bool {
        get {
            return defaults.bool(forKey: Keys.identifyScreenDemoComplete)
        }
        set {
            defaults.set(newValue, forKey: Keys.identifyScreenDemoComplete)
        }
    }
    
    static var challengeScreenDemoComplete: Bool {
        get {
            return defaults.bool(forKey: Keys.challengeScreenDemoComplete)
        }
        set {
            defaults.set(newValue, forKey: Keys.challengeScreenDemoComplete)
        }
    }
    
    static var mapScreenDemoComplete: Bool {
        get {
            return defaults.bool(forKey: Keys.mapScreenDemoComplete)
        }
        set {
            defaults.set(newValue, forKey: Keys.mapScreenDemoComplete)
        }
    }
    
    static var newsScreenDemoComplete: Bool {
        get {
            return defaults.bool(forKey: Keys.newsScreenDemoComplete)
        }
        set {
            defaults.set(newValue, forKey: Keys.newsScreenDemoComplete)
        }
    }
}
