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
import AwesomeSpotlightView

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, AwesomeSpotlightViewDelegate {
    
    // UI outlet
    @IBOutlet weak var segmentedControl: UISegmentedControl!
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
    var geoLocation = CLCircularRegion()


    var spotlight: [SpotLightEntity] = []
    var spotlightView = AwesomeSpotlightView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.selectedSegmentIndex = -1
        // Setting a button to get to user's current location up on tapping.
        focusOnUL.frame = CGRect(x: self.view.frame.maxX - 60, y: self.view.frame.maxY - 150, width: 30, height: 30)
        focusOnUL.setBackgroundImage(UIImage(systemName: "location.fill"), for: UIControl.State.normal)
        focusOnUL.tintColor = #colorLiteral(red: 0.7719962001, green: 0.1048256829, blue: 0.2892795205, alpha: 1)
        focusOnUL.addTarget(self, action: #selector(foucsOnUserLocation), for: .touchUpInside)
        self.view.addSubview(focusOnUL)
        // Fetching all the records from the coredata and storing in the local variable.
        frogs = CoreDataHandler.fetchAllFrogs()
        // If the appliation is opened for the first time then the records are added to the database.
        if(frogs.count == 0) {
            CoreDataHandler.addAllFrogRecordsToDatabase()
            frogs = CoreDataHandler.fetchAllFrogs()
        }
        mapView.delegate = self
        // When the Map is loaded the Map will focus to the following location.
        mapView.setRegion(focusLocation, animated: true)
        mapView.tintColor = #colorLiteral(red: 0.7719962001, green: 0.1048256829, blue: 0.2892795205, alpha: 1)
        // Frog locations will be loaded as annotaions after focus on the location.
        loadAnnotations()
        SetupLocationAndNotification()
        // Starts monitoring to see if the user enter a Frog Habitat.
        startFencing()
        
        checkForSpotLight()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        locationMgr.startUpdatingLocation()
        startFencing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        locationMgr.stopUpdatingLocation()
        stopFencing()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        locationMgr.stopUpdatingLocation()
        stopFencing()
    }
    
    

    // Check if the application is opening for the first time
    func checkForSpotLight() {
        if spotlight.isEmpty {
            CoreDataHandler.addSpotLight()
            spotlight = CoreDataHandler.fetchSpotLight()
        }
        if !(spotlight.first!.location) {
            startSpotLightTour()
        }
    }
    
    // If the application is opened for the first time, provide tutorial to the user using spot light.
    func startSpotLightTour() {
        let screenSize: CGRect = UIScreen.main.bounds
        var spotlight1 = AwesomeSpotlight()
        var spotlight2 = AwesomeSpotlight()
        var spotlightMain = AwesomeSpotlight()
        var properDevice = false
        print(screenSize.width)
        if screenSize.width == 414.0 {
            spotlightMain = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\n\n\n\n\n\n\n\nAll the frogs locations in Victoria are show here", isAllowPassTouchesThroughSpotlight: false)
            spotlight1 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 95, y: 380, width: 100, height: 100), shape: .circle, text: "To get more details of the frog, tap on the annotation", isAllowPassTouchesThroughSpotlight: false)
            // Spotlight for Frog's Common Name
            spotlight2 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 343, y: 735, width: 50, height: 50), shape: .circle, text: "Tap on this button to zoom into your location", isAllowPassTouchesThroughSpotlight: false)
            properDevice = true
        } else if screenSize.width == 375.0 {
            spotlightMain = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\n\n\n\n\n\n\n\nAll the frogs locations in Victoria are show here", isAllowPassTouchesThroughSpotlight: false)
            spotlight1 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 77, y: 330, width: 100, height: 100), shape: .circle, text: "To get more details of the frog, tap on the annotation", isAllowPassTouchesThroughSpotlight: false)
            // Spotlight for Frog's Common Name
            spotlight2 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 303, y: 650, width: 50, height: 50), shape: .circle, text: "Tap on this button to zoom into your location", isAllowPassTouchesThroughSpotlight: false)
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
            CoreDataHandler.updateSpotLight(attribute: "location", boolean: true)
        }
    }
    
    fileprivate func SetupLocationAndNotification() {
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
    }
    
    func stopFencing() {
        for region in locationMgr.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion,
              circularRegion.identifier == region.identifier else { continue }
            locationMgr.stopMonitoring(for: circularRegion)
        }
        
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
            geoLocation = CLCircularRegion(center: CLLocationCoordinate2D(latitude: ele.latitude, longitude: ele.longitude), radius: 100, identifier: ele.cname!)
            geoLocation.notifyOnEntry = true
            locationMgr.startMonitoring(for: geoLocation)
        }
    }
    
    //Alerts the user when he is nearby the Frog's habitat.
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print(region.identifier)
        displayMessage(title: "Alert", message: "You are near a Frog's habitat, please take precautions while entering. \n\n\nNote: Sanitize yourself to keep the frogs safe!!!")
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
    // In a storyboard-based application, you will often want to do a little preparation before navigation
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

    @IBAction func segmentedControlDidTapped(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0 {
            segmentedControl.selectedSegmentTintColor = #colorLiteral(red: 0.4280183911, green: 0.5731796026, blue: 0.1544426084, alpha: 1)
            displayMessage(title: "Alert", message: "You are near a Brown Toadlet frog's habitat, please take precautions while entering. \n\n\nNote: Sanitize yourself to keep the frogs safe!!!")
            //mapView.userLocation = MKUserLocation
        } else if segmentedControl.selectedSegmentIndex == 1 {
            segmentedControl.selectedSegmentTintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            displayMessage(title: "Alert", message: "You are near a Dendy's Toadlet frog's habitat, please take precautions while entering. \n\n\nNote: Sanitize yourself to keep the frogs safe!!!")
        } else if segmentedControl.selectedSegmentIndex == 2 {
            segmentedControl.selectedSegmentTintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            displayMessage(title: "Alert", message: "You are near Southern Toadlet frog's habitat, please take precautions while entering. \n\n\nNote: Sanitize yourself to keep the frogs safe!!!")
        } else if segmentedControl.selectedSegmentIndex == 3 {
            segmentedControl.selectedSegmentTintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            displayMessage(title: "Alert", message: "You are near Victorian Smooth Froglet frog's habitat, please take precautions while entering. \n\n\nNote: Sanitize yourself to keep the frogs safe!!!")
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
        let identifier = ""
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
            let button = UIButton()
            button.backgroundColor = .green
            button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            button.addTarget(nil, action: #selector(focusOnUserLocationDidTapped), for: .touchUpInside)
            
            view.rightCalloutAccessoryView = button
        }
        return view
    }
    
    @objc private func focusOnUserLocationDidTapped() {
        print("Tapped")
    }
}

