//
//  MapVC.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 22/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
import MapKit
import StatusAlert

class MapVC: UIViewController {

    private let userLocationViewSize : CGFloat = 50
    
    private let mapView             = MKMapView()
    private let focusOnUserLocation = UIButton()
    private let userLocationView    = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    private var mapViewModel        = MapViewModel()
    
    private var locationManager     = CLLocationManager()
    private var geoFencingRegion    = CLCircularRegion()
    
    private var userLocationCenter = CLLocationCoordinate2D()
    
    private let zoomScale: CLLocationDistance = 1000

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        configureMapView()
        
        checkLocationServices()
        
        #warning("Enable this in production")
//        if TARGET_OS_SIMULATOR != 0 {
//            showZoomInToUserLocation(status: true)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Enabling geofencing in MapVC")
        startGeofencing()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Disabling geofencing in MapVC")
        stopGeoFencing()
    }
    
    private func configureMapView() {
        mapView.delegate = self
        mapView.mapType = .mutedStandard
        mapView.tintColor = #colorLiteral(red: 0.7719962001, green: 0.1048256829, blue: 0.2892795205, alpha: 1)
        // When the Map is loaded the Map will focus to the following location.
        mapView.setRegion(mapViewModel.focusLocation, animated: true)
    }
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            print("Enabled")
            configureLocationManager()
            checkLocationAuthorization()
        } else {
            print("Disabled")
        }
    }
    
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = .greatestFiniteMagnitude
        locationManager.requestAlwaysAuthorization()
        locationManager.activityType = . automotiveNavigation
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways:
                                        showUserLocation(show: true)
                                        locationManager.startUpdatingLocation()
                                        startGeofencing()
                                        break
            case .authorizedWhenInUse:
                                        showUserLocation(show: true)
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
    
    private func showUserLocation(show: Bool) {
        mapView.showsUserLocation = show
        mapView.setUserTrackingMode(.followWithHeading, animated: true)
    }
    
    private func zoomInToUserLocation() {
        if TARGET_OS_SIMULATOR != 0 {
            showSimulatorUserLocationError()
        } else {
            var userRegion = MKCoordinateRegion()
            userRegion = MKCoordinateRegion(center: userLocationCenter, latitudinalMeters: zoomScale, longitudinalMeters: zoomScale)
            mapView.setRegion(userRegion, animated: true)
        }
    }
    
    private func showZoomInToUserLocation(status: Bool) {
        userLocationView.isHidden = status
    }
    
    private func showSimulatorUserLocationError() {
        let statusAlert = StatusAlert()
        statusAlert.image = UIImage(systemName: "exclamationmark.triangle.fill")
        statusAlert.title = "Error!!!"
        statusAlert.message = "User location is not determined,\nplease use a physical device to get you Location"
        statusAlert.canBePickedOrDismissed = true
        statusAlert.alertShowingDuration = TimeInterval(20)
        statusAlert.showsLargeContentViewer = true

        // Presenting created instance
        statusAlert.showInKeyWindow()
    }
}

// MARK: - Geofencing
extension MapVC {
    private func startGeofencing() {
        for frog in mapViewModel.allFrogsList {
            let center = CLLocationCoordinate2D(latitude: frog.latitude, longitude: frog.longitude)
            geoFencingRegion = CLCircularRegion(center: center, radius: 100, identifier: frog.cname!)
            geoFencingRegion.notifyOnEntry = true
            
            locationManager.startMonitoring(for: geoFencingRegion)
        }
    }
    
    private func stopGeoFencing() {
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let id = region.identifier
        print(id)
        let frogItem = mapViewModel.getFrogByName(commonName: id)
        
        moveMapViewToEnteredRegion(region: region)
        
        let delay = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: delay) { [weak self] in
            self?.showAlertView(frog: frogItem)
        }
    }
    
    private func moveMapViewToEnteredRegion(region: CLRegion) {
        let userRegion = MKCoordinateRegion(center: userLocationCenter, latitudinalMeters: zoomScale*100, longitudinalMeters: zoomScale*100)
        mapView.setRegion(userRegion, animated: true)
    }
    
    private func showAlertView(frog: FrogEntity) {
        let statusAlert = StatusAlert()
        statusAlert.image = UIImage(named: frog.sname!)
        statusAlert.title = "Alert!"
        statusAlert.message = "\nYou have entered \(frog.cname!)'s habitat.\n\nPlease take precautions while entering.\nNote: Sanitize yourself to keep everyone safe!!"
        statusAlert.canBePickedOrDismissed = true
        statusAlert.alertShowingDuration = TimeInterval(20)
        statusAlert.showsLargeContentViewer = true

        // Presenting created instance
        statusAlert.showInKeyWindow()
    }
    
}

