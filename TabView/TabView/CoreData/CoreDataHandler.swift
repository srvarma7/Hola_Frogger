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
    class func saveFrog(sname: String, frogcount: Int, cname: String, desc: String, latitude: Double, longitude: Double, uncertainty: Int, threatnedStatus: String, isVisited: Bool, isFavourite: Bool) {
        let context = getContect()
        let entity = NSEntityDescription.entity(forEntityName: "FrogEntity", in: context)
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
        let predicate = NSPredicate(format: "sname == %@", frogname)
        request.predicate = predicate
        request.sortDescriptors = [sort]
        do {
            frog = try context.fetch(request)
        } catch {
            print(error, "Error while fetching data in CoreDataHandler")
        }
        return frog.first!
    }
    
    // Method to update frogs favourite stauts
    class func updateFrog(frog: FrogEntity, isVisited: Bool, isFavourite: Bool) {
        
        let context = getContect()
        frog.isVisited = isVisited
        frog.isFavourite = isFavourite
        
        do {
            try context.save()
            print("Updated entry")
        } catch {
            print(error , "Error while updating data in CoreDataHandler")
        }
    }
    
    //MARK:- Save new FROG
    class func addAllRecords() {
        CoreDataHandler.saveFrog(sname: "Crinia parinsignifera", frogcount: 319, cname: "Eastern Sign-bearing Froglet", desc: "Their physique is white, grainy or grey-skinned with marks which are black near their abdominal area. They can be of different colours such as clear brown, clear black, clear green, clear white, clear grey and clear red. They belong to woods or marshlands. They serve on insects.", latitude: -37.7401, longitude: 141.091, uncertainty: 294, threatnedStatus: "Not endangered", isVisited: false, isFavourite: false)

        CoreDataHandler.saveFrog(sname: "Crinia signifera", frogcount:2284, cname: "Eastern Common Froglet", desc: "Their physique is grainy white or grainy grey along with black marks near the belly. They can be of different colours such as clear brown, clear black, clear green, clear grey, clear white and clear red. They are found near water pools, streams, moist lands where they can take refuge. They serve on insects.", latitude: -37.6803, longitude:140.972, uncertainty: 3, threatnedStatus: "Not endangered", isVisited: false, isFavourite: false)


        CoreDataHandler.saveFrog(sname: "Geocrinia laevis", frogcount:4, cname: "Tasmanian Smooth Froglet", desc:"Their physique consists of grey, brown colour skin tone with red streaks and pink streaks near rear legs. They can be of different colours such as clear brown, clear red, clear white and clear grey. They can be found near woods, wet vegetation, shrubs and jungles. They serve on insects.", latitude: -38.5081, longitude:142.989, uncertainty: 2600, threatnedStatus: "Not endangered", isVisited: false, isFavourite: false)


        CoreDataHandler.saveFrog(sname: "Geocrinia victoriana", frogcount:54, cname: "Victorian Smooth Froglet", desc: "Their physique comprises of pink shades near legs along with the brown or grey coloured body. They can be of different colours such as clear brown, clear grey, clear black and clear white. They are found near woods on mountains. They serve on insects.", latitude: -38.5878, longitude:143.194, uncertainty: 3300, threatnedStatus: "Not endangered", isVisited: false, isFavourite: false)


        CoreDataHandler.saveFrog(sname: "Limnodynastes dumerilii", frogcount:814, cname: "Eastern Banjo Frog", desc: "Noticeable bump on rear legs with faint streaks. They can be of different colours such as clear brown, clear black, clear yellow, clear white, clear grey. They belong to metropolitan jungle areas. They serve on insects.", latitude: -37.5801062537707, longitude:141.399294063581, uncertainty:5, threatnedStatus: "Not endangered", isVisited: false, isFavourite: false)


        CoreDataHandler.saveFrog(sname: "Limnodynastes peronii", frogcount:399, cname: "Striped Marsh Frog", desc: "They are identified by black streaks upon brown body colour of the physique. They belong to swamp-based areas engulfing freshwater sources. They serve on insects.", latitude: -38.0634120712411, longitude:141.249360758943, uncertainty:5, threatnedStatus: "Not endangered", isVisited: false, isFavourite: false)


        CoreDataHandler.saveFrog(sname: "Limnodynastes tasmaniensis", frogcount:538, cname: "Spotted Marsh Frog", desc:"Their physique comprises of olive green and black coloured marks along with body colour ranging from brown shade to green coloured shade. They can be of different colours such as clear brown, clear green, clear red, clear white and clear yellow. They are found near marshlands, water pools, creeks where they can take refuge. They serve on insects.", latitude: -37.6057, longitude:141.697, uncertainty: 55, threatnedStatus: "Not endangered", isVisited: false, isFavourite: false)


        CoreDataHandler.saveFrog(sname: "Litoria ewingii", frogcount:1312, cname: "Southern Brown Tree Frog", desc: "Their physique comprises of light brown colours with dark spots. They can be of different colours such as clear brown, clear yellow and clear white. They are found near streams, moist areas, metropolitan areas. They serve on insects.", latitude: -38.0411443719995, longitude:141.004402991516, uncertainty:10, threatnedStatus: "Not endangered", isVisited: false, isFavourite: false)


        CoreDataHandler.saveFrog(sname: "Litoria fallax", frogcount: 16, cname: "Eastern Dwarf Tree Frog", desc: "Their physique consists of green coloured skin tone with white streaks near the eyes. They can be of different colours such as clear orange, clear green, clear white and clear yellow. They are found near marshlands, metropolitan regions and streams. They serve on insects.", latitude: -37.7533874511719, longitude:145.074683190501, uncertainty:65, threatnedStatus: "Not endangered", isVisited: false, isFavourite: false)

        CoreDataHandler.saveFrog(sname: "Litoria paraewingi", frogcount: 27, cname: "Plains Brown Tree Frog", desc: "Their physique comprises of light brown shades along with dark spots. They can be of different colours such as clear brown, clear white and clear yellow. They are found near damp areas. They serve on insects.",latitude: -37.53, longitude:145.336, uncertainty: 65, threatnedStatus: "Not endangered", isVisited: false, isFavourite: false)


        CoreDataHandler.saveFrog(sname: "Litoria peronii", frogcount: 246, cname: "Peron's Tree Frog", desc:"Their physique comprises of light shades ranging from light greenish or light greyish to light red or light brownish along with dark and vivid yellow patterns on their armpits. They can be of different colours such as clear brown, clear black, clear yellow, clear green and clear grey. They belong to jungle habitats, open spaces, exposed grasslands. They serve on insects.",latitude: -37.7238, longitude:142.015, uncertainty: 19, threatnedStatus: "Not endangered", isVisited: false, isFavourite: false)



        CoreDataHandler.saveFrog(sname: "Litoria raniformis", frogcount: 19, cname: "Growling Grass Frog", desc: "Their physique comprises of spots which are golden or brown coloured with body colour being vivid green. They can be of different colours such as clear brown, clear white, clear green and clear purple. They are found near slow-flowing streams. They serve on insects.",latitude: -37, longitude:141.2, uncertainty:10000, threatnedStatus: "Endangered", isVisited: false, isFavourite: false)

        CoreDataHandler.saveFrog(sname: "Litoria verreauxii", frogcount: 71, cname: "Whistling Tree Frog", desc: "Their physique comprises of soft brown with darker shades near legs. They can be of different colours such as clear brown, clear green, clear grey and clear white. They are found near wet plantation areas. They serve on insects.",latitude: -38.4184222863879, longitude:145.07485814356, uncertainty:24, threatnedStatus: "Not endangered", isVisited: false, isFavourite: false)


        CoreDataHandler.saveFrog(sname: "Neobatrachus sudellae", frogcount: 2, cname: "Common Spadefoot Toad", desc:"Their physique consists of yellow, brown, grey, green coloured skin tone with streaks along the back of their body. They are found near marshlands, metropolitan regions and streams. They can be found near arid regions, woods, roadside pools and bushes. They serve on insects.",latitude: -38.0538, longitude:141.009, uncertainty:10, threatnedStatus: "Not endangered", isVisited: false, isFavourite: false)

        CoreDataHandler.saveFrog(sname: "Paracrinia haswelli", frogcount: 4, cname: "Red-groined Froglet", desc: "Their physique consists of light greyish and brown skin tone with dark and red streaks. They are found near open jungles, woods, bushes and streams. They serve on insects.",latitude: -38.08226310771, longitude:145.806622128583, uncertainty:165, threatnedStatus: "Not endangered", isVisited: false, isFavourite: false)

        CoreDataHandler.saveFrog(sname: "Pseudophryne bibronii", frogcount: 6, cname: "Brown Toadlet", desc: "Their physique is granular black and mineral white near the belly along with an opaque brown or black coloured body. They can be of different colours such as clear brown, clear black, clear white and clear grey. They are found near woods, rocks, streams. They serve on insects.",latitude: -37, longitude:141.7, uncertainty:10000, threatnedStatus: "Endangered", isVisited: false, isFavourite: true)

        CoreDataHandler.saveFrog(sname: "Pseudophryne dendyi", frogcount: 1, cname: "Dendy's Toadlet", desc: "Their physique consists of opaque brown with yellow shades underarms. They can be of different colours such as clear brown, clear white, clear black and clear yellow. They are found near woods. They serve on insects.",latitude: -36.7034432572836, longitude:147.921584784843, uncertainty:6, threatnedStatus: "Not endangered", isVisited: false, isFavourite: true)


        CoreDataHandler.saveFrog(sname: "Pseudophryne semimarmorata", frogcount: 8, cname: "Southern Toadlet", desc: "Their physique comprises of rough black and mineral white along with darker green and darker brown body with vivid orange or yellow shades on the belly side. They can be of different colours such as clear brown, clear green, clear black, clear white and clear orange. They are found near damp areas. They serve on insects.",latitude: -37.9661880384892, longitude:145.263331896779, uncertainty:1414, threatnedStatus: "Vulnerable", isVisited: false, isFavourite: true)
    }
 }
