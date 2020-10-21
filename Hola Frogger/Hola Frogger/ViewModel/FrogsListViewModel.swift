//
//  FrogsListViewModel.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 13/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import Foundation

class FrogsListViewModel {
    
    var allFrogsList        = [FrogEntity]()
    var favouriteFrogsList  = [FrogEntity]()
    
    init() {
        refresh()
    }
    
    func refresh() {
        allFrogsList        = CoreDataHandler.fetchAllFrogs()
        favouriteFrogsList  = CoreDataHandler.fetchOnlyFav()
        if(allFrogsList.count == 0) {
            CoreDataHandler.addAllFrogRecordsToDatabase()
            allFrogsList        = CoreDataHandler.fetchAllFrogs()
            favouriteFrogsList  = CoreDataHandler.fetchOnlyFav()
        }
    }
    
    func updateFavouriteFrogsList() {
        favouriteFrogsList  = CoreDataHandler.fetchOnlyFav()
    }
    
}
