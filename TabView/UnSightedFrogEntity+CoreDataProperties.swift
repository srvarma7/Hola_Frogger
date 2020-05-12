//
//  UnSightedFrogEntity+CoreDataProperties.swift
//  TabView
//
//  Created by Varma on 12/05/20.
//  Copyright © 2020 Varma. All rights reserved.
//
//

import Foundation
import CoreData


extension UnSightedFrogEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UnSightedFrogEntity> {
        return NSFetchRequest<UnSightedFrogEntity>(entityName: "UnSightedFrogEntity")
    }

    @NSManaged public var cname: String?
    @NSManaged public var sname: String?
    @NSManaged public var desc: String?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var isVisited: Bool
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var uncertainty: Int16
    @NSManaged public var frogcount: Int16
    @NSManaged public var threatnedStatus: String?

}
