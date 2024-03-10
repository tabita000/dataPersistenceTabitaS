//
//  ViewController.swift
//  dataPersistenceTabitaS
//
//  Created by Tabita Sadiq on 3/8/24.
//

import UIKit
import Foundation
import CoreData

class ViewController: UIViewController {
    var dataManager : NSManagedObjectContext!
    var listArray = [NSManagedObject]()
    
    
    
    @IBAction func saveEntry(_ sender: UIButton) {
        
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: "Item", into: dataManager)
        newEntity.setValue(newEntry.text, forKey: "journalEntry")
        newEntity.setValue(dateSelected.date, forKey: "entryDate")
        
        do{
            try self.dataManager.save()
            listArray.append(newEntity)
        } catch{
            print("Error saving Data")
        }
        displayPerviousEntry.text?.removeAll()
        newEntry.text?.removeAll()
        fetchData()
        
    }
    
    @IBAction func deleteEntry(_ sender: UIButton) {
        let deleteItem = newEntry.text!
        for item in listArray {
            if item.value(forKey: "journalEntry") as! String == deleteItem {
                dataManager.delete(item)
            }
            do {
                try self.dataManager.save()
            }catch {
                print("Error deleting data")
            }
            displayPerviousEntry.text?.removeAll()
            newEntry.text?.removeAll()
            fetchData()
        }
    }
    
    
    @IBOutlet weak var newEntry: UITextView!
    
    
    @IBOutlet weak var displayPerviousEntry: UILabel!
    
    
    
    @IBOutlet weak var dateSelected: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelgate = UIApplication.shared.delegate as! AppDelegate
        dataManager = appDelgate.persistentContainer.viewContext
        displayPerviousEntry.text?.removeAll()
        fetchData()
        
    }
    
    func fetchData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Item")
        do {
            let result = try dataManager.fetch(fetchRequest)
            listArray = result as! [NSManagedObject]
            displayPerviousEntry.text = ""
            
            for item in listArray {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .none
                if let entryDate = item.value(forKey: "entryDate") as? Date,
                   let journalEntry = item.value(forKey: "journalEntry") as? String {
                    let dateString = dateFormatter.string(from: entryDate)
                    displayPerviousEntry.text! += "\(dateString): \(journalEntry)\n"
                }
            }
        } catch {
            print("Error retrieving Data")
        }
    }
}
