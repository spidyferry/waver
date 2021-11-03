//
//  OnBoarding_2.swift
//  BLBWaterTracker
//
//  Created by Nirwan Ramdani on 30/04/21.
//

import UIKit

class OnBoarding_2: UIViewController {
    
    @IBOutlet weak var reminderTable: UITableView!
    @IBOutlet weak var viewPicker: UIView!
    @IBOutlet weak var bgViewPicker: UIView!
    @IBOutlet weak var reminderPicker: UIPickerView!
    
    let reminderOptions = ["Don't Remind Me", "Every Hour", "Every 3 Hour", "Once a Day"]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        reminderTable.dataSource  = self
        reminderTable.delegate = self
        
        reminderPicker.dataSource = self
        reminderPicker.delegate = self
    }
    

}

extension OnBoarding_2: UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderConfCell", for: indexPath)
        cell.textLabel?.text = "Remind Me"
        return cell
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reminderOptions.count
    }
    
    
}
