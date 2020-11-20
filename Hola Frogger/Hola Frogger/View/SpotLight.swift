//
//  SpotLight.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 9/11/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import Foundation
import AwesomeSpotlightView

class SpotLight {
    
    private static func startSpotlight(view: UIView, spotLight: [AwesomeSpotlight], vc: UIViewController) {
        let spotlightView = AwesomeSpotlightView(frame: view.frame,
                                                 spotlight: spotLight)
        spotlightView.cutoutRadius = 8
        view.addSubview(spotlightView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if vc.traitCollection.userInterfaceStyle == .light {
                spotlightView.spotlightMaskColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
            } else {
                spotlightView.spotlightMaskColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
            }
            spotlightView.enableArrowDown = true
            spotlightView.start()
        }
    }
    
    private static func showSpotLightNotAvailable() {
        debugPrint("Unknow device screen size detected, spotlight tour not avaiable")
    }
    
    static func showForHomeScreen(view: UIView, vc: UIViewController) {
        if !AppStorage.homeScreenDemoComplete {
            let spotLight = AwesomeSpotlightView()
            spotLight.delegate = vc as? AwesomeSpotlightViewDelegate
            
            var spotlightMain   = AwesomeSpotlight()
            var searchLight     = AwesomeSpotlight()
            var exploreAllLight = AwesomeSpotlight()
            var properDevice    = false
            
            switch Size.height {
            case 896.0:
                debugPrint("11 Pro Max, Xs Max, 11, Xr")
                spotlightMain   = AwesomeSpotlight(withRect: CGRect(x: Size.width/2 - 110, y: 35, width: 220, height: 75),
                                                   shape: .circle,
                                                   text: "\n\nWelcome\n\n\n\n\n\n\nTap anywhere on the grey area to continue",
                                                   isAllowPassTouchesThroughSpotlight: false)
                
                searchLight     = AwesomeSpotlight(withRect: CGRect(x: Size.width/2 - 192.5, y: 290, width: 385, height: 70),
                                                   shape: .roundRectangle,
                                                   text: "You can search for a specifc frog here",
                                                   isAllowPassTouchesThroughSpotlight: false)
                
                exploreAllLight = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 33, y: 665, width: 350, height: 110),
                                                   shape: .roundRectangle,
                                                   text: "\n\n\nYou can explore all frogs here",
                                                   isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                break
                
            case 812.0:
                debugPrint(("11 Pro, X, XS"))
                spotlightMain   = AwesomeSpotlight(withRect: CGRect(x: Size.width/2 - 110, y: 35, width: 220, height: 75),
                                                   shape: .circle,
                                                   text: "\n\nWelcome\n\n\n\n\n\n\nTap anywhere on the grey area to continue",
                                                   isAllowPassTouchesThroughSpotlight: false)
                
                searchLight     = AwesomeSpotlight(withRect: CGRect(x: Size.width/2 - 192.5, y: 290, width: 385, height: 70),
                                                   shape: .roundRectangle,
                                                   text: "You can search for a specifc frog here",
                                                   isAllowPassTouchesThroughSpotlight: false)
                
                exploreAllLight = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 35, y: 615, width: 300, height: 50),
                                                   shape: .roundRectangle,
                                                   text: "\n\n\nYou can explore all frogs here",
                                                   isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                break
                
            case 736.0:
                debugPrint("Spotlight - 6+, 6s+, 7+, 8+")
                spotlightMain   = AwesomeSpotlight(withRect: CGRect(x: Size.width/2 - 110, y: 12, width: 220, height: 75),
                                                   shape: .circle,
                                                   text: "\n\nWelcome\n\n\n\n\n\n\nTap anywhere on the grey area to continue",
                                                   isAllowPassTouchesThroughSpotlight: false)
                
                searchLight     = AwesomeSpotlight(withRect: CGRect(x: Size.width/2 - 192.5, y: 265, width: 385, height: 70),
                                                   shape: .roundRectangle, text: "You can search for a specifc frog here",
                                                   isAllowPassTouchesThroughSpotlight: false)
                
                exploreAllLight = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 33, y: 553, width: 350, height: 90),
                                                   shape: .roundRectangle, text: "\n\n\nYou can explore all frogs here",
                                                   isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                break
                
