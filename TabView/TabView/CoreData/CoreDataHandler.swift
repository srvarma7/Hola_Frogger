 //
//  CoreDataHandler.swift
//  TabView
//
//  Created by Varma on 15/04/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHandler: NSObject {
    
    private class func getContect() -> NSManagedObjectContext{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return context
    }
    
    //MARK:- Save new FROG
    class func saveFrog(sname: String, cname: String, latitude: Double, longitude: Double, uncertainty: Int, threatnedStatus: String, isVisited: Bool, isFavourite: Bool) {
        let context = getContect()
        let entity = NSEntityDescription.entity(forEntityName: "FrogEntity", in: context)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(sname, forKey: "sname")
        managedObject.setValue(cname, forKey: "cname")
        managedObject.setValue(latitude, forKey: "latitude")
        managedObject.setValue(longitude, forKey: "longitude")
        managedObject.setValue(uncertainty, forKey: "uncertainty")
        managedObject.setValue(threatnedStatus, forKey: "threatnedStatus")
        managedObject.setValue(isVisited, forKey: "isVisited")
        managedObject.setValue(isFavourite, forKey: "isFavourite")
        
        do {
            try context.save()
            print("Saved entry")
        } catch {
            print(error , "Error while adding data in CoreDataHandler")
        }
    }
    
    //MARK:- Fetch all Frog Details
    class func fetchObject() -> [FrogEntity] {
        let context = getContect()
        var frogs: [FrogEntity] = []
        do {
            frogs = try context.fetch(FrogEntity.fetchRequest())
        } catch {
            print(error, "Error while fetching data in CoreDataHandler")
        }
        return frogs
    }
    
    //MARK:- Save new FROG
    class func updateFrog(frog: FrogEntity, sname: String, cname: String, latitude: Double, longitude: Double, uncertainty: Int, threatnedStatus: String, isVisited: Bool, isFavourite: Bool) {
        
        let context = getContect()
        frog.sname = sname
        frog.cname = cname
        frog.latitude = latitude
        frog.longitude = longitude
        frog.uncertainty = Int16(uncertainty)
        frog.threatnedStatus = threatnedStatus
        frog.isVisited = isVisited
        frog.isFavourite = isFavourite
        
        do {
            try context.save()
            print("Updated entry")
        } catch {
            print(error , "Error while updating data in CoreDataHandler")
        }
    }
    
 }
