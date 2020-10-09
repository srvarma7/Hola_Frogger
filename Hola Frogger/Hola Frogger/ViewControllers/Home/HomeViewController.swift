//
//  HomeViewController.swift
//  TabView
//
//  Created by Varma on 07/05/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
import iOSDropDown
import Lottie
import AwesomeSpotlightView
import AudioToolbox

class HomeViewController: UIViewController, AwesomeSpotlightViewDelegate {
    
    var frogNamesForSearch: [String] = []
    var selectedFrog: String = ""
    let magnitude = -20
    let animationView = AnimationView(name: "catchmeifyoucan")
    let wavesAnimationView = AnimationView(name: "greenwaves")
    
    var isLoadingFirstTime: Bool = false
    var spotlight: [SpotLightEntity] = []
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    // set frame
    let  searchField = DropDown(frame: CGRect(x: 10, y: 0, width: 350, height: 50))
    var spotlightView = AwesomeSpotlightView()
 
    @IBOutlet weak var exploreBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFrogsToSearchBar()
        lottieAnimation()
        initializeSearch()
        checkForSpotLight()
        applyParallaxEffect()
        AudioServicesPlaySystemSound(1520)
        searchField.textAlignment = .center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpSearchBarAndExploreButton()
        searchBarAnimation()
        animationView.play()
        wavesAnimationView.play()
    }
    
    // Check if the application is opening for the first time
    func checkForSpotLight() {
        if spotlight.isEmpty {
            CoreDataHandler.addSpotLight()
            spotlight = CoreDataHandler.fetchSpotLight()
        }
        if !(spotlight.first!.home) {
            startSpotLightTour()
        }
    }
    
    // Add the frogs names to the suggestings list
    fileprivate func addFrogsToSearchBar() {
        
        var frogs: [FrogEntity] = []
        frogs = CoreDataHandler.fetchAllFrogs()
        
        // If the appliation is opened, Add records to database
        if(frogs.count == 0) {
            CoreDataHandler.addAllRecords()
            frogs = CoreDataHandler.fetchAllFrogs()
        }
        
        if frogNamesForSearch.count == 0 {
            for ele in frogs {
                frogNamesForSearch.append(ele.cname!)
            }
        }
        
    }
    
    // Setup search bar and add constraints
    func initializeSearch() {
        searchField.backgroundColor = #colorLiteral(red: 0.7719962001, green: 0.1048256829, blue: 0.2892795205, alpha: 1)
        searchField.listHeight = 150
        searchField.rowHeight = 50
        searchField.placeholder = "  Search here....."
        self.view.addSubview(searchField)
        _ = searchField.anchor(animationView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 270, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 350, heightConstant: 50)
    }
    
    func applyParallaxEffect() {
        applyMotionEffect(toView: searchField, magnitude: Float(magnitude))
        applyMotionEffect(toView: exploreBtn, magnitude: Float(-magnitude))
    }
    
    fileprivate func setUpSearchBarAndExploreButton() {
        
        searchField.optionArray = frogNamesForSearch
        searchField.rowBackgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        searchField.selectedRowColor = #colorLiteral(red: 0.7719962001, green: 0.1048256829, blue: 0.2892795205, alpha: 1)
        searchField.didSelect { (selectedText , index ,id) in
            self.selectedFrog = selectedText
            print(selectedText, "SELECTED TEXT")
            self.showDetails(frogname: selectedText)
        }
        
        exploreBtn.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        exploreBtn.layer.shadowOpacity = 0.8
        searchField.clipsToBounds = true
        searchField.textColor = .white
        searchField.arrowColor = .white
        searchField.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        searchField.layer.shadowOpacity = 0.8
        searchField.tintColor = .white        

    }
    
    

    // Dismiss Keyboard when tapped on View
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // When tapped on a perticular frog, go to details screen.
    func showDetails(frogname: String) {
        let singleFrog = CoreDataHandler.fetchSpecificFrog(frogname: frogname)
        print(singleFrog.sname!)
        if let viewController = storyboard?.instantiateViewController(identifier: "frogDetails") as? FrogDetailsViewController {
            viewController.receivedFrog = singleFrog
            navigationController?.present(viewController, animated: true)
        }
    }
    
}

extension HomeViewController {
    
    // Setup lottie animation and add constraints
    func lottieAnimation() {
        animationView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        animationView.center.x = self.view.center.x
        animationView.contentMode = .scaleAspectFit
        view.addSubview(animationView)
        animationView.loopMode = .loop
        _ = animationView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 150, heightConstant: 150)
        wavesAnimationView.frame = CGRect(x: 0, y: 0, width: 510, height: 510)
        wavesAnimationView.center.x = self.view.center.x
        wavesAnimationView.contentMode = .scaleAspectFit
        view.addSubview(wavesAnimationView)
        wavesAnimationView.loopMode = .loop
        
