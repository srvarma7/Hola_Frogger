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
    
    private static var isTesting = true
    
    private static func startSpotlight(view: UIView, spotLight: [AwesomeSpotlight], vc: UIViewController) {
        // Load spotlights
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
                                                   shape: .roundRectangle, text: "You can search for a specifc frog here",
                                                   isAllowPassTouchesThroughSpotlight: false)
                
                exploreAllLight = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 33, y: 665, width: 350, height: 110),
                                                   shape: .roundRectangle, text: "\n\n\nYou can explore all frogs here",
                                                   isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                break
                
            case 812.0:
                debugPrint(("11 Pro, X, XS"))
                spotlightMain   = AwesomeSpotlight(withRect: CGRect(x: 7, y: 77, width: 220, height: 75),
                                                   shape: .circle,
                                                   text: "\n\nWelcome\n\n\n\n\n\n\nTap anywhere on the grey area to continue",
                                                   isAllowPassTouchesThroughSpotlight: false)
                
                searchLight     = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 15, y: 335, width: 345, height: 60),
                                                   shape: .roundRectangle, text: "You can search for a specifc frog here",
                                                   isAllowPassTouchesThroughSpotlight: false)
                
                exploreAllLight = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 33, y: 603, width: 310, height: 80),
                                                   shape: .roundRectangle, text: "\n\n\nTap here to explore all frogs",
                                                   isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                break
                
            case 736.0:
                #warning("Spotlight not complete - 6+, 6s+, 7+, 8+")
                
                break
                
            case 667:
                #warning("Spotlight not complete - 6, 6s, 7, 8")
                
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
                // Spotlight for Image
                image = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 10, y: 97, width: 80, height: 80), shape: .circle, text: "\nFrog's image", isAllowPassTouchesThroughSpotlight: false)
                commonName = AwesomeSpotlight(withRect: CGRect(x: 90, y: 108, width: 160, height: 30), shape: .roundRectangle, text: "Frog's common name", isAllowPassTouchesThroughSpotlight: false)
                scientificName = AwesomeSpotlight(withRect: CGRect(x: 90, y: 140, width: 185, height: 25), shape: .roundRectangle, text: "Frog's scientific name", isAllowPassTouchesThroughSpotlight: false)
                status = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 368, y: 117, width: 40, height: 40), shape: .circle, text: "Frog's threatened status\n\nE-Endangered\nV-Vulnerable\nN-Not Endangered", isAllowPassTouchesThroughSpotlight: false)
                favourite = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 340, y: 25, width: 80, height: 80), shape: .circle, text: "Filter by favourite", isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                
                break
                
            case 812.0:
                debugPrint("11 Pro, X, Xs")
                // Spotlight for Image
                image = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 13, y: 160, width: 60, height: 60), shape: .circle, text: "\nFrog's image", isAllowPassTouchesThroughSpotlight: false)
                // Spotlight for Frog's Common Name
                commonName = AwesomeSpotlight(withRect: CGRect(x: 80, y: 163, width: 130, height: 25), shape: .roundRectangle, text: "Frog's common name", isAllowPassTouchesThroughSpotlight: false)
                // Spotlight for Frog's Scentific Name
                scientificName = AwesomeSpotlight(withRect: CGRect(x: 80, y: 196, width: 175, height: 25), shape: .roundRectangle, text: "Frog's scientific name", isAllowPassTouchesThroughSpotlight: false)
                // Spotlight for Status
                status = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 323, y: 170, width: 40, height: 40), shape: .circle, text: "Frog's threatened status\n\nE-Endangered\nV-Vulnerable\nN-Not Endangered", isAllowPassTouchesThroughSpotlight: false)
                // Spotlight for Filter by Favourite
                favourite = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 325, y: 40, width: 50, height: 50), shape: .circle, text: "Filter by favourite", isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                
                break
                
            case 736.0:
                #warning("Spotlight not complete - 6+, 6s+, 7+, 8+")
                
                break
                
            case 667:
                #warning("Spotlight not complete - 6, 6s, 7, 8")
                
                break
                
            default:
                debugPrint("Unknown screen size")
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
            var spotlight2 = AwesomeSpotlight()
            var spotlight5 = AwesomeSpotlight()
            
            var properDevice = false
            
            
            switch Size.height {
            case 896.0:
                debugPrint("11 Pro Max, Xs Max, 11, Xr")
                // Spotlight for Image
                mapAnnotation = AwesomeSpotlight(withRect: CGRect(x: Size.centerWidth - 75, y: 130, width: 150, height: 90), shape: .circle, text: "\n\nFrog's geographical location", isAllowPassTouchesThroughSpotlight: false)
                
                // Spotlight for Frog's Common Name
                spotlight2 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY+8, y: 0, width: 400, height: 65), shape: .roundRectangle, text: "Weather conditions at frog's location", isAllowPassTouchesThroughSpotlight: false)
                
                // Spotlight for Filter by Favourite
                spotlight5 = AwesomeSpotlight(withRect: CGRect(x: Size.width - 70, y: 260, width: 60, height: 60), shape: .circle, text: "Make favourite or unfavourite", isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                
                break
                
            case 812.0:
                debugPrint("11 Pro, X, Xs")
                // Spotlight for Image
                mapAnnotation = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 140, y: 115, width: 90, height: 90), shape: .circle, text: "\n\nFrog's geographical location", isAllowPassTouchesThroughSpotlight: false)
                
                // Spotlight for Frog's Common Name
                spotlight2 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY+8, y: 5, width: 360, height: 75), shape: .roundRectangle, text: "Weather conditions at frog's location", isAllowPassTouchesThroughSpotlight: false)
                
                // Spotlight for Favourite
                spotlight5 = AwesomeSpotlight(withRect: CGRect(x: view.center.x + 120, y: view.center.y - 30, width: 60, height: 60), shape: .circle, text: "Make favourite or unfavourite", isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                
                break
                
            case 736.0:
                #warning("Spotlight not complete - 6+, 6s+, 7+, 8+")
                
                break
                
            case 667:
                #warning("Spotlight not complete - 6, 6s, 7, 8")
                
                break
                
            default:
                debugPrint("Unknown screen size")
                break
            }
            
            if properDevice {
                startSpotlight(view: view,
                               spotLight: [mapAnnotation, spotlight2, spotlight5],
                               vc: vc)
            }
            AppStorage.detailsScreenDemoComplete = true
        }
    }
    
    static func showForIdentify(view: UIView, vc: UIViewController) {
        if !AppStorage.identifyScreenDemoComplete {
            let spotLight = AwesomeSpotlightView()
            spotLight.delegate = vc as? AwesomeSpotlightViewDelegate
            
            var spotlight1 = AwesomeSpotlight()
            var spotlight2 = AwesomeSpotlight()
            var spotlightMain = AwesomeSpotlight()
            var properDevice = false
            
            switch Size.height {
            case 896.0:
                debugPrint("11 Pro Max, Xs Max, 11, Xr")
                spotlightMain = AwesomeSpotlight(withRect: CGRect(x: 10, y: 77, width: 0, height: 0),
                                                 shape: .circle,
                                                 text: "\n\n\n\n\n\n\nOur classification feature can recognise 18 types of frog from Victoria using our own ML model",
                                                 isAllowPassTouchesThroughSpotlight: false)
                spotlight1 = AwesomeSpotlight(withRect: CGRect(x: 13, y: 112, width: 390, height: 390),
                                              shape: .circle,
                                              text: "Point the camera to a frog in the view here and watch the magic below",
                                              isAllowPassTouchesThroughSpotlight: false)
                // Spotlight for Frog's Common Name
                spotlight2 = AwesomeSpotlight(withRect: CGRect(x: 10, y: 620, width: 395, height: 168),
                                              shape: .roundRectangle,
                                              text: "\n\n\nIdentified frogs results with their prediction are shown here",
                                              isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                
                break
                
            case 812.0:
                debugPrint("11 Pro, X, Xs")
                spotlightMain = AwesomeSpotlight(withRect: CGRect(x: 10, y: 77, width: 0, height: 0),
                                                 shape: .circle,
                                                 text: "\n\n\n\n\n\n\nOur classification feature can recognise 18 types of frog from Victoria using our own ML model",
                                                 isAllowPassTouchesThroughSpotlight: false)
                spotlight1 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 23, y: 153, width: 330, height: 330),
                                              shape: .circle, text: "Point the camera to a frog in the view here and watch the magic below", isAllowPassTouchesThroughSpotlight: false)
                // Spotlight for Frog's Common Name
                spotlight2 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 33, y: 547, width: 310, height: 150), shape: .roundRectangle, text: "\n\n\nIdentified frogs results with their prediction are shown here", isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                
                break
                
            case 736.0:
                #warning("Spotlight not complete - 6+, 6s+, 7+, 8+")
                
                break
                
            case 667:
                #warning("Spotlight not complete - 6, 6s, 7, 8")
                
                break
                
            default:
                debugPrint("Unknown screen size")
                break
            }
            
            if properDevice {
                startSpotlight(view: view,
                               spotLight: [spotlightMain, spotlight1, spotlight2],
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
            var spotlightMain2 = AwesomeSpotlight()
            var spotlightMain3 = AwesomeSpotlight()
            var spotlightMain4 = AwesomeSpotlight()
            var spotlightMain5 = AwesomeSpotlight()
            
            var spotlight1 = AwesomeSpotlight()
            var spotlight2 = AwesomeSpotlight()
            var properDevice = false
            
            switch Size.height {
            case 896.0:
                debugPrint("11 Pro Max, Xs Max, 11, Xr")
                spotlightMain = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\n\n\nWelcome to the challenges", isAllowPassTouchesThroughSpotlight: false)
                spotlightMain2 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\n\n\n\n\nTo complete the challenges, visit the frog's location in the challenges and sight the frogs in the location", isAllowPassTouchesThroughSpotlight: false)
                spotlight1 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY, y: 145, width: Size.width, height: 450), shape: .roundRectangle, text: "\nCurrent challenges are shown here", isAllowPassTouchesThroughSpotlight: false)
                spotlightMain3 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\n\n\n\n\nOnce you sight all the frogs in the challenge, new challenges will be added", isAllowPassTouchesThroughSpotlight: false)
                spotlightMain4 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\n\n\n\n\nRed card represents the unsighted frog\n(Yet to complete the challenge)", isAllowPassTouchesThroughSpotlight: false)
                spotlightMain5 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\n\n\n\n\nGreen card represents the sighted frog\n(Completed the challenge)", isAllowPassTouchesThroughSpotlight: false)
                spotlight2 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 16, y: 660, width: 380, height: 140), shape: .roundRectangle, text: "\n\n\nYour current progress", isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                
                break
                
            case 812.0:
                debugPrint("11 Pro, X, Xs")
                spotlightMain = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\n\n\nWelcome to the challenges", isAllowPassTouchesThroughSpotlight: false)
                spotlightMain2 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\n\n\n\n\nTo complete the challenges, visit the frog's location in the challenges and sight the frogs in the location", isAllowPassTouchesThroughSpotlight: false)
                spotlight1 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 13, y: 140, width: 350, height: 370), shape: .roundRectangle, text: "\nCurrent challenges are shown here", isAllowPassTouchesThroughSpotlight: false)
                spotlightMain3 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\n\n\n\n\nOnce you sight all the frogs in the challenge, new challenges will be added", isAllowPassTouchesThroughSpotlight: false)
                spotlightMain4 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\n\n\n\n\nRed card represents the unsighted frog\n(Yet to complete the challenge)", isAllowPassTouchesThroughSpotlight: false)
                spotlightMain5 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\n\n\n\n\nGreen card represents the sighted frog\n(Completed the challenge)", isAllowPassTouchesThroughSpotlight: false)
                spotlight2 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 10, y: 555, width: 350, height: 140), shape: .roundRectangle, text: "\n\n\nYour current progress", isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                
                break
                
            case 736.0:
                #warning("Spotlight not complete - 6+, 6s+, 7+, 8+")
                
                break
                
            case 667:
                #warning("Spotlight not complete - 6, 6s, 7, 8")
                
                break
                
            default:
                debugPrint("Unknown screen size")
                break
            }
            
            if properDevice {
                startSpotlight(view: view,
                               spotLight: [spotlightMain, spotlightMain2, spotlight1, spotlightMain3, spotlightMain4, spotlightMain5, spotlight2],
                               vc: vc)
            }
            AppStorage.challengeScreenDemoComplete = true
        }
    }
    
    static func showForMap(view: UIView, vc: UIViewController) {
        if !AppStorage.mapScreenDemoComplete {
            let spotLight = AwesomeSpotlightView()
            spotLight.delegate = vc as? AwesomeSpotlightViewDelegate
            
            var spotlight1 = AwesomeSpotlight()
            var spotlight2 = AwesomeSpotlight()
            var spotlightMain = AwesomeSpotlight()
            var properDevice = false
            
            switch Size.height {
            case 896.0:
                debugPrint("11 Pro Max, Xs Max, 11, Xr")
                spotlightMain = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\n\n\n\n\n\n\n\nAll the frogs locations in Victoria are show here", isAllowPassTouchesThroughSpotlight: false)
                spotlight1 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 90, y: 415, width: 100, height: 100), shape: .circle, text: "To get more details of the frog, tap on the annotation", isAllowPassTouchesThroughSpotlight: false)
                // Spotlight for Frog's Common Name
                spotlight2 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 310, y: 700, width: 80, height: 80), shape: .circle, text: "Tap on this button to zoom into your location", isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                
                break
                
            case 812.0:
                debugPrint("11 Pro, X, Xs")
                spotlightMain = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\n\n\n\n\n\n\n\nAll the frogs locations in Victoria are show here", isAllowPassTouchesThroughSpotlight: false)
                spotlight1 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 77, y: 330, width: 100, height: 100), shape: .circle, text: "To get more details of the frog, tap on the annotation", isAllowPassTouchesThroughSpotlight: false)
                // Spotlight for Frog's Common Name
                spotlight2 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 303, y: 650, width: 50, height: 50), shape: .circle, text: "Tap on this button to zoom into your location", isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                
                break
                
            case 736.0:
                #warning("Spotlight not complete - 6+, 6s+, 7+, 8+")
                
                break
                
            case 667:
                #warning("Spotlight not complete - 6, 6s, 7, 8")
                
                break
                
            default:
                debugPrint("Unknown screen size")
                break
            }
            if properDevice {
                startSpotlight(view: view,
                               spotLight: [spotlightMain, spotlight1, spotlight2],
                               vc: vc)
            }
            AppStorage.mapScreenDemoComplete = true
        }
        
    }
    
    static func showForNews(view: UIView, vc: UIViewController) {
        if !AppStorage.newsScreenDemoComplete {
            let spotLight = AwesomeSpotlightView()
            spotLight.delegate = vc as? AwesomeSpotlightViewDelegate
            
            var spotlight1 = AwesomeSpotlight()
            var spotlight2 = AwesomeSpotlight()
            var spotlightMain = AwesomeSpotlight()
            var properDevice = false
            
            switch Size.height {
            case 896.0:
                debugPrint("11 Pro Max, Xs Max, 11, Xr")
                spotlightMain = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 200, width: 0, height: 0), shape: .circle, text: "News articles are being fetched and filtered to news related to frogs from different sources", isAllowPassTouchesThroughSpotlight: false)
                spotlight1 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 90, y: 300, width: 0, height: 0), shape: .circle, text: "Pull down to refresh the news", isAllowPassTouchesThroughSpotlight: false)
                // Spotlight for Frog's Common Name
                spotlight2 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 310, y: 400, width: 0, height: 0), shape: .circle, text: "Tap on an article to know more details", isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                
                break
                
            case 812.0:
                debugPrint("11 Pro, X, Xs")
                spotlightMain = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 200, width: 0, height: 0), shape: .circle, text: "News articles are being fetched and filtered to news related to frogs from different sources", isAllowPassTouchesThroughSpotlight: false)
                spotlight1 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 90, y: 300, width: 0, height: 0), shape: .circle, text: "Pull down to refresh the news", isAllowPassTouchesThroughSpotlight: false)
                // Spotlight for Frog's Common Name
                spotlight2 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 310, y: 400, width: 0, height: 0), shape: .circle, text: "Tap on an article to know more details", isAllowPassTouchesThroughSpotlight: false)
                properDevice = true
                
                break
                
            case 736.0:
                #warning("Spotlight not complete - 6+, 6s+, 7+, 8+")
                
                break
                
            case 667:
                #warning("Spotlight not complete - 6, 6s, 7, 8")
                
                break
                
            default:
                debugPrint("Unknown screen size")
                break
            }
            if properDevice {
                startSpotlight(view: view,
                               spotLight: [spotlightMain, spotlight1, spotlight2],
                               vc: vc)
            }
        }
        AppStorage.newsScreenDemoComplete = true
    }
}
