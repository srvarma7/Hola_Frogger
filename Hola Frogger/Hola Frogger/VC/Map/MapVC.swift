//
//  MapVC.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 22/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    private let mapView             = MKMapView()
    private let focusOnUserLocation = UIButton()
    
    private var mapViewModel = MapViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        mapView.delegate = self
        mapView.mapType = .satelliteFlyover
        loadAnnotations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // When the Map is loaded the Map will focus to the following location.
        mapView.tintColor = #colorLiteral(red: 0.7719962001, green: 0.1048256829, blue: 0.2892795205, alpha: 1)
        mapView.setRegion(mapViewModel.focusLocation, animated: true)
    }
    
}

// MARK: - Annotations
extension MapVC: MKMapViewDelegate {
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
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
    }
    
    // Pop-up annotation when tapped on a annotation.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (control == view.rightCalloutAccessoryView || control == view.leftCalloutAccessoryView) {
            mapViewModel.selectedAnnotationTitle = (view.annotation?.title!)!
            annotationDidTapped()
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
        print("Tapped")
    }
    
    @objc private func annotationDidTapped() {
        if mapViewModel.selectedAnnotationTitle != "" {
            let frogDetailsVC = FrogDetailsVC()
            frogDetailsVC.frogItem = mapViewModel.getFrogByName()
            present(frogDetailsVC, animated: true, completion: nil)
        }
    }
    
}

// MARK: -
extension MapVC {
    
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
        view.addSubview(focusOnUserLocation)
        
        let safeArea = view.safeAreaLayoutGuide
        focusOnUserLocation.addAnchor(top: nil, paddingTop: 0,
                                      left: nil, paddingLeft: 0,
                                      bottom: safeArea.bottomAnchor, paddingBottom: 50,
                                      right: safeArea.rightAnchor, paddingRight: 20,
                                      width: 30, height: 30,
                                      enableInsets: true)
        focusOnUserLocation.setBackgroundImage(UIImage(systemName: "location.fill"), for: UIControl.State.normal)
        focusOnUserLocation.tintColor = .raspberryPieTint()
        focusOnUserLocation.addTarget(nil, action: #selector(focusOnUserLocationDidTapped), for: .touchUpInside)
    }
}

