//
//  Configuration+CoreDataProperties.swift
//  BLBWaterTracker
//
//  Created by Nirwan Ramdani on 24/04/21.
//
//

import Foundation
import CoreData


extension Configuration {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Configuration> {
        return NSFetchRequest<Configuration>(entityName: "Configuration")
    }

    @NSManaged public var id: Int16
    @NSManaged public var activityName: String?
    @NSManaged public var option: Int16

}

extension Configuration : Identifiable {

}
