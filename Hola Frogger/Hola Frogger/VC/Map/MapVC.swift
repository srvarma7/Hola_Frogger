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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        
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
        view.addSubview(focusOnUserLocation)
        
        let safeArea = view.safeAreaLayoutGuide
        focusOnUserLocation.addAnchor(top: nil, paddingTop: 0,
                                      left: nil, paddingLeft: 0,
                                      bottom: safeArea.bottomAnchor, paddingBottom: 50,
                                      right: safeArea.rightAnchor, paddingRight: 20,
                                      width: 50, height: 50,
                                      enableInsets: true)
        focusOnUserLocation.backgroundColor = .green
    }
}
