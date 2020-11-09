//
//  Storage.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 2/11/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import Foundation

struct Keys {
    static let hasLaunchedAppForFirstTime = "hasLaunchedAppForFirstTime"
    static let homeScreenDemoComplete = "homeScreenDemoComplete"
}

final class AppStorage {
    
    let defaults = UserDefaults.standard
    
    var hasLaunchedAppForFirstTime: Bool {
        get {
            return defaults.bool(forKey: Keys.hasLaunchedAppForFirstTime)
        }
        set {
            defaults.set(newValue, forKey: Keys.hasLaunchedAppForFirstTime)
        }
    }
    
    var homeScreenDemoComplete: Bool {
        get {
            return defaults.bool(forKey: Keys.homeScreenDemoComplete)
        }
        set {
            defaults.set(newValue, forKey: Keys.homeScreenDemoComplete)
        }
    }
    
}
