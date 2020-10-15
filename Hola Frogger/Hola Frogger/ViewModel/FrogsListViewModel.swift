//
//  FrogsListViewModel.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 13/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import Foundation

class FrogsListViewModel {
    
    var frogsList = [FrogEntity]()
    
    init() {
        frogsList = CoreDataHandler.fetchAllFrogs()
        if(frogsList.count == 0) {
            CoreDataHandler.addAllRecords()
            frogsList = CoreDataHandler.fetchAllFrogs()
        }
    }
    
}
