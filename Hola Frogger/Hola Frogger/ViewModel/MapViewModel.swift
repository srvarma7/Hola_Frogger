//
//  MapViewModel.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 22/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import Foundation
import MapKit

class MapViewModel {
    
    var allFrogsList = [FrogEntity]()
    
    var focusLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -37.937282, longitude: 144.610342), latitudinalMeters: 800000, longitudinalMeters: 800000)
    var selectedAnnotationTitle = ""
    
    init() {
        refresh()
    }
    
    func refresh() {
        allFrogsList = CoreDataHandler.fetchAllFrogs()
        
        if(allFrogsList.count == 0) {
            CoreDataHandler.addAllFrogRecordsToDatabase()
            allFrogsList = CoreDataHandler.fetchAllFrogs()
        }
    }
    
    func getFrogByName(commonName: String?) -> FrogEntity {
        var foundFrog: FrogEntity!
        for frog in allFrogsList {
            if frog.cname == commonName {
                foundFrog = frog
            }
        }
        return foundFrog
    }
    
}