        if screenSize.width == 375.0 {
            _ = wavesAnimationView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: -50, rightConstant: 0, widthConstant: 510, heightConstant: 510)
        } else if screenSize.width == 414.0 {
            _ = wavesAnimationView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: -20, rightConstant: 0, widthConstant: 525, heightConstant: 525)
        }
        
        view.bringSubviewToFront(exploreBtn)
    }
    
    // If the application is opened for the first time, provide tutorial to the user using spot light.
    func startSpotLightTour() {
        var spotlightMain = AwesomeSpotlight()
        var spotlight1 = AwesomeSpotlight()
        var spotlight2 = AwesomeSpotlight()
        var properDevice = false
        //print(screenSize.width)
        
        if screenSize.width == 414.0 { // If iPhone XS Max
            // Welcome note
            spotlightMain = AwesomeSpotlight(withRect: CGRect(x: 10, y: 77, width: 220, height: 75), shape: .circle, text: "\n\nWelcome\n\n\n\n\n\n\nTap anywhere on the grey area to continue", isAllowPassTouchesThroughSpotlight: false)
            
            spotlight1 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 15, y: 335, width: 385, height: 60), shape: .roundRectangle, text: "You can search for a specifc frog here", isAllowPassTouchesThroughSpotlight: false)
            // Spotlight for Frog's Common Name
            spotlight2 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 33, y: 665, width: 350, height: 100), shape: .roundRectangle, text: "\n\n\nYou can explore all frogs here", isAllowPassTouchesThroughSpotlight: false)
            properDevice = true
        } else if screenSize.width == 375.0 { // If iPhone XS
            spotlightMain = AwesomeSpotlight(withRect: CGRect(x: 7, y: 77, width: 220, height: 75), shape: .circle, text: "\n\nWelcome\n\n\n\n\n\n\nTap anywhere on the grey area to continue", isAllowPassTouchesThroughSpotlight: false)
            spotlight1 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 15, y: 335, width: 345, height: 60), shape: .roundRectangle, text: "You can search for a specifc frog here", isAllowPassTouchesThroughSpotlight: false)
            spotlight2 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 33, y: 603, width: 310, height: 80), shape: .roundRectangle, text: "\n\n\nTap here to explore all frogs", isAllowPassTouchesThroughSpotlight: false)
            properDevice = true
        }
        
        if properDevice {
            // Load spotlights
            let spotlightView = AwesomeSpotlightView(frame: view.frame, spotlight: [spotlightMain, spotlight1, spotlight2])
            spotlightView.cutoutRadius = 8
            spotlightView.delegate = self
            view.addSubview(spotlightView)
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                if self.traitCollection.userInterfaceStyle == .light {
                    spotlightView.spotlightMaskColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
                } else {
                    spotlightView.spotlightMaskColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
                }
                spotlightView.enableArrowDown = true
                spotlightView.start()
            }
            CoreDataHandler.updateSpotLight(attribute: "home", boolean: true)
        }
    }
    
    // Slides in top when application is loaded for the first time
    fileprivate func searchBarAnimation() {
        if !isLoadingFirstTime {
            UIView.animate(withDuration: 1, animations: {
                self.searchField.center = self.view.center
                self.searchField.transform = CGAffineTransform(translationX: 0, y: -100)
                self.exploreBtn.layer.cornerRadius = self.exploreBtn.frame.size.width/10
                self.animationView.transform = CGAffineTransform(translationX: 0, y: 160)
                self.animationView.layer.cornerRadius = self.animationView.frame.size.width/10
                self.animationView.clipsToBounds = true
            })
            isLoadingFirstTime = true
        }
        UIView.animate(withDuration: 1, animations: {
            self.searchField.layer.cornerRadius = self.searchField.frame.size.width/20
        })
    }
    
    // Parallax effect for SearchBar
    func applyMotionEffect (toView view: DropDown, magnitude: Float) {
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        
        view.addMotionEffect(group)
    }
    
    // Parallax effect for Button
    func applyMotionEffect (toView view: UIButton, magnitude: Float) {
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        
        view.addMotionEffect(group)
    }
    
    // Parallax effect for Image
    func applyMotionEffect (toView view: UIImageView, magnitude:Float) {
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        
        view.addMotionEffect(group)
    }
}
