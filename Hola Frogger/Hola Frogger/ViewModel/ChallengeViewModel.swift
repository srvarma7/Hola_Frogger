//
//  ChallengeViewModel.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 27/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import Foundation

class ChallengeViewModel {
    
    var frogsList           = [FrogEntity]()
    var unsightedFrogsList  = [UnSightedFrogEntity]()
      
    private let numberOfFrogsInChallengeFlag: Int = 3
    
    init() {
        getAllRecords()
    }
    
    private func getAllRecords() {
        getFrogsList()
    }
    
    private func getFrogsList() {
        frogsList = CoreDataHandler.fetchAllFrogs()
        if frogsList.count == 0 {
            CoreDataHandler.addAllFrogRecordsToDatabase()
            getFrogsList()
        }
        getUnsightedFrogsList()
    }
    
    func getUnsightedFrogsList() {
        unsightedFrogsList = CoreDataHandler.fetchAllUnsightedFrogs()
        if unsightedFrogsList.count == 0 {
            if checkAnyFrogsLeftToSight(in: true) {
                loadNewUnsightedFrogs()
            } else {
            }
        } else {
            // Check if any frogs left in challenge
            if checkAnyFrogsLeftToSight(in: false) {
                // Challenge are left
            } else {
                CoreDataHandler.deleteRecordsByEntity(entityName: "UnSightedFrogEntity")
                hardRefresh()
            }
        }
    }
    
    func checkAnyFrogsLeftToSight(in status: Bool) -> Bool {
        var flag: Bool = false
        if status {
            for frog in frogsList {
                if !frog.isVisited {
                    flag = true
                    return flag
                }
            }
        } else {
            for frog in unsightedFrogsList {
                if !frog.isVisited {
                    flag = true
                    return flag
                }
            }
        }
        return flag
    }
    
    func loadNewUnsightedFrogs() {
        CoreDataHandler.deleteRecordsByEntity(entityName: "UnSightedFrogEntity")
        var currentFlag = 0
        for frog in frogsList {
            if !frog.isVisited {
                if !(currentFlag >= numberOfFrogsInChallengeFlag) {
                    CoreDataHandler.saveFrog(entityName: "UnSightedFrogEntity",
                                             sname: frog.sname!, frogcount: Int(frog.frogcount),
                                             cname: frog.cname!, desc: frog.desc!,
                                             latitude: frog.latitude, longitude: frog.longitude,
                                             uncertainty: Int(frog.uncertainty), threatnedStatus: frog.threatnedStatus!,
                                             isVisited: frog.isVisited, isFavourite: frog.isFavourite)
                    
                    currentFlag += 1
                }
            }
        }
    }
    
    func updateFrogSightedStatus(frog: UnSightedFrogEntity, sightedStatus: Bool) {
            CoreDataHandler.updateFrog(frogCommonName: frog.cname!,
                                       isVisited: sightedStatus,
                                       isFavourite: frog.isFavourite)
            
            CoreDataHandler.updateUnSightedFrog(frogCommonName: frog.cname!,
                                                isVisited: sightedStatus,
                                                isFavourite: frog.isFavourite)
        hardRefresh()
    }
    
    func hardRefresh() {
        getFrogsList()
        getUnsightedFrogsList()
    }
    
    func statistics() -> (String, String) {
        var sighted: Int    = 0
        var unsighted: Int  = 0
        
        for frog in frogsList {
            if frog.isVisited {
                sighted += 1
            } else {
                unsighted += 1
            }
        }
        return (String(sighted), String(unsighted))
    }
    
    func getFrogByName(commonName: String?) -> UnSightedFrogEntity {
        var foundFrog: UnSightedFrogEntity!
        for frog in unsightedFrogsList {
            if frog.cname == commonName {
                foundFrog = frog
            }
        }
        return foundFrog
    }
    
    func getFrogForDetailsView(index: Int) -> FrogEntity {
        let commonName = unsightedFrogsList[index].cname
        var foundFrog: FrogEntity!
        for frog in frogsList {
            if frog.cname == commonName {
                foundFrog = frog
            }
        }
        return foundFrog
    }
    
}
