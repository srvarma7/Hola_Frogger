//
//  ChallengeVC.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 27/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
import Lottie
import CoreLocation
import MapKit

class ChallengeVC: UIViewController {
    
    // Top
    private var headerLabel     = UILabel()
    private var subheadingLabel = UILabel()
    
    // Middle
    private var topViewHolderView = UIView()
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ChallengeCVCell.self, forCellWithReuseIdentifier: "cellId")
        return cv
    }()
    private var animationView = AnimationView(name: "award")
    
    // Bottom
    private var statsBottomViewHolder   = UIView()
    private var statsHeading            = UILabel()
    private var statsDivider            = UIView()
    private var frogsSighted            = UILabel()
    private var frogsSightedCount       = UILabel()
    private var yetTosight              = UILabel()
    private var yetToSightCount         = UILabel()
    
    private var challengeViewModel = ChallengeViewModel()
    
    // Location service varible
    private var locationManager     = CLLocationManager()
    private var geoFencingRegion    = CLCircularRegion()
    private var userLocationCenter  = CLLocationCoordinate2D()
    private let mapView             = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        addViews()
        checkLocationServices()
        
        if TARGET_OS_SIMULATOR != 0 {
            print("Device is Simulator \(TARGET_OS_SIMULATOR)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showRespectiveView()
        updateStatLabels()
        startGeofencing()
        SpotLight.showForChallenges(view: view, vc: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        animationView.stop()
        stopGeoFencing()
    }
    
    private func showRespectiveView() {
        if challengeViewModel.unsightedFrogsList.count == 0 {
            collectionView.isHidden = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.animationView.isHidden = false
                self?.animationView.play()
            }
            
        } else {
            animationView.isHidden = true
            
            collectionView.isHidden     = false
            collectionView.delegate     = self
            collectionView.dataSource   = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.reloadData()
        }
    }
    
    private func updateStatLabels() {
        var message = "Sight frogs across Victoria\nto compelete the challenge"
        
        if challengeViewModel.unsightedFrogsList.count == 0 {
            message = "Hurray!!!, Congratulations!!\n\nYou have completed all the challenges!\n\nHere is your Award."
        }
        subheadingLabel.attributedText = NSAttributedString(string: message,
                                                            attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue])
        
        let (sighted, unsighted): (String, String) = challengeViewModel.statistics()
        frogsSightedCount.text  = sighted
        yetToSightCount.text    = unsighted
    }
}

// MARK:- Location services
extension ChallengeVC: CLLocationManagerDelegate {
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            print("Enabled loaction service")
            configureLocationManager()
            checkLocationAuthorization()
        } else {
            print("Disabled loaction service")
        }
    }
    
    private func configureLocationManager() {
        locationManager.delegate        = self
        locationManager.desiredAccuracy = .greatestFiniteMagnitude
        locationManager.activityType    = . automotiveNavigation
        locationManager.requestAlwaysAuthorization()
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            startGeofencing()
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            startGeofencing()
            break
        case .denied:
            // Show user how to activate
            break
        case .notDetermined:
            // Req location
            configureLocationManager()
            break
        case .restricted:
            // Show them alert that restricted by some parental permission
            break
        default:
            break
        }
    }
    
    private func startGeofencing() {
        for frog in challengeViewModel.unsightedFrogsList {
            if !frog.isVisited {
                debugPrint("Enabling geofencing for \(frog.cname!)")
                let center          = CLLocationCoordinate2D(latitude: frog.latitude, longitude: frog.longitude)
                geoFencingRegion    = CLCircularRegion(center: center, radius: 100, identifier: frog.cname!)
                geoFencingRegion.notifyOnEntry = true
                
                locationManager.startMonitoring(for: geoFencingRegion)
            }
        }
    }
    
    private func stopGeoFencing() {
        debugPrint("Stopping geofencing in challenges")
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let id = region.identifier
        print(id, "didEnterRegion")
        let frogItem = challengeViewModel.getFrogByName(commonName: id)
        
        let enteredFrogHabitatVC = EnteredFrogsHabitatVC()
        enteredFrogHabitatVC.unsightedFrogItem = frogItem
        enteredFrogHabitatVC.challengeDelegate = self
        present(enteredFrogHabitatVC, animated: true, completion: nil)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        stopGeoFencing()
        checkLocationAuthorization()
    }
}

