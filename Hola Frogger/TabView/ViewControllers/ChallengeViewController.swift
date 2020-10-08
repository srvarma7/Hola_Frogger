//
//  ChallengeViewController.swift
//  TabView
//
//  Created by Varma on 12/05/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Lottie
import AudioToolbox
import AVFoundation
import AwesomeSpotlightView


class ChallengeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate, MKMapViewDelegate, AwesomeSpotlightViewDelegate {

    @IBOutlet weak var sightedLabel: UILabel!
    @IBOutlet weak var unSightedLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var congratsLbl: UILabel!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var bgImage: UIImageView!
    var animationView = AnimationView()
    
    
    var audioPlayer = AVAudioPlayer()
    
    
    var frogsList: [FrogEntity] = []
    var unSightedFrogsList: [UnSightedFrogEntity] = []
    let numberOfChallenges = 3
    let locationManager:CLLocationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var geoLocation = CLCircularRegion()
    var spotlightView = AwesomeSpotlightView()
    var spotlight: [SpotLightEntity] = []

    var sightedCount: Int = 0
    var unSightedCount: Int = 0
    
    var numberOfFrogsLeftInChallenge: Int = 0
    @IBOutlet weak var locSegmentedCtrl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        congratsLbl.isHidden = true
        msgLbl.isHidden = true
        setupLocationManager()
        // Start geo fencing when there are unsighted forgs in challenge
        if unSightedFrogsList.count > 0 {
            startFencing()
        }
        collectionView.dataSource = self
        getStatistics()
        