// MARK: - Annotations
extension MapVC: MKMapViewDelegate {
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        loadAnnotations()
    }
    
    func loadAnnotations() {
        //removing annotations and geofencing if any
        mapView.removeAnnotations(mapView.annotations)
        // Adding annotations on the Map
        for ele in mapViewModel.allFrogsList {
            let annotaion = FrogAnnotation(title: ele.cname!, subtitle: ele.sname!, latitude: ele.latitude, longitude: ele.longitude)
            mapView.addAnnotation(annotaion)
        }
    }
    
    // Custom annotaion.
    // Reference - https://www.raywenderlich.com/7738344-mapkit-tutorial-getting-started
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? FrogAnnotation else { return nil }
        let identifier = ""
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation,
                                          reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: 0, y: 15)
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageView.image = UIImage(named: annotation.subtitle!)
            view.leftCalloutAccessoryView = imageView
            
            
//            let button = UIButton()
//            button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//            button.addTarget(nil, action: #selector(annotationDidTapped), for: .touchUpInside)
//            button.setImage(UIImage(named: annotation.subtitle!), for: .normal)
//            view.rightCalloutAccessoryView = button
            
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    // Pop-up annotation when tapped on a annotation.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (control == view.rightCalloutAccessoryView || control == view.leftCalloutAccessoryView) {
//            mapViewModel.selectedAnnotationTitle = (view.annotation?.title!)!
            annotationDidTapped(commonName: (view.annotation?.title!)!)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // Storing annotation for displaying frog details
        if let selectedName = view.annotation?.title {
            mapViewModel.selectedAnnotationTitle = selectedName!
        }
    }
    
}

// MARK:- Action
extension MapVC {
    @objc private func focusOnUserLocationDidTapped() {
        zoomInToUserLocation()
    }
    
    @objc private func annotationDidTapped(commonName: String) {
        if mapViewModel.selectedAnnotationTitle != "" {
            let frogDetailsVC = FrogDetailsVC()
            frogDetailsVC.frogItem = mapViewModel.getFrogByName(commonName: commonName)
            present(frogDetailsVC, animated: true, completion: nil)
        }
    }
    
}

// MARK: - CLLocationManager
extension MapVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //
        checkLocationAuthorization()
    }
   
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let userCoordinates = userLocation.coordinate
        userLocationCenter = CLLocationCoordinate2D(latitude: userCoordinates.latitude, longitude: userCoordinates.longitude)
    }
}

// MARK: - Adding views and layout
extension MapVC {
    private func addViews() {
        addMapView()
        addFocusOnUserLocationView()
    }
    
    private func addMapView() {
        view.addSubview(mapView)
        
        mapView.pin(to: view)
    }
    
    private func addFocusOnUserLocationView() {
        let safeArea = view.safeAreaLayoutGuide

        userLocationView.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.5)
        userLocationView.layer.cornerRadius = userLocationViewSize/2
        view.addSubview(userLocationView)
        
        userLocationView.addAnchor(top: nil, paddingTop: 0,
                                   left: nil, paddingLeft: 0,
                                   bottom: safeArea.bottomAnchor, paddingBottom: 50,
                                   right: safeArea.rightAnchor, paddingRight: 40,
                                   width: userLocationViewSize, height: userLocationViewSize, enableInsets: true)
        
        userLocationView.addSubview(focusOnUserLocation)
        
        let padding: CGFloat = 10
        focusOnUserLocation.addAnchor(top: userLocationView.topAnchor, paddingTop: padding,
                                      left: userLocationView.leftAnchor, paddingLeft: padding,
                                      bottom: userLocationView.bottomAnchor, paddingBottom: padding,
                                      right: userLocationView.rightAnchor, paddingRight: padding,
                                      width: 0, height: 0,
                                      enableInsets: true)
        focusOnUserLocation.setBackgroundImage(UIImage(systemName: "location"), for: UIControl.State.normal)
        focusOnUserLocation.tintColor = .raspberryPieTint()
        focusOnUserLocation.addTarget(nil, action: #selector(focusOnUserLocationDidTapped), for: .touchUpInside)
    }
}

