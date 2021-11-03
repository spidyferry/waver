//
//  SettingViewController.swift
//  BLBWaterTracker
//
//  Created by Nirwan Ramdani on 24/04/21.
//

import UIKit
import CoreData

class SettingViewController: UIViewController {
    
    @IBOutlet weak var usageConfigTable: UITableView!
    @IBOutlet weak var viewPicker: UIView!
    @IBOutlet weak var pickerOption: UIPickerView!
    @IBOutlet weak var bgViewPicker: UIView!
    
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    let activity_name = ["Bath", "Laundry", "Dishwashing", "Car Cleaning", "Motorcycle Cleaning", "Brushing Teeth", "Washing Hand", "Washing Face", "Watering Plant", "Ablution"]
    var options: [String] = []
    var valOptions: [Int16] = []
    
    var config = [Configuration]()
    
    var selectedOption = 0
    var idOption:Int16 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usageConfigTable.dataSource = self
        usageConfigTable.delegate = self
        
        pickerOption.dataSource = self
        pickerOption.delegate = self
        
        managedObjectContext = appDelegate?.persistentContainer.viewContext as! NSManagedObjectContext
        
        getAllConfig()
    }
    

    func getAllConfig() {
        let configRequest: NSFetchRequest<Configuration> = Configuration.fetchRequest()

        do {
            try config =  managedObjectContext.fetch((configRequest))
        } catch {
            print("Could not load data")
        }
        
        print(config[0].activityName!)

        self.usageConfigTable.reloadData()
    }
    
    func saveOption(){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Configuration")
        fetchRequest.predicate = NSPredicate(format: "id = %d", idOption)
                
        do {
            let objects = try managedObjectContext.fetch(fetchRequest)
            let objectToUpdate = objects[0] as! NSManagedObject
            objectToUpdate.setValue(selectedOption , forKey: "option")
            
            do {
                try managedObjectContext.save()
            }catch let error as NSError {
                print("could not update", error)
            }
        } catch {
            print("error saving data")
        }
    }
    
    func getOption(id: Int) {
        options = []
        valOptions = []
        switch id {
        case 1: //Bath
            options = ["Shower", "Non Shower", "Bathtub"]
            valOptions = [1, 2, 3]
        case 2: //Laundry
            options = ["Hand Washing (Manual)", "Washing Machine"]
            valOptions = [1, 2]
        case 3: //Dishwashing
            options = ["Hand Washing (Manual)", "Dish Washer"]
            valOptions = [1, 2]
        case 4: //Car Cleaning
            options = ["Not Selected", "Pressure Cleaner", "Manual Washing"]
            valOptions = [1, 2, 3]
        case 5: //Motorcycle Cleaning
            options = ["Not Selected", "Pressure Cleaner", "Manual Washing"]
            valOptions = [1, 2, 3]
        
        default:
            options = []
            valOptions = []
        }
    }
    
    func getOptionName(id: Int, option: Int) -> String {
        var optName = ""
        switch id {
        case 1: //Bath
            switch option {
            case 1: //Shower
                optName = "Shower"
            case 2: //Manual
                optName = "Non Shower"
            case 3: //Bathtub
                optName = "Bathtub"
            default:
                optName = ""
            }
        case 2: //Laundry
            switch option {
            case 1: // manual
                optName = "Hand Washing"
            case 2: // mesin
                optName = "Washing Machine"
            default:
                optName = ""
            }
        case 3: //Dishwashing
            switch option {
            case 1: // manual
                optName = "Hand Washing (Manual)"
            case 2: // mesin
                optName = "Washing Machine"
            default:
                optName = ""
            }
        case 4: //Car Cleaning
            switch option {
            case 1: // not selected
                optName = "Not Selected"
            case 2: // Pressure water
                optName = "Pressure Water"
            case 3: // manual washing
                optName = "Manual Washing"
            default:
                optName = ""
            }
        case 5: //Motorcycle Cleaning
            switch option {
            case 1: // not selected
                optName = "Not Selected"
            case 2: // Pressure water
                optName = "Pressure Water"
            case 3: // manual washing
                optName = "Manual Washing"
            default:
                optName = ""
            }
        default:
            optName = ""
        }
        
        return optName
    }
    
    @IBAction func cancelToolBar(_ sender: Any) {
        viewPicker.isHidden = true
        bgViewPicker.alpha = 0
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func doneToolBar(_ sender: Any) {
        viewPicker.isHidden = true
        bgViewPicker.alpha = 0
        saveOption()
        usageConfigTable.reloadData()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    

}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "waterUsageConfCell", for: indexPath)
        let configData = config[indexPath.row]
        cell.textLabel?.text = "\(configData.activityName!)"
        cell.detailTextLabel?.text = "\(getOptionName(id: Int(configData.id), option: Int(configData.option)))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let configData = config[indexPath.row]
        let idActivityConf = configData.id
        
        idOption = idActivityConf
        
        getOption(id: Int(idOption))
        self.tabBarController?.tabBar.isHidden = true
        UIView.transition(with: viewPicker, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.pickerOption.reloadAllComponents()
            self.viewPicker.isHidden = false
            })
        bgViewPicker.alpha = 1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOption = Int(valOptions[row])
    }
    
}
