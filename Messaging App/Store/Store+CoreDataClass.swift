//
//  Store+CoreDataClass.swift
//  
//
//  Created by AhmetSerkan on 8.09.2019.
//
//

import Foundation
import UIKit
import CoreData

@objc(Store)
public class Store: NSManagedObject {
    
    class func createData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let storeEntity = NSEntityDescription.entity(forEntityName: "Store", in: managedContext)!
        let item = NSManagedObject(entity: storeEntity, insertInto: managedContext)
        item.setValue(0, forKey: "key")
        item.setValue("", forKey: "username")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not write username. \(error), \(error.userInfo)")
        }
    }
    
    class func retrieveData() -> String {
        var username = String()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return ""}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Store")
        
        do {
            
            let result = try managedContext.fetch(fetchRequest)
            
            if result.count == 0 {
                createData()
                return retrieveData()
            } else {
                for data in result as! [Store] {
                    username = data.username!
                }
            }
            
        } catch let error as NSError {
            print("Could not read username. \(error), \(error.userInfo)")
        }
        
        return username
    }
    
    class func updateData(username: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Store")
        fetchRequest.predicate = NSPredicate.init(format: "key==0")
        
        do {
            
            let test = try managedContext.fetch(fetchRequest)
            let objectUpdate = test.first as! NSManagedObject
            objectUpdate.setValue(username, forKey: "username")
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not write username. \(error), \(error.userInfo)")
            }
            
        } catch let error as NSError {
            print("Could not write username. \(error), \(error.userInfo)")
        }
    }
}
