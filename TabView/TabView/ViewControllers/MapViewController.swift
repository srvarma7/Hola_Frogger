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
    // Focusing on the following location when the Map is loaded.
    var focusLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -37.937282, longitude: 144.610342), latitudinalMeters: 800000, longitudinalMeters: 800000)
    var locationMgr: CLLocationManager = CLLocationManager()
    var tappedLocation: String = ""
    let focusOnUL = UIButton()
    var location = CLLocation()
    let regionRadius: Double = 1000

    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting a button to get to user's current location up on tapping.
        focusOnUL.frame = CGRect(x: self.view.frame.maxX - 60, y: self.view.frame.maxY - 150, width: 30, height: 30)
        focusOnUL.setBackgroundImage(UIImage(systemName: "location.fill"), for: UIControl.State.normal)
        focusOnUL.addTarget(self, action: #selector(foucsOnUserLocation), for: .touchUpInside)
        self.view.addSubview(focusOnUL)
        // Fetching all the records from the coredata and storing in the local variable.
        frogs = CoreDataHandler.fetchObject()
        // If the appliation is opened for the first time then the records are added to the database.
        if(frogs.count == 0) {
            CoreDataHandler.addAllRecords()
            frogs = CoreDataHandler.fetchObject()
        }
        mapView.delegate = self
        // When the Map is loaded the Map will focus to the following location.
        mapView.setRegion(focusLocation, animated: true)
        // Frog locations will be loaded as annotaions after focus on the location.
        loadAnnotations()
        // To get user location and its accuracy.
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
        // Starts monitoring to see if the user enter a Frog Habitat.
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
    
    // When the user locations is changed, map is fouced on current location.
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        foucsOnUserLoc()
    }
    
    // Foucs on the user current location.
    func foucsOnUserLoc() {
        guard let coordinate = locationMgr.location?.coordinate else {return}
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // When the button is tapped, Map will foucs on user location.
    @objc func foucsOnUserLocation(sender: UIButton!) {
        foucsOnUserLoc()
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
    
    // Starts monitoring to see if the user enter a Frog Habitat.
    func startFencing() {
        for ele in frogs {
            let geoLocation = CLCircularRegion(center: CLLocationCoordinate2D(latitude: ele.latitude, longitude: ele.longitude), radius: 100, identifier: ele.cname!)
            geoLocation.notifyOnEntry = true
            locationMgr.startMonitoring(for: geoLocation)
        }
    }
    
    //Alerts the user when he is nearby the Frog's habitat.
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        displayMessage(title: "Alert", message: "You are near a Frog's habitat, please take precautions while entering. \n\n\nNote: Sanitize yourself to keep the frogs safe!!!")
        //Stackoverflow - https://stackoverflow.com/questions/41912386/using-unusernotificationcenter-for-ios-10
        let notification = UNMutableNotificationContent()
        notification.title = "Alert"
        notification.body = "You are near a Frog's habitat, please take precautions while entering. \n\n\nNote: Sanitize yourself to keep the frogs safe!!!"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let req = UNNotificationRequest(identifier: "Request", content: notification, trigger: trigger)
        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
    }
    
    //To display messages to the user as an alert
    func displayMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Pop-up annotation when tapped on a annotation.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (control == view.rightCalloutAccessoryView) {
            tappedLocation = (view.annotation?.title)!!
            performSegue(withIdentifier: "mapFrogDetails", sender: self)
        }
    }
    
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

// Custom annotaion.
/// Reference - https://www.raywenderlich.com/7738344-mapkit-tutorial-getting-started
extension MapViewController {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? FrogAnnotation else {
      return nil
    }
    let identifier = "frogDetails"
    var view: MKMarkerAnnotationView
    if let dequeuedView = mapView.dequeueReusableAnnotationView(
      withIdentifier: identifier) as? MKMarkerAnnotationView {
      dequeuedView.annotation = annotation
      view = dequeuedView
    } else {
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

