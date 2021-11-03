//
//  ViewController.swift
//  BLBWaterTracker
//
//  Created by Nirwan Ramdani on 24/04/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var activityPicker: UIPickerView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var tblActivity: UITableView!
    @IBOutlet weak var VPicker: UIView!
    @IBOutlet weak var bgView: UIView!
    
    //let startState = UserDefaults.standard
    
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var settings = [Configuration]()
    var activities = [DailyActivity]()
    var selectedActivity = 0
    var selectedOption = 0
    var selectedActName = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        activityPicker.dataSource = self
        activityPicker.delegate = self
        
        tblActivity.dataSource = self
        tblActivity.delegate = self
        
        managedObjectContext = appDelegate?.persistentContainer.viewContext as! NSManagedObjectContext
        
        //getConfig()
        loadActivity()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        settings = [Configuration]()
        selectedActivity = 0
        selectedOption = 0
        selectedActName = ""
        getConfig()
    }
    
    func getConfig() {
        let configReq : NSFetchRequest<Configuration> = Configuration.fetchRequest()
        let sortName = NSSortDescriptor(key: "activityName", ascending: true)
        
        configReq.sortDescriptors = [sortName]
        do {
            try settings = managedObjectContext.fetch(configReq)
            activityPicker.reloadAllComponents()
        } catch {
            print("Could not load data")
        }
    }
    
    func checkUsage(id : Int, option : Int) -> Int {
            var waterUse = 0
            switch id {
            case 1: //Bath
                switch option {
                case 1: //Shower
                    waterUse = 100
                case 2: //Manual
                    waterUse = 60
                case 3: //Bathtub
                    waterUse = 190
                default:
                    waterUse = 0
                }
            case 2: //Laundry
                switch option {
                case 1: // manual
                    waterUse = 23
                case 2: // mesin
                    waterUse = 150
                default:
                    waterUse = 0
                }
            case 3: //Dishwashing
                switch option {
                case 1: // manual
                    waterUse = 90
                case 2: // mesin
                    waterUse = 150
                default:
                    waterUse = 0
                }
            case 4: //Car Cleaning
                switch option {
                case 1: // not selected
                    waterUse = 0
                case 2: // Pressure water
                    waterUse = 150
                case 3: // manual washing
                    waterUse = 300
                default:
                    waterUse = 0
                }
            case 5: //Motorcycle Cleaning
                switch option {
                case 1: // not selected
                    waterUse = 0
                case 2: // Pressure water
                    waterUse = 100
                case 3: // manual cleaning
                    waterUse = 200
                default:
                    waterUse = 0
                }
            case 6: waterUse = 6
            case 7: waterUse = 6
            case 8: waterUse = 6
            case 9: waterUse = 10
            case 10: waterUse = 7
            default:
                waterUse = 0
            }
            
            return waterUse
        }
    
    func getMaxId() -> Int {
        var backId = 0
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DailyActivity")
        
        fetchRequest.fetchLimit = 1
        let sortDesc = NSSortDescriptor(key: "id", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDesc]
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest) as! [DailyActivity]
            if (results.count > 0) {
                for result in results {
                   backId = Int(result.id)
                }
            }
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        return backId
    }
    
    func saveActivity() {
        let entity = NSEntityDescription.entity(forEntityName: "DailyActivity", in: managedObjectContext)
        let entityNew = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
        
        entityNew.setValue(getMaxId()+1, forKey: "id")
        entityNew.setValue(selectedActName, forKey: "activityName")
        entityNew.setValue(checkUsage(id: selectedActivity, option: selectedOption), forKey: "usage")
        entityNew.setValue(Date(), forKey: "timestamp")

        do {
            try managedObjectContext.save()
//            delegate?.didUpdate(status: true)
            //print("save", entityNew)
        } catch let error as NSError {
            print("could not save", error)
        }
    }
    
    func loadActivity() {
        let fetchRequest : NSFetchRequest<DailyActivity> = DailyActivity.fetchRequest()
        
        let calendar = Calendar.current
        
        //Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: Date()) // eg. 2016-10-10 00:00:00
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
        
        // Set predicate as date being today's date
        let datePredicate = NSPredicate(format: "timestamp >= %@ AND timestamp < %@", dateFrom as! NSDate, dateTo as! NSDate)
        
        fetchRequest.predicate = datePredicate
        
        do {
            try activities = managedObjectContext.fetch(fetchRequest)
            
//            for activity in activities {
//                print(activity.activityName!)
//                print(activity.timestamp!)
//            }
        } catch {
            print("Could not load data")
        }
        
        self.tblActivity.reloadData()
    }
    
    func deleteActivity(id : Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DailyActivity")
        
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        
        do {
            let objects = try managedObjectContext.fetch(fetchRequest)
            let objectToBeDeleted = objects[0] as! NSManagedObject
            managedObjectContext.delete(objectToBeDeleted)
            do {
                try managedObjectContext.save()
                //delegate?.didUpdate(status: true)
            }catch let error as NSError {
                print("could not delete", error)
            }
        } catch {
            print("error saving after deletion")
        }
        
        loadActivity()
    }
    
    @IBAction func tapShowPicker(_ sender: Any) {
        //VPicker.isHidden = false
        self.activityPicker.selectRow(0, inComponent: 0, animated: true)
        self.pickerView(activityPicker, didSelectRow: 0, inComponent: 0)
        UIView.transition(with: VPicker, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.VPicker.isHidden = false
            })
        self.tabBarController?.tabBar.isHidden = true
        bgView.alpha = 1
        //saveActivity()
        //loadActivity()
    }
    
    @IBAction func cancelPicker(_ sender: Any) {
        VPicker.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        bgView.alpha = 0
    }
    
    @IBAction func donePicker(_ sender: Any) {
        VPicker.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        bgView.alpha = 0
        saveActivity()
        loadActivity()
    }
    
    
    

}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return settings.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        settings[row].activityName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedActName = settings[row].activityName!
        selectedActivity = Int(settings[row].id)
        selectedOption = Int(settings[row].option)
        //print(selectedActivity, selectedOption)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)
        cell = UITableViewCell(style: .value1, reuseIdentifier: "activityCell")
        
        let activityData = activities[indexPath.row]
        
        cell.textLabel?.text = "\(activityData.activityName ?? "") - \(activityData.usage) Liter"
        cell.detailTextLabel?.text = "\(activityData.timestamp?.formatTime() ?? "")"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let refreshAlert = UIAlertController(title: "", message: "Would you like to delete this activity?", preferredStyle: UIAlertController.Style.actionSheet)

            refreshAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [self] (action: UIAlertAction!) in
                tableView.beginUpdates()
                let thingToDelete = self.activities[indexPath.row]
                self.deleteActivity(id: Int(thingToDelete.id))
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }))

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                  //print("Handle Cancel Logic here")
            }))

            present(refreshAlert, animated: true, completion: nil)
        }
    }
}

extension Date {
    func formatTime() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "HH:mm"
        
        return dateFormatterPrint.string(from: self)
    }
    
    func formatDate() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy"
        
        return dateFormatterPrint.string(from: self)
    }
}