// MARK:- Protocol
extension ChallengeVC: ChallengeProtocol {
    func didUpdateSightedStatus(unsightedFrogEntity: UnSightedFrogEntity, status: Bool) {
        challengeViewModel.updateFrogSightedStatus(frog: unsightedFrogEntity, sightedStatus: status)
        showRespectiveView()
        updateStatLabels()
        stopGeoFencing()
        startGeofencing()
    }
}

// MARK:- CollectionView
extension ChallengeVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/1.2, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return challengeViewModel.unsightedFrogsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ChallengeCVCell
        cell.frogItem = challengeViewModel.unsightedFrogsList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let frogDetailsVC = FrogDetailsVC()
        frogDetailsVC.frogItem = challengeViewModel.getFrogForDetailsView(index: indexPath.row)
        present(frogDetailsVC, animated: true, completion: nil)
        
        //        let vc = EnteredFrogsHabitatVC()
        //        vc.unsightedFrogItem = challengeViewModel.unsightedFrogsList[indexPath.row]
        //        present(vc, animated: true, completion: nil)
    }
}

// MARK:- Views and layout
extension ChallengeVC {
    
    private func addViews() {
        addTopViews()
        addMiddleViews()
        addBottomViews()
    }
    
    private func addTopViews() {
        addHeaderLabel()
        addSubHeader()
    }
    
    private func addMiddleViews() {
        addTopViewHolderView()
        addCollectionView()
        addLottieView()
    }
    
    private func addBottomViews() {
        //let screen = UIScreen.main.bounds
        view.addSubview(statsBottomViewHolder)
        
        statsBottomViewHolder.layer.cornerRadius   = 20
        statsBottomViewHolder.clipsToBounds        = true
        statsBottomViewHolder.backgroundColor      = .raspberryPieTint()
        statsBottomViewHolder.addAnchor(top: nil, paddingTop: 0,
                                        left: view.leftAnchor, paddingLeft: 5,
                                        bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 5,
                                        right: view.rightAnchor, paddingRight: 5,
                                        width: 0, height: 155,
                                        enableInsets: true)
        
        view.addSubview(statsHeading)
        statsHeading.text           = "Challenges"
        statsHeading.font           = UIFont.systemFont(ofSize: 22, weight: .bold)
        statsHeading.textAlignment  = .center
        statsHeading.textColor      = .white
        statsHeading.addAnchor(top: statsBottomViewHolder.topAnchor, paddingTop: 15,
                               left: statsBottomViewHolder.leftAnchor, paddingLeft: 20,
                               bottom: nil, paddingBottom: 0,
                               right: statsBottomViewHolder.rightAnchor, paddingRight: 20,
                               width: 0, height: 0, enableInsets: true)
        
        view.addSubview(statsDivider)
        statsDivider.backgroundColor    = .white
        statsDivider.layer.cornerRadius = 2.5
        statsDivider.addAnchor(top: statsHeading.bottomAnchor, paddingTop: 10,
                               left: statsBottomViewHolder.leftAnchor, paddingLeft: 30,
                               bottom: nil, paddingBottom: 0,
                               right: statsBottomViewHolder.rightAnchor, paddingRight: 30,
                               width: 0, height: 5, enableInsets: true)
        
        let leftRightPadding: CGFloat = 35
        
        view.addSubview(frogsSighted)
        frogsSighted.textColor      = .white
        frogsSighted.text           = "Frogs sighted"
        frogsSighted.textAlignment  = .left
        frogsSighted.addAnchor(top: statsDivider.bottomAnchor, paddingTop: 15,
                               left: statsBottomViewHolder.leftAnchor, paddingLeft: leftRightPadding,
                               bottom: nil, paddingBottom: 0,
                               right: nil, paddingRight: 0,
                               width: 0, height: 0, enableInsets: true)
        
        view.addSubview(frogsSightedCount)
        frogsSightedCount.textColor     = .white
        frogsSightedCount.text          = "0"
        frogsSightedCount.textAlignment = .right
        frogsSightedCount.addAnchor(top: frogsSighted.topAnchor, paddingTop: 0,
                                    left: nil, paddingLeft: 0,
                                    bottom: nil, paddingBottom: 0,
                                    right: statsBottomViewHolder.rightAnchor, paddingRight: leftRightPadding,
                                    width: 0, height: 0, enableInsets: true)
        
        view.addSubview(yetTosight)
        yetTosight.textColor        = .white
        yetTosight.text             = "Frogs yet to sight"
        yetTosight.textAlignment    = .left
        yetTosight.addAnchor(top: frogsSighted.bottomAnchor, paddingTop: 10,
                             left: statsBottomViewHolder.leftAnchor, paddingLeft: leftRightPadding,
                             bottom: nil, paddingBottom: 0,
                             right: nil, paddingRight: 0,
                             width: 0, height: 0, enableInsets: true)
        
        view.addSubview(yetToSightCount)
        yetToSightCount.textColor       = .white
        yetToSightCount.text            = "0"
        yetToSightCount.textAlignment   = .right
        yetToSightCount.addAnchor(top: yetTosight.topAnchor, paddingTop: 0,
                                  left: nil, paddingLeft: 0,
                                  bottom: nil, paddingBottom: 0,
                                  right: statsBottomViewHolder.rightAnchor, paddingRight: leftRightPadding,
                                  width: 0, height: 0, enableInsets: true)
    }
    
