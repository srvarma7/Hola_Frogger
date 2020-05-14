//
//  ChallengeViewController.swift
//  TabView
//
//  Created by Varma on 12/05/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
import CoreLocation
class ChallengeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,CLLocationManagerDelegate {

    @IBOutlet weak var sightedLabel: UILabel!
    @IBOutlet weak var unSightedLabel: UILabel!
    
    var frogs: [FrogEntity] = []
    var unSightedFrogsList: [UnSightedFrogEntity] = []
    let numberOfChallenges = 3
    let locationManager:CLLocationManager = CLLocationManager()
    var currentLocation = CLLocation()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.requestAlwaysAuthorization()
        if (CLLocationManager.locationServicesEnabled())
              {
                  locationManager.startUpdatingLocation()
              }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getStatistics()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfChallenges
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
    }
    
    //add to the challengeCell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChallengeCell
        cell.cname.text = frogs[indexPath.row].cname
        cell.sname.text = frogs[indexPath.row].sname
        //get location and cacluate
        let frogLocation = CLLocation(latitude: frogs[indexPath.row].latitude, longitude: frogs[indexPath.row].longitude)
        
        locationManager(locationManager, didUpdateLocations: [currentLocation])
        let distance: CLLocationDistance = currentLocation.distance(from: frogLocation)/1000
        cell.location.text = "\(String(ceil(distance))) Kms away from you"
        if(frogs[indexPath.row].isVisited){
            cell.visited.text = "You already visited it"
        }
        else{
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
    
    
    // Call this method when user marks a Frog as Visited.
    func updateSightedStatus(receivedFrog: FrogEntity, receivedUnsightedFrog: UnSightedFrogEntity, isVisited: Bool) {
        CoreDataHandler.updateFrog(frog: receivedFrog, isVisited: isVisited, isFavourite: receivedFrog.isFavourite)
        CoreDataHandler.updateUnSightedFrog(unsightedFrog: receivedUnsightedFrog, isVisited: isVisited, isFavourite: receivedUnsightedFrog.isFavourite)
        fetchData()
        getStatistics()
    }
    
    func getStatistics() {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
