//
//  SpotLightEntity+CoreDataProperties.swift
//  TabView
//
//  Created by Varma on 19/05/20.
//  Copyright © 2020 Varma. All rights reserved.
//
//

import Foundation
import CoreData


extension SpotLightEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SpotLightEntity> {
        return NSFetchRequest<SpotLightEntity>(entityName: "SpotLightEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var home: Bool
    @NSManaged public var frogList: Bool
    @NSManaged public var frogdetails: Bool
    @NSManaged public var identity: Bool
    @NSManaged public var location: Bool
    @NSManaged public var news: Bool
    @NSManaged public var challenges: Bool

}
