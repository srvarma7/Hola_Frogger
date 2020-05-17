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

class ChallengeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var sightedLabel: UILabel!
    @IBOutlet weak var unSightedLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var frogs: [FrogEntity] = []
    var unSightedFrogsList: [UnSightedFrogEntity] = []
    let numberOfChallenges = 3
    let locationManager:CLLocationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var geoLocation = CLCircularRegion()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupLocationManager()
        if unSightedFrogsList.count > 0 {
            startFencing()
        }
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stopFencing()
        fetchData()
        getStatistics()
        startFencing()
        collectionView.reloadData()
        
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
        return numberOfChallenges
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
        collectionView.reloadData()
        
    }
    
    //add to the challengeCell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChallengeCell
       
        cell.cname.text = frogs[indexPath.row].cname
        cell.sname.text = frogs[indexPath.row].sname
        //get location and cacluate
        let frogLocation = CLLocation(latitude: frogs[indexPath.row].latitude, longitude: frogs[indexPath.row].longitude)
        
      //  locationManager(locationManager, didUpdateLocations: [currentLocation])
        let distance: CLLocationDistance = currentLocation.distance(from: frogLocation)/1000
        cell.location.text = "\(String(ceil(distance))) Kms away from you"
        if(frogs[indexPath.row].isVisited){
            cell.visited.text = "You already visited it"
        } else{
            cell.visited.text = "Not yet Visited"
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
            newFrog = frogs[indexPath.row]
            let frog = newFrog
            viewController.receivedFrog = frog
            navigationController?.present(viewController, animated: true)
        }
    }
    
    // Fetching the Frogs details when the controller is invoked.
    func fetchData() {
        frogs = CoreDataHandler.fetchAllFrogs()
        unSightedFrogsList = CoreDataHandler.fetchAllUnsightedFrogs()
        print(unSightedFrogsList.count)
        if unSightedFrogsList.count == 0 {
            var flag = 0
            for ele in frogs {
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
    
    // Call this method when user marks a Frog as Visited.
    func updateSightedStatus(receivedFrog: FrogEntity, receivedUnsightedFrog: UnSightedFrogEntity, isVisited: Bool) {
        CoreDataHandler.updateFrog(frog: receivedFrog, isVisited: isVisited, isFavourite: receivedFrog.isFavourite)
        CoreDataHandler.updateUnSightedFrog(unsightedFrog: receivedUnsightedFrog, isVisited: isVisited, isFavourite: receivedUnsightedFrog.isFavourite)
        fetchData()
        getStatistics()
    }
    
    func getStatistics() {
        fetchData()
        var sightedCount: [String] = []
        var unSightedCount: [String] = []
        for ele in frogs {
            if ele.isVisited {
                sightedCount.append(ele.sname!)
            } else {
                unSightedCount.append(ele.sname!)
            }
        }
        sightedLabel.text = String(sightedCount.count)
        unSightedLabel.text = String(unSightedCount.count)
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
