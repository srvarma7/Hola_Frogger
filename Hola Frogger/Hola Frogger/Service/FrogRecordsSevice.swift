//
//  FrogRecordsSevice.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 22/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import Foundation

struct FrogRecordsSevice {
    
    static var frogsList = [FrogEntity]()

    static func getFrogs() -> [FrogEntity] {
        if frogsList.count == 0 {
            frogsList = CoreDataHandler.fetchAllFrogs()
            return frogsList
        }
        return frogsList
    }
}