            case 667:
                debugPrint("Spotlight - 6, 6s, 7, 8")
                spotlightMain   = AwesomeSpotlight(withRect: CGRect(x: Size.width/2 - 110, y: 12, width: 220, height: 75),
                                                   shape: .circle,
                                                   text: "\n\nWelcome\n\n\n\n\n\n\nTap anywhere on the grey area to continue",
                                                   isAllowPassTouchesThroughSpotlight: false)
                
                searchLight     = AwesomeSpotlight(withRect: CGRect(x: Size.width/2 - 192.5, y: 265, width: 385, height: 70),
                                                   shape: .roundRectangle, text: "You can search for a specifc frog here",
                                                   isAllowPassTouchesThroughSpotlight: false)
                
                exploreAllLight = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 13, y: 475, width: 350, height: 110),
                                                   shape: .roundRectangle, text: "\n\n\nYou can explore all frogs here",
                                                   isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                break
                
            default:
                debugPrint("Unknown screen size")
                
                break
            }
            
            if properDevice {
                startSpotlight(view: view,
                               spotLight: [spotlightMain, searchLight, exploreAllLight],
                               vc: vc)
            }
            AppStorage.homeScreenDemoComplete = true
        }
        
    }
    
    static func showForExplore(view: UIView, vc: UIViewController) {
        if !AppStorage.exploreScreenDemoComplete {
            let spotLight = AwesomeSpotlightView()
            spotLight.delegate = vc as? AwesomeSpotlightViewDelegate
            
            var image = AwesomeSpotlight()
            var commonName = AwesomeSpotlight()
            var scientificName = AwesomeSpotlight()
            var status = AwesomeSpotlight()
            var favourite = AwesomeSpotlight()
            
            var properDevice = false
            
            switch Size.height {
            case 896.0:
                debugPrint("11 Pro Max, Xs Max, 11, Xr")
                image           = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 10, y: 97, width: 80, height: 80),
                                                   shape: .circle,
                                                   text: "\nFrog's image",
                                                   isAllowPassTouchesThroughSpotlight: false)
                commonName      = AwesomeSpotlight(withRect: CGRect(x: 90, y: 108, width: 160, height: 30),
                                                   shape: .roundRectangle,
                                                   text: "Frog's common name",
                                                   isAllowPassTouchesThroughSpotlight: false)
                scientificName  = AwesomeSpotlight(withRect: CGRect(x: 90, y: 140, width: 185, height: 25),
                                                   shape: .roundRectangle,
                                                   text: "Frog's scientific name",
                                                   isAllowPassTouchesThroughSpotlight: false)
                status          = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 368, y: 117, width: 40, height: 40),
                                                   shape: .circle,
                                                   text: "Frog's threatened status\n\nE-Endangered\nV-Vulnerable\nN-Not Endangered",
                                                   isAllowPassTouchesThroughSpotlight: false)
                favourite       = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 340, y: 25, width: 80, height: 80),
                                                   shape: .circle,
                                                   text: "Filter by favourite",
                                                   isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                
                break
                
            case 812.0:
                debugPrint("11 Pro, X, Xs")
                image           = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 10, y: 97, width: 80, height: 80),
                                                   shape: .circle,
                                                   text: "\nFrog's image",
                                                   isAllowPassTouchesThroughSpotlight: false)
                commonName      = AwesomeSpotlight(withRect: CGRect(x: 90, y: 108, width: 160, height: 30),
                                                   shape: .roundRectangle,
                                                   text: "Frog's common name",
                                                   isAllowPassTouchesThroughSpotlight: false)
                scientificName  = AwesomeSpotlight(withRect: CGRect(x: 90, y: 140, width: 185, height: 25),
                                                   shape: .roundRectangle,
                                                   text: "Frog's scientific name",
                                                   isAllowPassTouchesThroughSpotlight: false)
                status          = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 330, y: 117, width: 40, height: 40),
                                                   shape: .circle,
                                                   text: "Frog's threatened status\n\nE-Endangered\nV-Vulnerable\nN-Not Endangered",
                                                   isAllowPassTouchesThroughSpotlight: false)
                favourite       = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 310, y: 25, width: 80, height: 80),
                                                   shape: .circle,
                                                   text: "Filter by favourite",
                                                   isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                
                break
                
            case 736.0:
                debugPrint("Spotlight  - 6+, 6s+, 7+, 8+")
                image           = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 10, y: 75, width: 80, height: 80),
                                                   shape: .circle,
                                                   text: "\nFrog's image",
                                                   isAllowPassTouchesThroughSpotlight: false)
                commonName      = AwesomeSpotlight(withRect: CGRect(x: 90, y: 85, width: 160, height: 30),
                                                   shape: .roundRectangle,
                                                   text: "Frog's common name",
                                                   isAllowPassTouchesThroughSpotlight: false)
                scientificName  = AwesomeSpotlight(withRect: CGRect(x: 90, y: 117, width: 185, height: 25),
                                                   shape: .roundRectangle,
                                                   text: "Frog's scientific name",
                                                   isAllowPassTouchesThroughSpotlight: false)
                status          = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 367, y: 95, width: 40, height: 40),
                                                   shape: .circle,
                                                   text: "Frog's threatened status\n\nE-Endangered\nV-Vulnerable\nN-Not Endangered",
                                                   isAllowPassTouchesThroughSpotlight: false)
                favourite       = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 340, y: 15, width: 80, height: 80),
                                                   shape: .circle,
                                                   text: "Filter by favourite",
                                                   isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                
                break
                
            case 667:
                debugPrint("Spotlight  - 6, 6s, 7, 8")
                image           = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 10, y: 75, width: 80, height: 80),
                                                   shape: .circle,
                                                   text: "\nFrog's image",
                                                   isAllowPassTouchesThroughSpotlight: false)
                commonName      = AwesomeSpotlight(withRect: CGRect(x: 90, y: 85, width: 160, height: 30),
                                                   shape: .roundRectangle,
                                                   text: "Frog's common name",
                                                   isAllowPassTouchesThroughSpotlight: false)
                scientificName  = AwesomeSpotlight(withRect: CGRect(x: 90, y: 117, width: 185, height: 25),
                                                   shape: .roundRectangle,
                                                   text: "Frog's scientific name",
                                                   isAllowPassTouchesThroughSpotlight: false)
                status          = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 330, y: 95, width: 40, height: 40),
                                                   shape: .circle,
                                                   text: "Frog's threatened status\n\nE-Endangered\nV-Vulnerable\nN-Not Endangered",
                                                   isAllowPassTouchesThroughSpotlight: false)
                favourite       = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 310, y: 15, width: 80, height: 80),
                                                   shape: .circle,
                                                   text: "Filter by favourite",
                                                   isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                break
                
            default:
                showSpotLightNotAvailable()
                break
            }
            
            if properDevice {
                startSpotlight(view: view,
                               spotLight: [image, commonName, scientificName, status, favourite],
                               vc: vc)
            }
            AppStorage.exploreScreenDemoComplete = true
        }
    }
    
    static func showForDetails(view: UIView, vc: UIViewController) {
        if !AppStorage.detailsScreenDemoComplete {
            let spotLight = AwesomeSpotlightView()
            spotLight.delegate = vc as? AwesomeSpotlightViewDelegate
            
            var mapAnnotation = AwesomeSpotlight()
            var weather = AwesomeSpotlight()
            var favUnfav = AwesomeSpotlight()
            
            var properDevice = false
            
            
            switch Size.height {
            case 896.0:
                debugPrint("11 Pro Max, Xs Max, 11, Xr")
                mapAnnotation = AwesomeSpotlight(withRect: CGRect(x: Size.centerWidth - 75, y: 130, width: 150, height: 90),
                                                 shape: .circle,
                                                 text: "\n\nFrog's geographical location",
                                                 isAllowPassTouchesThroughSpotlight: false)
                weather = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY+8, y: 0, width: 400, height: 65),
                                           shape: .roundRectangle,
                                           text: "Weather conditions at frog's location",
                                           isAllowPassTouchesThroughSpotlight: false)
                favUnfav = AwesomeSpotlight(withRect: CGRect(x: Size.width - 70, y: 260, width: 60, height: 60),
                                            shape: .circle,
                                            text: "Make favourite or unfavourite a frog",
                                            isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                
                break
                
            case 812.0:
                debugPrint("11 Pro, X, Xs")
                mapAnnotation   = AwesomeSpotlight(withRect: CGRect(x: Size.centerWidth - 75, y: 120, width: 150, height: 90),
                                                   shape: .circle,
                                                   text: "\n\nFrog's geographical location",
                                                   isAllowPassTouchesThroughSpotlight: false)
                weather         = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY+8, y: 0, width: Size.width-15, height: 65),
                                                   shape: .roundRectangle,
                                                   text: "Weather conditions at frog's location",
                                                   isAllowPassTouchesThroughSpotlight: false)
                favUnfav        = AwesomeSpotlight(withRect: CGRect(x: Size.width - 70, y: 240, width: 60, height: 60),
                                                   shape: .circle,
                                                   text: "Make favourite or unfavourite a frog",
                                                   isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                
                break
                
            case 736.0:
                debugPrint("Spotlight - 6+, 6s+, 7+, 8+")
                mapAnnotation   = AwesomeSpotlight(withRect: CGRect(x: Size.centerWidth - 75, y: 110, width: 150, height: 90),
                                                   shape: .circle,
                                                   text: "\n\nFrog's geographical location",
                                                   isAllowPassTouchesThroughSpotlight: false)
                weather         = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY+8, y: 0, width: Size.width-15, height: 65),
                                                   shape: .roundRectangle,
                                                   text: "Weather conditions at frog's location",
                                                   isAllowPassTouchesThroughSpotlight: false)
                favUnfav        = AwesomeSpotlight(withRect: CGRect(x: Size.width - 70, y: 220, width: 60, height: 60),
                                                   shape: .circle,
                                                   text: "Make favourite or unfavourite a frog",
                                                   isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                break
                
            case 667:
                debugPrint("Spotlight  - 6, 6s, 7, 8")
                mapAnnotation   = AwesomeSpotlight(withRect: CGRect(x: Size.centerWidth - 75, y: 95, width: 150, height: 90),
                                                   shape: .circle,
                                                   text: "\n\nFrog's geographical location",
                                                   isAllowPassTouchesThroughSpotlight: false)
                weather         = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY+8, y: 0, width: Size.width-15, height: 65),
                                                   shape: .roundRectangle,
                                                   text: "Weather conditions at frog's location",
                                                   isAllowPassTouchesThroughSpotlight: false)
                favUnfav        = AwesomeSpotlight(withRect: CGRect(x: Size.width - 70, y: 205, width: 60, height: 60),
                                                   shape: .circle,
                                                   text: "Make favourite or unfavourite a frog",
                                                   isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                break
                
            default:
                showSpotLightNotAvailable()
                break
            }
            
            if properDevice {
                startSpotlight(view: view,
                               spotLight: [mapAnnotation, weather, favUnfav],
                               vc: vc)
            }
            AppStorage.detailsScreenDemoComplete = true
        }
    }
    
    static func showForIdentify(view: UIView, vc: UIViewController) {
        if !AppStorage.identifyScreenDemoComplete {
            let spotLight = AwesomeSpotlightView()
            spotLight.delegate = vc as? AwesomeSpotlightViewDelegate
            
            var camera = AwesomeSpotlight()
            var bottom = AwesomeSpotlight()
            var spotlightMain = AwesomeSpotlight()
            var properDevice = false
            
            switch Size.height {
            case 896.0:
                debugPrint("11 Pro Max, Xs Max, 11, Xr")
                spotlightMain   = AwesomeSpotlight(withRect: CGRect(x: 10, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\n\n\n\nClassification feature can recognise 18 types of frogs using machine learning model",
                                                   isAllowPassTouchesThroughSpotlight: false)
                camera          = AwesomeSpotlight(withRect: CGRect(x: 13, y: 112, width: 390, height: 390),
                                                   shape: .circle,
                                                   text: "Point the camera towards a frog and watch the magic below",
                                                   isAllowPassTouchesThroughSpotlight: false)
                bottom          = AwesomeSpotlight(withRect: CGRect(x: 10, y: 620, width: 395, height: 168),
                                                   shape: .roundRectangle,
                                                   text: "\n\n\nIdentified frog results with their prediction are shown below",
                                                   isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                
                break
                
            case 812.0:
                debugPrint("11 Pro, X, Xs")
                spotlightMain   = AwesomeSpotlight(withRect: CGRect(x: 10, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\n\n\n\nClassification feature can recognise 18 types of frogs using machine learning model",
                                                   isAllowPassTouchesThroughSpotlight: false)
                camera          = AwesomeSpotlight(withRect: CGRect(x: 13, y: 112, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "Point the camera towards a frog and watch the magic below",
                                                   isAllowPassTouchesThroughSpotlight: false)
                bottom          = AwesomeSpotlight(withRect: CGRect(x: 10, y: 220, width: 0, height: 0),
                                                   shape: .roundRectangle,
                                                   text: "\n\n\nIdentified frog results with their prediction are shown below",
                                                   isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                
                break
                
            case 736.0:
                debugPrint("Spotlight - 6+, 6s+, 7+, 8+")
                spotlightMain   = AwesomeSpotlight(withRect: CGRect(x: 10, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\n\n\n\nClassification feature can recognise 18 types of frogs using machine learning model",
                                                   isAllowPassTouchesThroughSpotlight: false)
                camera          = AwesomeSpotlight(withRect: CGRect(x: 13, y: 112, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "Point the camera towards a frog and watch the magic below",
                                                   isAllowPassTouchesThroughSpotlight: false)
                bottom          = AwesomeSpotlight(withRect: CGRect(x: 10, y: 220, width: 0, height: 0),
                                                   shape: .roundRectangle,
                                                   text: "\n\n\nIdentified frog results with their prediction are shown below",
                                                   isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                break
                
            case 667:
                debugPrint("Spotligh - 6, 6s, 7, 8")
                spotlightMain   = AwesomeSpotlight(withRect: CGRect(x: 10, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\nClassification feature can recognise 18 types of frogs using machine learning model",
                                                   isAllowPassTouchesThroughSpotlight: false)
                camera          = AwesomeSpotlight(withRect: CGRect(x: 13, y: 112, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "Point the camera towards a frog and watch the magic below",
                                                   isAllowPassTouchesThroughSpotlight: false)
                bottom          = AwesomeSpotlight(withRect: CGRect(x: 10, y: 220, width: 0, height: 0),
                                                   shape: .roundRectangle,
                                                   text: "\n\n\nIdentified frog results with their prediction are shown below",
                                                   isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                break
                
            default:
                showSpotLightNotAvailable()
                break
            }
            
            if properDevice {
                startSpotlight(view: view,
                               spotLight: [spotlightMain, camera, bottom],
                               vc: vc)
            }
            AppStorage.identifyScreenDemoComplete = true
        }
    }
    
    static func showForChallenges(view: UIView, vc: UIViewController) {
        if !AppStorage.challengeScreenDemoComplete {
            let spotLight = AwesomeSpotlightView()
            spotLight.delegate = vc as? AwesomeSpotlightViewDelegate
            
            var spotlightMain = AwesomeSpotlight()
            var info1 = AwesomeSpotlight()
            var info2 = AwesomeSpotlight()
            var redCard = AwesomeSpotlight()
            var greenCard = AwesomeSpotlight()
            
            var challengeCards = AwesomeSpotlight()
            var progress = AwesomeSpotlight()
            var properDevice = false
            
            switch Size.height {
            case 896.0:
                debugPrint("11 Pro Max, Xs Max, 11, Xr")
                spotlightMain   = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\n\n\n\n\n\nWelcome to challenges",
                                                   isAllowPassTouchesThroughSpotlight: false)
                info1           = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\n\n\n\n\n\n\n\nTo complete the challenges, visit the frog's location in the challenges and sight the frogs in the location",
                                                   isAllowPassTouchesThroughSpotlight: false)
                challengeCards  = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY, y: 145, width: Size.width, height: 450),
                                                   shape: .roundRectangle,
                                                   text: "\nCurrent challenges are shown here",
                                                   isAllowPassTouchesThroughSpotlight: false)
                info2           = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\n\n\n\n\n\n\n\nOnce you sight all the frogs in the challenge, new challenges will be added",
                                                   isAllowPassTouchesThroughSpotlight: false)
                redCard         = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\n\n\n\n\n\n\n\nRed card represents the unsighted frog\n(Yet to complete the challenge)",
                                                   isAllowPassTouchesThroughSpotlight: false)
                greenCard       = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\n\n\n\n\n\n\n\nGreen card represents the sighted frog\n(Completed the challenge)",
                                                   isAllowPassTouchesThroughSpotlight: false)
                progress        = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 16, y: 660, width: 380, height: 140),
                                                   shape: .roundRectangle,
                                                   text: "\n\n\nYour current progress",
                                                   isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                
                break
                
            case 812.0:
                debugPrint("11 Pro, X, Xs")
                spotlightMain   = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\n\n\n\n\n\nWelcome to challenges",
                                                   isAllowPassTouchesThroughSpotlight: false)
                info1           = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\n\n\n\n\n\n\n\nTo complete the challenges, visit the frog's location in the challenges and sight the frogs in the location",
                                                   isAllowPassTouchesThroughSpotlight: false)
                challengeCards  = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY, y: 145, width: Size.width, height: 400),
                                                   shape: .roundRectangle,
                                                   text: "\nCurrent challenges are shown here",
                                                   isAllowPassTouchesThroughSpotlight: false)
                info2           = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\n\n\n\n\n\n\n\nOnce you sight all the frogs in the challenge, new challenges will be added",
                                                   isAllowPassTouchesThroughSpotlight: false)
                redCard         = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\n\n\n\n\n\n\n\nRed card represents the unsighted frog\n(Yet to complete the challenge)",
                                                   isAllowPassTouchesThroughSpotlight: false)
                greenCard       = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\n\n\n\n\n\n\n\nGreen card represents the sighted frog\n(Completed the challenge)",
                                                   isAllowPassTouchesThroughSpotlight: false)
                progress        = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 13, y: 575, width: 350, height: 140),
                                                   shape: .roundRectangle,
                                                   text: "\n\n\nYour current progress is shown below",
                                                   isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                
                break
                
            case 736.0:
                debugPrint("Spotlight  - 6+, 6s+, 7+, 8+")
                spotlightMain   = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\n\n\n\n\n\nWelcome to challenges",
                                                   isAllowPassTouchesThroughSpotlight: false)
                info1           = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\n\n\n\n\n\n\n\nTo complete the challenges, visit the frog's location in the challenges and sight the frogs in the location",
                                                   isAllowPassTouchesThroughSpotlight: false)
                challengeCards  = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY, y: 125, width: Size.width, height: 360),
                                                   shape: .roundRectangle,
                                                   text: "\nCurrent challenges are shown here",
                                                   isAllowPassTouchesThroughSpotlight: false)
                info2           = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\n\n\n\n\n\n\n\nOnce you sight all the frogs in the challenge, new challenges will be added",
                                                   isAllowPassTouchesThroughSpotlight: false)
                redCard         = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\n\n\n\n\n\n\n\nRed card represents the unsighted frog\n(Yet to complete the challenge)",
                                                   isAllowPassTouchesThroughSpotlight: false)
                greenCard       = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\n\n\n\n\n\n\n\nGreen card represents the sighted frog\n(Completed the challenge)",
                                                   isAllowPassTouchesThroughSpotlight: false)
                progress        = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 13, y: 533, width: 390, height: 140),
                                                   shape: .roundRectangle,
                                                   text: "\n\n\nYour current progress is shown below",
                                                   isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                break
                
            case 667:
                debugPrint("Spotlight  - 6, 6s, 7, 8")
                spotlightMain   = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\n\n\n\n\n\nWelcome to challenges",
                                                   isAllowPassTouchesThroughSpotlight: false)
                info1           = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\n\n\n\n\n\n\n\nTo complete the challenges, visit the frog's location in the challenges and sight the frogs in the location",
                                                   isAllowPassTouchesThroughSpotlight: false)
                challengeCards  = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY, y: 125, width: Size.width, height: 330),
                                                   shape: .roundRectangle,
                                                   text: "\nCurrent challenges are shown here",
                                                   isAllowPassTouchesThroughSpotlight: false)
                info2           = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\n\n\n\n\n\n\n\nOnce you sight all the frogs in the challenge, new challenges will be added",
                                                   isAllowPassTouchesThroughSpotlight: false)
                redCard         = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\n\n\n\n\n\n\n\nRed card represents the unsighted frog\n(Yet to complete the challenge)",
                                                   isAllowPassTouchesThroughSpotlight: false)
                greenCard       = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\n\n\n\n\n\n\n\nGreen card represents the sighted frog\n(Completed the challenge)",
                                                   isAllowPassTouchesThroughSpotlight: false)
                progress        = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 13, y: 465, width: 350, height: 140),
                                                   shape: .roundRectangle,
                                                   text: "\n\n\nYour current progress is shown below",
                                                   isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                break
                
            default:
                showSpotLightNotAvailable()
                break
            }
            
            if properDevice {
                startSpotlight(view: view,
                               spotLight: [spotlightMain, info1, challengeCards, info2, redCard, greenCard, progress],
                               vc: vc)
            }
            AppStorage.challengeScreenDemoComplete = true
        }
    }
    
    static func showForMap(view: UIView, vc: UIViewController) {
        if !AppStorage.mapScreenDemoComplete {
            let spotLight = AwesomeSpotlightView()
            spotLight.delegate = vc as? AwesomeSpotlightViewDelegate
            
            var annotationMark = AwesomeSpotlight()
            var zoomToUserLoc = AwesomeSpotlight()
            var spotlightMain = AwesomeSpotlight()
            var properDevice = false
            
            switch Size.height {
            case 896.0:
                debugPrint("11 Pro Max, Xs Max, 11, Xr")
                spotlightMain   = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\n\n\n\n\n\n\n\n\n\n\nAll the frogs locations in Victoria are show here",
                                                   isAllowPassTouchesThroughSpotlight: false)
                annotationMark  = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 90, y: 415, width: 100, height: 100),
                                                   shape: .circle,
                                                   text: "To get more details of the frog, tap on the annotation",
                                                   isAllowPassTouchesThroughSpotlight: false)
                zoomToUserLoc   = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 310, y: 700, width: 80, height: 80),
                                                   shape: .circle,
                                                   text: "Tap on this button to zoom into your location",
                                                   isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                break
                
            case 812.0:
                debugPrint("11 Pro, X, Xs")
                spotlightMain   = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\n\n\n\n\n\n\n\n\n\n\nAll the frogs locations in Victoria are show here",
                                                   isAllowPassTouchesThroughSpotlight: false)
                annotationMark  = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 77, y: 375, width: 100, height: 100),
                                                   shape: .circle,
                                                   text: "To get more details of the frog, tap on the annotation",
                                                   isAllowPassTouchesThroughSpotlight: false)
                zoomToUserLoc   = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 273, y: 620, width: 70, height: 70),
                                                   shape: .circle,
                                                   text: "Tap on this button to zoom into your location",
                                                   isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                break
                
            case 736.0:
                debugPrint("Spotlight - 6+, 6s+, 7+, 8+")
                spotlightMain   = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\n\n\n\n\n\n\n\n\n\n\nAll the frogs locations in Victoria are show here",
                                                   isAllowPassTouchesThroughSpotlight: false)
                annotationMark  = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 90, y: 350, width: 100, height: 100),
                                                   shape: .circle,
                                                   text: "To get more details of the frog, tap on the annotation",
                                                   isAllowPassTouchesThroughSpotlight: false)
                zoomToUserLoc   = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 313, y: 580, width: 70, height: 70),
                                                   shape: .circle,
                                                   text: "Tap on this button to zoom into your location",
                                                   isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                break
                
            case 667:
                debugPrint("Spotlight - 6, 6s, 7, 8")
                spotlightMain   = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "\n\n\n\n\n\n\n\n\n\n\n\n\n\nAll the frogs locations in Victoria are show here",
                                                   isAllowPassTouchesThroughSpotlight: false)
                annotationMark  = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 75, y: 310, width: 100, height: 100),
                                                   shape: .circle,
                                                   text: "To get more details of the frog, tap on the annotation",
                                                   isAllowPassTouchesThroughSpotlight: false)
                zoomToUserLoc   = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 275, y: 510, width: 70, height: 70),
                                                   shape: .circle,
                                                   text: "Tap on this button to zoom into your location",
                                                   isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                break
                
            default:
                showSpotLightNotAvailable()
                break
            }
            if properDevice {
                startSpotlight(view: view,
                               spotLight: [spotlightMain, annotationMark, zoomToUserLoc],
                               vc: vc)
            }
            AppStorage.mapScreenDemoComplete = true
        }
    }
    
    static func showForNews(view: UIView, vc: UIViewController) {
        if !AppStorage.newsScreenDemoComplete {
            let spotLight = AwesomeSpotlightView()
            spotLight.delegate = vc as? AwesomeSpotlightViewDelegate
            
            var pullToRefresh = AwesomeSpotlight()
            var tapOnArticle = AwesomeSpotlight()
            var spotlightMain = AwesomeSpotlight()
            var properDevice = false
            
            switch Size.height {
            case 896.0:
                debugPrint("11 Pro Max, Xs Max, 11, Xr")
                spotlightMain = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 200, width: 0, height: 0),
                                                 shape: .circle,
                                                 text: "News articles are being fetched and filtered to news related to frogs from different sources",
                                                 isAllowPassTouchesThroughSpotlight: false)
                pullToRefresh = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 90, y: 300, width: 0, height: 0),
                                                 shape: .circle,
                                                 text: "Pull down to refresh the news",
                                                 isAllowPassTouchesThroughSpotlight: false)
                tapOnArticle  = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 310, y: 400, width: 0, height: 0),
                                                 shape: .circle,
                                                 text: "Tap on an article to know more details",
                                                 isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                
                break
                
            case 812.0:
                debugPrint("11 Pro, X, Xs")
                spotlightMain = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 200, width: 0, height: 0),
                                                 shape: .circle,
                                                 text: "News articles are being fetched and filtered to news related to frogs from different sources",
                                                 isAllowPassTouchesThroughSpotlight: false)
                pullToRefresh = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 90, y: 300, width: 0, height: 0),
                                                 shape: .circle,
                                                 text: "Pull down to refresh the news",
                                                 isAllowPassTouchesThroughSpotlight: false)
                tapOnArticle  = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 310, y: 400, width: 0, height: 0),
                                                 shape: .circle,
                                                 text: "Tap on an article to know more details",
                                                 isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                
                break
                
            case 736.0:
                debugPrint("Spotlight  - 6+, 6s+, 7+, 8+")
                spotlightMain = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 100, width: 0, height: 0),
                                                 shape: .circle,
                                                 text: "News articles are being fetched and filtered to news related to frogs from different sources",
                                                 isAllowPassTouchesThroughSpotlight: false)
                pullToRefresh = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 90, y: 200, width: 0, height: 0),
                                                 shape: .circle,
                                                 text: "Pull down to refresh the news",
                                                 isAllowPassTouchesThroughSpotlight: false)
                tapOnArticle  = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 310, y: 300, width: 0, height: 0),
                                                 shape: .circle,
                                                 text: "Tap on an article to know more details",
                                                 isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                break
                
            case 667:
                debugPrint("Spotlight  - 6, 6s, 7, 8")
                spotlightMain   = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 50, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "News articles are being fetched and filtered to news related to frogs from different sources",
                                                   isAllowPassTouchesThroughSpotlight: false)
                pullToRefresh   = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 90, y: 100, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "Pull down to refresh the news",
                                                   isAllowPassTouchesThroughSpotlight: false)
                tapOnArticle    = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 310, y: 150, width: 0, height: 0),
                                                   shape: .circle,
                                                   text: "Tap on an article to know more details",
                                                   isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                break
                
            default:
                showSpotLightNotAvailable()
                break
            }
            if properDevice {
                startSpotlight(view: view,
                               spotLight: [spotlightMain, pullToRefresh, tapOnArticle],
                               vc: vc)
            }
        }
        AppStorage.newsScreenDemoComplete = true
    }
}