    private func addHeaderLabel() {
        view.addSubview(headerLabel)
        
        headerLabel.text           = "Challenges"
        headerLabel.font           = UIFont.systemFont(ofSize: 30, weight: .heavy)
        headerLabel.textAlignment  = .center
        
        let safeAreaView = self.view.safeAreaLayoutGuide
        
        headerLabel.addAnchor(top: safeAreaView.topAnchor, paddingTop: 10,
                              left: safeAreaView.leftAnchor, paddingLeft: 0,
                              bottom: nil, paddingBottom: 0,
                              right: safeAreaView.rightAnchor, paddingRight: 0,
                              width: 0, height: 0, enableInsets: true)
    }
    
    private func addSubHeader() {
        view.addSubview(subheadingLabel)
        subheadingLabel.attributedText = NSAttributedString(string: "Sight frogs across Victoria\nto compelete the challenge",
                                                            attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue])
        subheadingLabel.numberOfLines  = 0
        subheadingLabel.textAlignment  = .center
        
        subheadingLabel.addAnchor(top: headerLabel.bottomAnchor, paddingTop: 10,
                                  left: headerLabel.leftAnchor, paddingLeft: 0,
                                  bottom: nil, paddingBottom: 0,
                                  right: headerLabel.rightAnchor, paddingRight: 0,
                                  width: 0, height: 0, enableInsets: true)
    }
    
    private func addTopViewHolderView() {
        view.addSubview(topViewHolderView)
        let safeArea = view.safeAreaLayoutGuide
        let screen  = UIScreen.main.bounds
        
        topViewHolderView.addAnchor(top: subheadingLabel.bottomAnchor, paddingTop: 15,
                                    left: safeArea.leftAnchor, paddingLeft: 10,
                                    bottom: nil, paddingBottom: 0,
                                    right: safeArea.rightAnchor, paddingRight: 10,
                                    width: 0, height: screen.height/2.15, enableInsets: false)
    }
    
    private func addCollectionView() {
        topViewHolderView.addSubview(collectionView)
        
        collectionView.backgroundColor = .systemBackground
        collectionView.pin(to: topViewHolderView)
        
        collectionView.isHidden = true
    }
    
    private func addLottieView() {
        let screen = UIScreen.main.bounds
        topViewHolderView.addSubview(animationView)
        animationView.contentMode   = .scaleAspectFit
        animationView.loopMode      = .loop
        animationView.isHidden      = true
        animationView.addAnchor(top: topViewHolderView.topAnchor, paddingTop: 0,
                                left: topViewHolderView.leftAnchor, paddingLeft: 0,
                                bottom: nil, paddingBottom: 0,
                                right: topViewHolderView.rightAnchor, paddingRight: 0,
                                width: 0, height: screen.height/2.5, enableInsets: true)
    }
}
