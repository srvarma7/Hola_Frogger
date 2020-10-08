//
//  FrogAnnotation.swift
//  TabView
//
//  Created by Varma on 22/04/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class FrogAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(title: String, subtitle: String, latitude: Double, longitude: Double) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}
