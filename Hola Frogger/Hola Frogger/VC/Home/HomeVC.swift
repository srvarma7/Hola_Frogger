//
//  HomeVC.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 12/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
import Lottie
import iOSDropDown
import AudioToolbox

class HomeVC: UIViewController {
    
    // UI Elements
    let holaFroggerLabel    = UILabel()
    let frogAnimationView   = AnimationView(name: "catchmeifyoucan")
    let searchFieldView     = DropDown(frame: CGRect(x: 0, y: 0, width: 350, height: 50))
    let wavesAnimationView  = AnimationView(name: "greenwaves")
    let exploreFrogsButton  = UIButton()
    
    // Variables
    var frogsList: [FrogEntity] = []
    var frogCommonNamesInSearchBar      = [String]()
    var selectedFrog: String    = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        UINavigationBar.appearance().tintColor = .raspberryPieTint()
        fetchFrogsFromDatabase()
        setupViews()
        AudioServicesPlaySystemSound(1520)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        // Resuming lottie animation when screen is appearing
        frogAnimationView.play()
        wavesAnimationView.play()
        SpotLight.showForHomeScreen(view: view, vc: self)
//        fatalError()
//        AudioService().playSound()
        
//        LocalStorage().homeScreenDemoComplete = false
//        if !LocalStorage().homeScreenDemoComplete {
//
//            LocalStorage().homeScreenDemoComplete = true
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)

        // Stopping lottie animation when screen is appearing
        frogAnimationView.stop()
        wavesAnimationView.stop()
    }
    
    // Dismiss Keyboard when tapped on View
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func fetchFrogsFromDatabase() {
        frogsList = CoreDataHandler.fetchAllFrogs()
        if frogsList.count == 0 {
            CoreDataHandler.addAllFrogRecordsToDatabase()
            frogsList = CoreDataHandler.fetchAllFrogs()
        }
    }
}

// Action methods
extension HomeVC {
    // Opening VC when selected a frog in SearchBar
    private func presentFrogDetailsVCAtIndex(index: Int) {
        let selectedFrogItem: FrogEntity = self.frogsList[index]
        let frogDetailsVC = FrogDetailsVC()
        frogDetailsVC.frogItem = selectedFrogItem
        self.present(frogDetailsVC, animated: true, completion: nil)
    }
    
    @objc func exploreFrogsButtonDidTapped() {
        let frogsListVC = FrogsListVC()
        frogsListVC.title = "Explore"
        navigationController?.pushViewController(frogsListVC, animated: true)
    }
}

// Layout constriants
extension HomeVC {
    
    private func setupViews() {
        setupHolaFroggerLabel()
        setupAnimationView()
        setupSearchView()
        setupWavesView()
        setupExploreFrogsButton()
        
        addConstriants()
    }
    
    private func addConstriants() {
        let safeAreaView = self.view.safeAreaLayoutGuide
        
        holaFroggerLabel.addAnchor(top: safeAreaView.topAnchor, paddingTop: 10,
                                   left: safeAreaView.leftAnchor, paddingLeft: 0,
                                   bottom: nil, paddingBottom: 0,
                                   right: safeAreaView.rightAnchor, paddingRight: 0,
                                   width: 0, height: 0, enableInsets: true)
        
        frogAnimationView.addAnchor(top: holaFroggerLabel.bottomAnchor, paddingTop: 5,
                                    left: safeAreaView.leftAnchor, paddingLeft: 50,
                                    bottom: nil, paddingBottom: 0,
                                    right: safeAreaView.rightAnchor, paddingRight: 50,
                                    width: 0, height: 200, enableInsets: true)
        
        searchFieldView.addAnchor(top: frogAnimationView.bottomAnchor, paddingTop: 5,
                                  left: safeAreaView.leftAnchor, paddingLeft: 20,
                                  bottom: nil, paddingBottom: 0,
                                  right: safeAreaView.rightAnchor, paddingRight: 20,
                                  width: 0, height: 50,
                                  enableInsets: true)
        
        wavesAnimationView.addAnchor(top: nil, paddingTop: 0,
                                     left: view.leftAnchor, paddingLeft: 0,
                                     bottom: view.bottomAnchor, paddingBottom: 0,
                                     right: view.rightAnchor, paddingRight: 0,
                                     width: 0, height: UIScreen.main.bounds.height/2,
                                     enableInsets: true)
        
        exploreFrogsButton.addAnchor(top: nil, paddingTop: 0,
                                     left: safeAreaView.leftAnchor, paddingLeft: 20,
                                     bottom: safeAreaView.bottomAnchor, paddingBottom: 75,
                                     right: safeAreaView.rightAnchor, paddingRight: 20,
                                     width: 0, height: 30,
                                     enableInsets: true)
        
        view.sendSubviewToBack(wavesAnimationView)
    }
}

