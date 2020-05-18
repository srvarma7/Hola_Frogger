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

class ChallengeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var sightedLabel: UILabel!
    @IBOutlet weak var unSightedLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var congratsLbl: UILabel!
    @IBOutlet weak var msgLbl: UILabel!
    var animationView = AnimationView()
    
    
    var audioPlayer = AVAudioPlayer()
    
    
    var frogsList: [FrogEntity] = []
    var unSightedFrogsList: [UnSightedFrogEntity] = []
    let numberOfChallenges = 3
    let locationManager:CLLocationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var geoLocation = CLCircularRegion()
    

    var sightedCount: Int = 0
    var unSightedCount: Int = 0
    
    var numberOfFrogsLeftInChallenge: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        congratsLbl.isHidden = true
        msgLbl.isHidden = true
        setupLocationManager()
        if unSightedFrogsList.count > 0 {
            startFencing()
        }
        collectionView.dataSource = self
        getStatistics()
        
        collectionView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    @objc func loadList(notification: NSNotification){
        /// load data here
        fetchData()
        getStatistics()
        fetchData()
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stopFencing()
        fetchData()
        getStatistics()
        fetchData()
        startFencing()
        collectionView.reloadData()
    }
    
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
            play(sound: "confetti")
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
        cell.frogImage.image = UIImage(named: unSightedFrogsList[indexPath.row].sname!)
        cell.cname.text = unSightedFrogsList[indexPath.row].cname
        cell.sname.text = unSightedFrogsList[indexPath.row].sname
        //get location and cacluate
        let frogLocation = CLLocation(latitude: unSightedFrogsList[indexPath.row].latitude, longitude: unSightedFrogsList[indexPath.row].longitude)
        
      //  locationManager(locationManager, didUpdateLocations: [currentLocation])
        let distance: CLLocationDistance = currentLocation.distance(from: frogLocation)/1000
        cell.location.text = "\(String(ceil(distance))) Kms away from you"
        if(unSightedFrogsList[indexPath.row].isVisited){
            cell.visited.text = "You already Sighted"
            cell.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 0.7)
        } else{
            cell.visited.text = "Not yet Sighted"
            cell.backgroundColor = UIColor(red: 0.8, green: 0, blue: 0, alpha: 0.7)
        }
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
            geoLocation = CLCircularRegion(center: CLLocationCoordinate2D(latitude: ele.latitude, longitude: ele.longitude), radius: 100, identifier: ele.cname!)
            geoLocation.notifyOnEntry = true
            locationManager.startMonitoring(for: geoLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print(region.identifier, "IDENTIFIER")
        print(region.description)
        showDetails(frogname: region.identifier)
    }
    
    

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
   
}
