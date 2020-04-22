//
//  MapViewController.swift
//  TabView
//
//  Created by Varma on 22/04/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    // UI outlet
    @IBOutlet weak var mapView: MKMapView!
    
    // Variable to fold all the frog recored of Frog entity type
    var frogs: [FrogEntity] = []
    // Location
    var focusLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -37.937282, longitude: 144.610342), latitudinalMeters: 800000, longitudinalMeters: 800000)
    var locationMgr: CLLocationManager = CLLocationManager()
    var tappedLocation: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetching all the records from the coredata and storing in the local variable.
        frogs = CoreDataHandler.fetchObject()
        // If the appliation is opened for the first time then the records are added to the database.
        if(frogs.count == 0) {
            CoreDataHandler.addAllRecords()
            frogs = CoreDataHandler.fetchObject()
        }
        
        // Do any additional setup after loading the view.
        mapView.delegate = self
        // When the Map is loaded the Map will focus to the following location.
        mapView.setRegion(focusLocation, animated: true)
        // Frog locations will be loaded as annotaions after focus on the location.
        loadAnnotations()
        locationMgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationMgr.distanceFilter = 10
        locationMgr.delegate = self
        locationMgr.requestAlwaysAuthorization()
        mapView.showsUserLocation = true
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) {
            (granted, error) in if !granted {
                print("Permission rejected")
                return
            }
        }
        startFencing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        locationMgr.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        locationMgr.stopUpdatingLocation()
    }
    
    // MARK: - Funtion to load annotations on the Map
    func loadAnnotations() {
        //removing annotations and geofencing if any
        mapView.removeAnnotations(mapView.annotations)
        // Adding annotations on the Map
        for ele in frogs {
            let annotaion = FrogAnnotation(title: ele.cname!, subtitle: ele.sname!, latitude: ele.latitude, longitude: ele.longitude)
            mapView.addAnnotation(annotaion)
        }
    }
    
    func startFencing() {
        for ele in frogs {
            let geoLocation = CLCircularRegion(center: CLLocationCoordinate2D(latitude: ele.latitude, longitude: ele.longitude), radius: 100, identifier: ele.cname!)
            geoLocation.notifyOnEntry = true
            locationMgr.startMonitoring(for: geoLocation)
        }
    }
    
    //Alerts the user when he is nearby the destination
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        displayMessage(title: "Alert", message: "You have entered a Frog's Habitat, please sanitize yourself")
        //Stackoverflow - https://stackoverflow.com/questions/41912386/using-unusernotificationcenter-for-ios-10
        let notification = UNMutableNotificationContent()
        notification.title = "Alert"
        notification.body = "You have entered a Frog's Habitat, please sanitize yourself"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let req = UNNotificationRequest(identifier: "Request", content: notification, trigger: trigger)
        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
    }
    
    //To display messages to the user as an alert
    //Reference - Tutorial
    func displayMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (control == view.rightCalloutAccessoryView) {
            tappedLocation = (view.annotation?.title)!!
            performSegue(withIdentifier: "mapFrogDetails", sender: self)
        }
    }
    /*
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotationTitle = view.annotation?.title
        {
            let tappedLocation = "\(annotationTitle!)"
            for ele in frogs {
                if tappedLocation == ele.cname {
                    if let viewController = storyboard?.instantiateViewController(identifier: "frogDetails") as? FrogDetailsViewController {
                        viewController.receivedFrog = ele
                    }
                }
            }
        }
    }
     
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let detailsCrt = self.storyboard?.instantiateViewController(withIdentifier: "test")
        let dest = detailsCrt as! DetailsViewController
        let sldAnnotation = view.annotation as! DestinationAnnotation
        dest.destination = databaseCR?.fetchDestByName(name: sldAnnotation.title!)[0]
        print(dest.destination?.title)
        self.navigationController?.pushViewController(detailsCrt!, animated: true)
    }
*/
    
    // MARK: - Navigation

    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapFrogDetails" {
            let viewController = segue.destination as! FrogDetailsViewController
            for ele in frogs {
                if tappedLocation == ele.cname {
                    viewController.receivedFrog = ele
                }
            }
        }
    }

}

extension MapViewController {
  // 1
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    // 2
    guard let annotation = annotation as? FrogAnnotation else {
      return nil
    }
    // 3
    let identifier = "frogDetails"
    var view: MKMarkerAnnotationView
    // 4
    if let dequeuedView = mapView.dequeueReusableAnnotationView(
      withIdentifier: identifier) as? MKMarkerAnnotationView {
      dequeuedView.annotation = annotation
      view = dequeuedView
    } else {
      // 5
      view = MKMarkerAnnotationView(
        annotation: annotation,
        reuseIdentifier: identifier)
      view.canShowCallout = true
      view.calloutOffset = CGPoint(x: -5, y: 5)
      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    return view
  }
}

