//
//  OnBoarding.swift
//  BLBWaterTracker
//
//  Created by Nirwan Ramdani on 28/04/21.
//

import UIKit
import CoreData

class OnBoarding: UIViewController {
    
    let startState = UserDefaults.standard
    
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    let activityName = ["Bath", "Laundry", "Dishwashing", "Car Cleaning", "Motorcycle Cleaning", "Brushing Teeth", "Washing Hand", "Washing Face", "Watering Plant", "Ablution"]
    
    var settings = [Configuration]()

    override func viewDidLoad() {
        super.viewDidLoad()

        managedObjectContext = appDelegate?.persistentContainer.viewContext as! NSManagedObjectContext
        
        if startState.bool(forKey: "First Launch") == true {
            //print("Second")
            startState.set(true, forKey: "First Launch")
            //print(settings[0].activityName)
        } else {
            //print("First")
            setUserDefault()
            startState.set(true, forKey: "First Launch")
        }
    }
    
    func setUserDefault() {
        var id = 1
        
        for name in activityName {
            let entity = NSEntityDescription.entity(forEntityName: "Configuration", in: managedObjectContext)
            let entityNew = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
            
            entityNew.setValue(id, forKey: "id")
            entityNew.setValue(name, forKey: "activityName")
            entityNew.setValue(1, forKey: "option")
            
            do {
                try managedObjectContext.save()
                print("save", entityNew)
                id += 1
            } catch let error as NSError {
                print("could not save", error)
            }
        }
    }

}