// MARK: - Views configurations
extension HomeVC {
    private func setupHolaFroggerLabel() {
        view.addSubview(holaFroggerLabel)
        
        holaFroggerLabel.text           = "Hola Frogger"
        holaFroggerLabel.font           = UIFont.systemFont(ofSize: 30, weight: .heavy)
        holaFroggerLabel.textColor      = .black
        holaFroggerLabel.textAlignment  = .center
    }
    
    private func setupAnimationView() {
        view.addSubview(frogAnimationView)
        
        frogAnimationView.contentMode   = .scaleAspectFit
        frogAnimationView.loopMode      = .loop
        
        view.backgroundColor = .lottieTint()
    }
    
    private func setupSearchView() {
        self.view.addSubview(searchFieldView)

        searchFieldView.clipsToBounds = true

        searchFieldView.textAlignment   = .center
        searchFieldView.textColor       = .white
        searchFieldView.arrowColor      = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.865047089)

        searchFieldView.backgroundColor = .raspberryPieTint()
        
        searchFieldView.listHeight  = 150
        searchFieldView.rowHeight   = 50
        
        searchFieldView.placeholder = "Search frogs here"
        
        searchFieldView.layer.shadowOffset  = CGSize(width: 2.0, height: 2.0)
        searchFieldView.layer.shadowOpacity = 0.8
        searchFieldView.tintColor           = .white
        searchFieldView.layer.cornerRadius  = 20
        searchFieldView.checkMarkEnabled    = false
        
        // Add frog common names to searchbar
        addFrogNamesToSearchBar()
        searchFieldView.optionArray         = frogCommonNamesInSearchBar
        searchFieldView.rowBackgroundColor  = .raspberryPieTint()
        searchFieldView.selectedRowColor    = #colorLiteral(red: 0.7719962001, green: 0.1048256829, blue: 0.2892795205, alpha: 1)
        
        searchFieldView.didSelect { (selectedText, index, id) in
            self.presentFrogDetailsVCAtIndex(index: index)
        }
    }
    
    fileprivate func addFrogNamesToSearchBar() {
        if frogCommonNamesInSearchBar.count == 0 {
            for ele in frogsList {
                frogCommonNamesInSearchBar.append(ele.cname!)
            }
        }
    }
    
    private func setupWavesView() {
        view.addSubview(wavesAnimationView)
        
        wavesAnimationView.contentMode = .scaleToFill
        wavesAnimationView.loopMode = .loop
    }
    
    private func setupExploreFrogsButton() {
        exploreFrogsButton.backgroundColor = .wavesTint()
        exploreFrogsButton.setTitle("Explore all frogs", for: .normal)
        exploreFrogsButton.titleLabel?.font  = .boldSystemFont(ofSize: 26)
        exploreFrogsButton.setTitleColor(.white, for: .normal)
        
        exploreFrogsButton.titleLabel?.layer.shadowRadius   = 5
        exploreFrogsButton.titleLabel?.layer.shadowColor    = UIColor.black.cgColor
        exploreFrogsButton.titleLabel?.layer.shadowOffset   = CGSize(width: 2, height: 2)
        exploreFrogsButton.titleLabel?.layer.shadowOpacity  = 1
        exploreFrogsButton.titleLabel?.layer.masksToBounds  = false
        view.addSubview(exploreFrogsButton)
        
        exploreFrogsButton.addTarget(nil, action: #selector(exploreFrogsButtonDidTapped), for: .touchUpInside)
        
    }
}
