//
//  HistoryViewController.swift
//  BLBWaterTracker
//
//  Created by Nirwan Ramdani on 24/04/21.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {
    
    
    @IBOutlet weak var tblHistory: UITableView!
    
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var group = [String:Int]()
    var activities = [DailyActivity]()
    var statUpdate = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblHistory.dataSource = self
        tblHistory.delegate = self

        managedObjectContext = appDelegate?.persistentContainer.viewContext as! NSManagedObjectContext
        
        loadHistory()
        groupingHistory()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadHistory()
        groupingHistory()
    }
    
    func groupingHistory() {
        //if group.isEmpty {
            for activity in activities {
                let time = activity.timestamp?.formatDate()
                let litre : Int = Int(activity.usage)
                if !group.keys.contains(time!) {
                    //print(time!, "Masuk Pertama")
                    group.updateValue(Int(litre), forKey: time!)
                } else {
                    if let litreBefore = group[time!] {
                        let litreNow = litreBefore + litre
                        
                        group.updateValue(litreNow, forKey: time!)
                        //print(time!, "Update isi menjadi", litreNow)
                    }
                }
            }
        //}
        
        tblHistory.reloadData()
        
        //print(Array(group.keys.sorted())[0])
        
        //print(group.keys.sorted())
    }
    
    func loadHistory() {
        let activityRequest : NSFetchRequest<DailyActivity> = DailyActivity.fetchRequest()
        
        do {
            try activities = managedObjectContext.fetch(activityRequest)
            group = [String:Int]()
        } catch {
            print("Could not load data")
        }
    }
    
    
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        group.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        cell = UITableViewCell(style: .value1, reuseIdentifier: "historyCell")
        
        cell.textLabel?.text = "\(Array(group.keys.sorted())[indexPath.row])"
        cell.detailTextLabel?.text = "\(Array(group.values.sorted())[indexPath.row]) Liter"
        
        return cell
    }
    
}