        collectionView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: NSNotification.Name(rawValue: "reloadChallenges"), object: nil)
        checkForSpotLight()
        changeSegment()
    }

    // Check if the application is opening for the first time to load spotlight
    func checkForSpotLight() {
        if spotlight.isEmpty {
            CoreDataHandler.addSpotLight()
            spotlight = CoreDataHandler.fetchSpotLight()
        }
        if !(spotlight.first!.challenges) {
            startSpotLightTour()
        }
    }
    
    func startSpotLightTour() {
        let screenSize: CGRect = UIScreen.main.bounds
        var spotlightMain = AwesomeSpotlight()
        var spotlightMain2 = AwesomeSpotlight()
        var spotlightMain3 = AwesomeSpotlight()
        var spotlightMain4 = AwesomeSpotlight()
        var spotlightMain5 = AwesomeSpotlight()

        var spotlight1 = AwesomeSpotlight()
        var spotlight2 = AwesomeSpotlight()
        var properDevice = false
        print(screenSize.width)
        if screenSize.width == 414.0 {
            spotlightMain = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\n\n\nWelcome to the challenges", isAllowPassTouchesThroughSpotlight: false)
            spotlightMain2 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\n\n\n\n\nTo complete the challenges, visit the frog's location in the challenges and sight the frogs in the location", isAllowPassTouchesThroughSpotlight: false)
            spotlight1 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 10, y: 150, width: 395, height: 400), shape: .roundRectangle, text: "\nCurrent challenges are shown here", isAllowPassTouchesThroughSpotlight: false)
            spotlightMain3 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\n\n\n\n\nOnce you sight all the frogs in the challenge, new challenges will be added", isAllowPassTouchesThroughSpotlight: false)
            spotlightMain4 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\n\n\n\n\nRed card represents the unsighted frog\n(Yet to complete the challenge)", isAllowPassTouchesThroughSpotlight: false)
            spotlightMain5 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\n\n\n\n\nGreen card represents the sighted frog\n(Completed the challenge)", isAllowPassTouchesThroughSpotlight: false)
            spotlight2 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 16, y: 610, width: 380, height: 150), shape: .roundRectangle, text: "\n\n\nYour current progress", isAllowPassTouchesThroughSpotlight: false)
            properDevice = true
        } else if screenSize.width == 375.0 {
            spotlightMain = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\n\n\nWelcome to the challenges", isAllowPassTouchesThroughSpotlight: false)
            spotlightMain2 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\n\n\n\n\nTo complete the challenges, visit the frog's location in the challenges and sight the frogs in the location", isAllowPassTouchesThroughSpotlight: false)
            spotlight1 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 13, y: 140, width: 350, height: 370), shape: .roundRectangle, text: "\nCurrent challenges are shown here", isAllowPassTouchesThroughSpotlight: false)
            spotlightMain3 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\n\n\n\n\nOnce you sight all the frogs in the challenge, new challenges will be added", isAllowPassTouchesThroughSpotlight: false)
            spotlightMain4 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\n\n\n\n\nRed card represents the unsighted frog\n(Yet to complete the challenge)", isAllowPassTouchesThroughSpotlight: false)
            spotlightMain5 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\n\n\n\n\nGreen card represents the sighted frog\n(Completed the challenge)", isAllowPassTouchesThroughSpotlight: false)
            spotlight2 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 10, y: 555, width: 350, height: 140), shape: .roundRectangle, text: "\n\n\nYour current progress", isAllowPassTouchesThroughSpotlight: false)
            properDevice = true
        }
        if properDevice {
            let spotlightView = AwesomeSpotlightView(frame: view.frame, spotlight: [spotlightMain, spotlightMain2, spotlight1, spotlightMain3, spotlightMain4, spotlightMain5, spotlight2])
            
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
            CoreDataHandler.updateSpotLight(attribute: "challenges", boolean: true)
        }
    }
    
    @objc func reloadCollectionView(notification: NSNotification){
        /// load data here
        fetchData()
        getStatistics()
        fetchData()
        print(unSightedFrogsList.count, "numberOfFrogsLeftInChallenge after dismiss of visited screen")
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stopFencing()
        fetchData()
        getStatistics()
        fetchData()
        startFencing()
        collectionView.reloadData()
        UIView.animate(withDuration: 2, delay: 0, animations: {
            self.bgImage.layer.cornerRadius = (self.bgImage.frame.size.width)/10
            self.bgImage.clipsToBounds = true
        })
    }
    
    // Calculate visied and unvisited frogs to show in statistics
    func getStatistics() {
        fetchData()
        sightedCount = 0
        unSightedCount = 0
         for ele in frogsList {
                if ele.isVisited {
                 sightedCount += 1
             } else {
                 unSightedCount += 1
             }
         }
         sightedLabel.text = String(sightedCount)
         unSightedLabel.text = String(unSightedCount)
        // MARK: -
        if unSightedCount == 0 {
            loadAnimationViewAndDisplayText()
        }
        numberOfFrogsLeftInChallenge = 0
        for ele in unSightedFrogsList {
            if !(ele.isVisited) {
                numberOfFrogsLeftInChallenge += 1
            }
        }
        print(numberOfFrogsLeftInChallenge, "numberOfFrogsLeftInChallenge")
        if numberOfFrogsLeftInChallenge == 0 {
            print("Sighted all frogs \n DELETING THE RECORDS")
            CoreDataHandler.deleteRecordsByEntity(entityName: "UnSightedFrogEntity")
            //fetchData()
            let afterDelete = CoreDataHandler.fetchAllUnsightedFrogs()
            print(afterDelete.count, "AFTER DELETE")
            
        }
        fetchData()
        
    }
    
    // If all the challenges are complete, it plays animation and text to congratulate and show status of the challenge
    fileprivate func loadAnimationViewAndDisplayText() {
        let animationView = AnimationView(name: "award")
        animationView.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        animationView.center.x = self.view.center.x
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
        
        _ = animationView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 180, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 250, heightConstant: 250)
        
        congratsLbl.isHidden = false
        msgLbl.isHidden = false
        congratsLbl.text = "Congratulations!!"
        congratsLbl.font = UIFont.boldSystemFont(ofSize: 20)
        msgLbl.text = "You have completed all the challenges"
        lottieAnimation(AnimationName: "confetti1", top: 150, sides: 30, size: 800)
        AudioServicesPlaySystemSound(1520)
        //play(sound: "confetti")
        locSegmentedCtrl.isHidden = true
    }
    
    func play(sound: String) {
        let sound = URL(fileURLWithPath: Bundle.main.path(forResource: sound, ofType: "mp3")!)
        do {
             audioPlayer = try AVAudioPlayer(contentsOf: sound)
             audioPlayer.play()
        } catch {  }
    }
    
    func lottieAnimation(AnimationName: String, top: CGFloat, sides: CGFloat, size: CGFloat) {
        animationView = AnimationView(name: AnimationName)
        animationView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFit
        animationView.backgroundColor = UIColor(white: 0, alpha: 0)
        view.addSubview(animationView)
        animationView.loopMode = .playOnce
        animationView.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            self.animationView.removeFromSuperview()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
        stopFencing()
        
    }
    
    func stopFencing() {
        for region in locationManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion,
              circularRegion.identifier == region.identifier else { continue }
            locationManager.stopMonitoring(for: circularRegion)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return unSightedFrogsList.count
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
        collectionView.reloadData()
        
    }
    
    //add to the challengeCell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChallengeCell
        
        let color = UIColor.white
        cell.frogImage.image = UIImage(named: unSightedFrogsList[indexPath.row].sname!)
        cell.cname.text = unSightedFrogsList[indexPath.row].cname
        cell.cname.textColor = color
        cell.sname.text = unSightedFrogsList[indexPath.row].sname
        cell.sname.textColor = color
        //get location and cacluate
        let frogLocation = CLLocation(latitude: unSightedFrogsList[indexPath.row].latitude, longitude: unSightedFrogsList[indexPath.row].longitude)
        
        let distance: CLLocationDistance = currentLocation.distance(from: frogLocation)/1000
        cell.location.text = "\(String(ceil(distance))) Kms away from you"
        cell.location.textColor = color
        if(unSightedFrogsList[indexPath.row].isVisited){
            cell.visited.text = "You already Sighted"
            cell.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 0.7)
        } else{
            cell.visited.text = "Not yet Sighted"
            cell.backgroundColor = UIColor(red: 0.8, green: 0, blue: 0, alpha: 0.7)
        }
        cell.visited.textColor = color
        //set layout for cell
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        return cell
    }
    
    //when tap the cell to get the information
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewController = storyboard?.instantiateViewController(identifier: "frogDetails") as? FrogDetailsViewController {
            var newFrog: FrogEntity
            newFrog = frogsList[indexPath.row]
            let frog = newFrog
            viewController.receivedFrog = frog
            navigationController?.present(viewController, animated: true)
        }
    }
    
    // Fetching the Frogs details when the controller is invoked.
    func fetchData() {
        frogsList = CoreDataHandler.fetchAllFrogs()
        unSightedFrogsList = CoreDataHandler.fetchAllUnsightedFrogs()
        print(unSightedFrogsList.count)
        if unSightedFrogsList.count == 0 {
            var flag = 0
            for ele in frogsList {
                if flag == numberOfChallenges {
                    break
                } else {
                    if !(ele.isVisited) {
                        print(flag+1)
                        CoreDataHandler.saveFrog(entityName: "UnSightedFrogEntity", sname: ele.sname!, frogcount: Int(ele.frogcount), cname: ele.cname!, desc: ele.desc!, latitude: ele.latitude, longitude: ele.longitude, uncertainty: Int(ele.uncertainty), threatnedStatus: ele.threatnedStatus!, isVisited: ele.isVisited, isFavourite: ele.isFavourite)
                        flag += 1
                    }
                }
            }
        } else {
            stopFencing()
            startFencing()
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.requestAlwaysAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
              locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - Monitoring Location
    func startFencing() {
        for ele in unSightedFrogsList {
            if !ele.isVisited {
                geoLocation = CLCircularRegion(center: CLLocationCoordinate2D(latitude: ele.latitude, longitude: ele.longitude), radius: 100, identifier: ele.cname!)
                geoLocation.notifyOnEntry = true
                locationManager.startMonitoring(for: geoLocation)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print(region.identifier, "IDENTIFIER")
        print(region.description)
        showDetails(frogname: region.identifier)
    }
    
    // When the user enters to the frog location in the challenge, this method is automatically called to ask user whether he sighted the frog or not.
    func showDetails(frogname: String) {
        print(frogname, "SHOW DETAILS")
        let singleFrog = CoreDataHandler.fetchSpecificFrog(frogname: frogname)
        print(singleFrog.sname!, "IN SHOW DETAILS sname")
        print(singleFrog.cname!, "IN SHOW DETAILS cname")
        if let viewController = storyboard?.instantiateViewController(identifier: "visitedDetails") as? VisitedViewController {
            viewController.receivedFrog = singleFrog
            navigationController?.present(viewController, animated: true)
        }
       
    }
   
    func changeSegment() {
        locSegmentedCtrl.selectedSegmentIndex = -1
    }
    
    @IBAction func didTapLocSegmentedCtrl(_ sender: Any) {
        if locSegmentedCtrl.selectedSegmentIndex == 0 {
            locSegmentedCtrl.selectedSegmentTintColor = #colorLiteral(red: 0.4280183911, green: 0.5731796026, blue: 0.1544426084, alpha: 1)
            showDetails(frogname: "Brown Toadlet")
        } else if locSegmentedCtrl.selectedSegmentIndex == 1 {
            locSegmentedCtrl.selectedSegmentTintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            showDetails(frogname: "Dendy's Toadlet")
        } else if locSegmentedCtrl.selectedSegmentIndex == 2 {
            locSegmentedCtrl.selectedSegmentTintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            showDetails(frogname: "Southern Toadlet")
        }
    }
}
