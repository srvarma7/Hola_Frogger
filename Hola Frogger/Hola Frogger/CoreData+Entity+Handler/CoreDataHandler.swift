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
    class func saveFrog(entityName: String, sname: String, frogcount: Int, cname: String, desc: String, latitude: Double, longitude: Double, uncertainty: Int, threatnedStatus: String, isVisited: Bool, isFavourite: Bool) {
        let context = getContect()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        managedObject.setValue(sname, forKey: "sname")
        managedObject.setValue(frogcount, forKey: "frogcount")
        managedObject.setValue(cname, forKey: "cname")
        managedObject.setValue(desc, forKey: "desc")
        managedObject.setValue(latitude, forKey: "latitude")
        managedObject.setValue(longitude, forKey: "longitude")
        managedObject.setValue(uncertainty, forKey: "uncertainty")
        managedObject.setValue(threatnedStatus, forKey: "threatnedStatus")
        managedObject.setValue(isVisited, forKey: "isVisited")
        managedObject.setValue(isFavourite, forKey: "isFavourite")
        
        do {
            try context.save()
//            print("Saved entry")
        } catch {
            print(error , "Error while adding data in CoreDataHandler")
        }
    }
    
    //MARK:- Save SpotLight
    class func saveSpotLight(entityName: String, home: Bool, frogList: Bool, frogdetails: Bool, identity: Bool, location: Bool, news: Bool, challenges: Bool, visited: Bool) {
        let context = getContect()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        managedObject.setValue("single", forKey: "id")
        managedObject.setValue(home, forKey: "home")
        managedObject.setValue(frogList, forKey: "frogList")
        managedObject.setValue(frogdetails, forKey: "frogdetails")
        managedObject.setValue(identity, forKey: "identity")
        managedObject.setValue(location, forKey: "location")
        managedObject.setValue(news, forKey: "news")
        managedObject.setValue(challenges, forKey: "challenges")
        managedObject.setValue(visited, forKey: "visited")

        do {
            try context.save()
            print("Saved entry")
        } catch {
            print(error , "Error while adding data in CoreDataHandler")
        }
    }
    
    class func addSpotLight() {
        CoreDataHandler.saveSpotLight(entityName: "SpotLightEntity", home: false, frogList: false, frogdetails: false, identity: false, location: false, news: false, challenges: false, visited: false)
    }
    
    class func fetchSpotLight() -> [SpotLightEntity] {
        let context = getContect()
        var spotLight: [SpotLightEntity] = []
        
        let request = NSFetchRequest<SpotLightEntity>(entityName: "SpotLightEntity")
        do {
            spotLight = try context.fetch(request)
        } catch {
            print(error, "Error while fetching data in CoreDataHandler")
        }
        return spotLight
    }
    
    class func updateSpotLight(attribute: String, boolean: Bool) {
//        print("UPDATING MAIN")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchReq: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "SpotLightEntity")
        fetchReq.predicate = NSPredicate(format: "id == %@", "single")
        do {
            let test = try context.fetch(fetchReq)
            
            let objUpdate = test.first as! NSManagedObject
            objUpdate.setValue(boolean, forKey: attribute)
            do {
                try context.save()
                print("UPDATE MAIN SUCCESSFUL")
            } catch {
                print(error , "Error while updating data in CoreDataHandler")
            }
        } catch {
            print(error, "Error while fetching data in CoreDataHandler")
        }
    }
    
    //MARK:- Fetch all Frog Details
    class func fetchAllFrogs() -> [FrogEntity] {
        let context = getContect()
        var frogs: [FrogEntity] = []
        do {
            frogs = try context.fetch(FrogEntity.fetchRequest())
        } catch {
            print(error, "Error while fetching data in CoreDataHandler")
        }
        return frogs
    }
    
    class func fetchAllUnsightedFrogs() -> [UnSightedFrogEntity] {
        let context = getContect()
        var frogs: [UnSightedFrogEntity] = []
        let request = NSFetchRequest<UnSightedFrogEntity>(entityName: "UnSightedFrogEntity")
        let descriptors = [NSSortDescriptor(key: "isVisited", ascending: true)]
        request.sortDescriptors = descriptors
        do {
            frogs = try context.fetch(request)
        } catch {
            print(error, "Error while fetching data in CoreDataHandler")
        }
        return frogs
    }
    
    // fetches only frogs which are favourite.
    class func fetchOnlyFav() -> [FrogEntity] {
        let context = getContect()
        var favFrogs: [FrogEntity] = []
        
        let request = NSFetchRequest<FrogEntity>(entityName: "FrogEntity")
        let sort = NSSortDescriptor(key: "cname", ascending: true)
        // Filter for getting only favourites.
        let predicate = NSPredicate(format: "isFavourite == %@", NSNumber(value: true))
        request.predicate = predicate
        request.sortDescriptors = [sort]
        do {
            favFrogs = try context.fetch(request)
        } catch {
            print(error, "Error while fetching data in CoreDataHandler")
        }
        return favFrogs
    }
    
    class func fetchSpecificFrog(frogname: String) -> FrogEntity {
        let context = getContect()
        var frog: [FrogEntity] = []
        
        let request = NSFetchRequest<FrogEntity>(entityName: "FrogEntity")
        let sort = NSSortDescriptor(key: "cname", ascending: true)
        // Filter for getting only favourites.
        let predicate = NSPredicate(format: "cname == %@", frogname)
        request.predicate = predicate
        request.sortDescriptors = [sort]
        do {
            frog = try context.fetch(request)
        } catch {
            print(error, "Error while fetching data in CoreDataHandler")
        }
        return frog.first!
    }
    
    /// Method to update frog's visited and favourite status
    class func updateFrog(frogCommonName: String, isVisited: Bool, isFavourite: Bool) {
//        print("UPDATING MAIN")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchReq: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "FrogEntity")
        fetchReq.predicate = NSPredicate(format: "cname == %@", frogCommonName)
        do {
            let test = try context.fetch(fetchReq)
            
            let objUpdate = test.first as! NSManagedObject
            objUpdate.setValue(isVisited, forKey: "isVisited")
            objUpdate.setValue(isFavourite, forKey: "isFavourite")
            do {
                try context.save()
                print("UPDATE MAIN SUCCESSFUL")
            } catch {
                print(error , "Error while updating data in CoreDataHandler")
            }
        } catch {
            print(error, "Error while fetching data in CoreDataHandler")
        }
    }
    
    
    class func updateUnSightedFrog(frogCommonName: String, isVisited: Bool, isFavourite: Bool) {
        print("UPDATING DUMMY")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchReq: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "UnSightedFrogEntity")
        fetchReq.predicate = NSPredicate(format: "cname == %@", frogCommonName)
        do {
            let test = try context.fetch(fetchReq)
            
            let objUpdate = test.first as! NSManagedObject
            objUpdate.setValue(isVisited, forKey: "isVisited")
            objUpdate.setValue(isFavourite, forKey: "isFavourite")
            do {
                try context.save()
                print("UPDATE DUMMY SUCCESSFUL")
            } catch {
                print(error , "Error while updating data in CoreDataHandler")
            }
        } catch {
            print(error, "Error while fetching data in CoreDataHandler")
        }
    }
    
    class func deleteRecordsByEntity(entityName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        print("IN DELETE METHOD WITH ENTITY \(entityName)")
        let context = appDelegate.persistentContainer.viewContext
        let fetchReq: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "UnSightedFrogEntity")
        fetchReq.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(fetchReq)
            for ele in result {
                guard let record = ele as? NSManagedObject else { continue }
                context.delete(record)
                do {
                    try context.save()
                } catch {
                    print(error , "Error while updating data in CoreDataHandler")
                }
            }
        } catch {
            print(error , "Error while updating data in CoreDataHandler")
        }
    }
    
    //MARK:- Save new FROG
    class func addAllFrogRecordsToDatabase() {
        
        let testingVisitStatus = true
        let testingFavouriteStatus = false
        
        CoreDataHandler.saveFrog(entityName: "FrogEntity", sname: "Crinia parinsignifera", frogcount: 319, cname: "Eastern Sign-bearing Froglet", desc: "Their physique is white, grainy or grey-skinned with marks which are black near their abdominal area. They can be of different colours such as clear brown, clear black, clear green, clear white, clear grey and clear red. They belong to woods or marshlands. The froglet habits swamps and ponds, and is often found under debris at the edge.", latitude: -37.7401, longitude: 141.091, uncertainty: 294, threatnedStatus: "Not endangered", isVisited: false, isFavourite: testingFavouriteStatus)
        
        CoreDataHandler.saveFrog(entityName: "FrogEntity", sname: "Crinia signifera", frogcount:2284, cname: "Eastern Common Froglet", desc: "Their physique is grainy white or grainy grey along with black marks near the belly.The colour of the ventral surface is similar to the dorsal surface, but mottled with white spots. They are found near water pools, streams, moist lands where they can take refuge. The frog is of extremely variable markings, with great variety usually found within confined populations.", latitude: -37.6803, longitude:140.972, uncertainty: 3, threatnedStatus: "Not endangered", isVisited: false, isFavourite: testingFavouriteStatus)


        CoreDataHandler.saveFrog(entityName: "FrogEntity", sname: "Geocrinia laevis", frogcount:4, cname: "Tasmanian Smooth Froglet", desc:"Their physique consists of grey, brown colour skin tone with red streaks and pink streaks near rear legs. They can be of different colours such as clear brown, clear red, clear white and clear grey. They can be found near woods, wet vegetation, shrubs and jungles.", latitude: -38.5081, longitude:142.989, uncertainty: 2600, threatnedStatus: "Not endangered", isVisited: false, isFavourite: testingFavouriteStatus)

        CoreDataHandler.saveFrog(entityName: "FrogEntity", sname: "Geocrinia victoriana", frogcount:54, cname: "Victorian Smooth Froglet", desc: "Their physique comprises of pink shades near legs along with the brown or grey coloured body. They can be of different colours such as clear brown, clear grey, clear black and clear white. They are found near woods on mountains. It is endemic to Australia.", latitude: -38.5878, longitude:143.194, uncertainty: 3300, threatnedStatus: "Not endangered", isVisited: testingVisitStatus, isFavourite: testingFavouriteStatus)

        CoreDataHandler.saveFrog(entityName: "FrogEntity", sname: "Limnodynastes dumerilii", frogcount:814, cname: "Eastern Banjo Frog", desc: "Noticeable bump on rear legs with faint streaks. They can be of different colours such as clear brown, clear black, clear yellow, clear white, clear grey. The species is native to eastern Australia. They will often be seen in large numbers after rain, and under the right conditions mass spawning can occur over just a few days.", latitude: -37.5801062537707, longitude:141.399294063581, uncertainty:5, threatnedStatus: "Not endangered", isVisited: testingVisitStatus, isFavourite: testingFavouriteStatus)

        CoreDataHandler.saveFrog(entityName: "FrogEntity", sname: "Limnodynastes peronii", frogcount:399, cname: "Striped Marsh Frog", desc: "They are identified by black streaks upon brown body colour of the physique. They belong to swamp-based areas engulfing freshwater sources. It is a common species in urban habitats.There are distinct darker stripes running down the frogs back, there is normally a paler mid-dorsal stripe running down the back.", latitude: -38.0634120712411, longitude:141.249360758943, uncertainty:5, threatnedStatus: "Not endangered", isVisited: testingVisitStatus, isFavourite: testingFavouriteStatus)

        CoreDataHandler.saveFrog(entityName: "FrogEntity", sname: "Limnodynastes tasmaniensis", frogcount:538, cname: "Spotted Marsh Frog", desc:"Their physique comprises of olive green and black coloured marks along with body colour ranging from brown shade to green coloured shade. They can be of different colours such as clear brown, clear green, clear red, clear white and clear yellow. They are found near marshlands, water pools, creeks.", latitude: -37.6057, longitude:141.697, uncertainty: 55, threatnedStatus: "Not endangered", isVisited: testingVisitStatus, isFavourite: testingFavouriteStatus)

        CoreDataHandler.saveFrog(entityName: "FrogEntity", sname: "Litoria ewingii", frogcount:1312, cname: "Southern Brown Tree Frog", desc: "Their physique comprises of light brown colours with dark spots. They can be of different colours such as clear brown, clear yellow and clear white. They are found near streams, moist areas, metropolitan areas. This is a species of tree frog native to Australia, most of southern Victoria, eastern South Australia, southern New South Wales.", latitude: -38.0411443719995, longitude:141.004402991516, uncertainty:10, threatnedStatus: "Not endangered", isVisited: testingVisitStatus, isFavourite: testingFavouriteStatus)

        CoreDataHandler.saveFrog(entityName: "FrogEntity", sname: "Litoria fallax", frogcount: 16, cname: "Eastern Dwarf Tree Frog", desc: "Their physique consists of green coloured skin tone with white streaks near the eyes. They can be of different colours such as clear orange, clear green, clear white and clear yellow. They are found near marshlands, metropolitan regions and streams.", latitude: -37.7533874511719, longitude:145.074683190501, uncertainty:65, threatnedStatus: "Not endangered", isVisited: testingVisitStatus, isFavourite: testingFavouriteStatus)

        CoreDataHandler.saveFrog(entityName: "FrogEntity", sname: "Litoria paraewingi", frogcount: 27, cname: "Plains Brown Tree Frog", desc: "The plains brown tree frog or Victorian frog is a species of frog in the family Pelodryadidae. It is endemic to Australia. Its natural habitats are subtropical or tropical dry forests, rivers, freshwater lakes, freshwater marshes, water storage areas, ponds, and canals and ditches.",latitude: -37.53, longitude:145.336, uncertainty: 65, threatnedStatus: "Not endangered", isVisited: testingVisitStatus, isFavourite: testingFavouriteStatus)

        CoreDataHandler.saveFrog(entityName: "FrogEntity", sname: "Litoria peronii", frogcount: 246, cname: "Peron's Tree Frog", desc:"Their physique comprises of light shades ranging from light greenish or light greyish to light red or light brownish along with dark and vivid yellow patterns on their armpits. They can be of different colours such as clear brown, clear black, clear yellow, clear green and clear grey.",latitude: -37.7238, longitude:142.015, uncertainty: 19, threatnedStatus: "Not endangered", isVisited: testingVisitStatus, isFavourite: testingFavouriteStatus)

        CoreDataHandler.saveFrog(entityName: "FrogEntity", sname: "Litoria raniformis", frogcount: 19, cname: "Growling Grass Frog", desc: "Their physique comprises of spots which are golden or brown coloured with body colour being vivid green. They can be of different colours such as clear brown, clear white, clear green and clear purple. They are found near slow-flowing streams.",latitude: -37, longitude:141.2, uncertainty:10000, threatnedStatus: "Endangered", isVisited: testingVisitStatus, isFavourite: testingFavouriteStatus)

        CoreDataHandler.saveFrog(entityName: "FrogEntity", sname: "Litoria verreauxii", frogcount: 71, cname: "Whistling Tree Frog", desc: "Their physique comprises of soft brown with darker shades near legs. They can be of different colours such as clear brown, clear green, clear grey and clear white. They are found near wet plantation areas. The alpine tree frog is restricted to the southern alps of New South Wales and Victoria.",latitude: -38.4184222863879, longitude:145.07485814356, uncertainty:24, threatnedStatus: "Not endangered", isVisited: testingVisitStatus, isFavourite: testingFavouriteStatus)

        CoreDataHandler.saveFrog(entityName: "FrogEntity", sname: "Neobatrachus sudellae", frogcount: 2, cname: "Common Spadefoot Toad", desc:"Their physique consists of yellow, brown, grey, green coloured skin tone with streaks along the back of their body. They are found near marshlands, metropolitan regions and streams. They can be found near arid regions, woods, roadside pools and bushes.",latitude: -38.0538, longitude:141.009, uncertainty:10, threatnedStatus: "Not endangered", isVisited: testingVisitStatus, isFavourite: testingFavouriteStatus)

        CoreDataHandler.saveFrog(entityName: "FrogEntity", sname: "Paracrinia haswelli", frogcount: 4, cname: "Red-groined Froglet", desc: "Their physique consists of light greyish and brown skin tone with dark and red streaks. They are found near open jungles, woods, bushes and streams. This species of frog reaches 30 mm in length. This frog varies from light grey brown, pale brown to red-brown above with some darker flecks.",latitude: -38.08226310771, longitude:145.806622128583, uncertainty:165, threatnedStatus: "Not endangered", isVisited: testingVisitStatus, isFavourite: testingFavouriteStatus)

        CoreDataHandler.saveFrog(entityName: "FrogEntity", sname: "Pseudophryne bibronii", frogcount: 6, cname: "Brown Toadlet", desc: "Their physique is granular black and mineral white near the belly along with an opaque brown or black coloured body. They can be of different colours such as clear brown, clear black, clear white and clear grey. They are found near woods, rocks, streams.",latitude: -37, longitude:141.7, uncertainty:10000, threatnedStatus: "Endangered", isVisited: testingVisitStatus, isFavourite: testingFavouriteStatus)

        CoreDataHandler.saveFrog(entityName: "FrogEntity", sname: "Pseudophryne dendyi", frogcount: 1, cname: "Dendy's Toadlet", desc: "Their physique consists of opaque brown with yellow shades underarms. They can be of different colours such as clear brown, clear white, clear black and clear yellow. They are found near woods. Its natural habitats are temperate forests, temperate grassland, rivers, intermittent rivers, swamps, and intermittent freshwater marshes. It is endemic to Australia.",latitude: -36.7034432572836, longitude:147.921584784843, uncertainty:6, threatnedStatus: "Endangered", isVisited: testingVisitStatus, isFavourite: testingFavouriteStatus)

        CoreDataHandler.saveFrog(entityName: "FrogEntity", sname: "Pseudophryne semimarmorata", frogcount: 8, cname: "Southern Toadlet", desc: "Their physique comprises of rough black and mineral white along with darker green and darker brown body with vivid orange or yellow shades on the belly side. They can be of different colours such as clear brown, clear green, clear black, clear white and clear orange. They are found near damp areas.",latitude: -37.9661880384892, longitude:145.263331896779, uncertainty:1414, threatnedStatus: "Vulnerable", isVisited: testingVisitStatus, isFavourite: testingFavouriteStatus)
        
        print("Saved frog records to core data")
    }
 }
