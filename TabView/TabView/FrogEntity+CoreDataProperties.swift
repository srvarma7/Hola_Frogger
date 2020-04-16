//
//  FrogEntity+CoreDataProperties.swift
//  TabView
//
//  Created by Varma on 15/04/20.
//  Copyright © 2020 Varma. All rights reserved.
//
//

import Foundation
import CoreData


extension FrogEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FrogEntity> {
        return NSFetchRequest<FrogEntity>(entityName: "FrogEntity")
    }

    @NSManaged public var cname: String?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var isVisited: Bool
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var sname: String?
    @NSManaged public var threatnedStatus: String?
    @NSManaged public var uncertainty: Int16

}
