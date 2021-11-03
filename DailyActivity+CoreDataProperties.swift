//
//  DailyActivity+CoreDataProperties.swift
//  BLBWaterTracker
//
//  Created by Nirwan Ramdani on 29/04/21.
//
//

import Foundation
import CoreData


extension DailyActivity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyActivity> {
        return NSFetchRequest<DailyActivity>(entityName: "DailyActivity")
    }

    @NSManaged public var activityName: String?
    @NSManaged public var id: Int16
    @NSManaged public var timestamp: Date?
    @NSManaged public var usage: Int16

}

extension DailyActivity : Identifiable {

}
