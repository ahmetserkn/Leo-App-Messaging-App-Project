//
//  Store+CoreDataProperties.swift
//  
//
//  Created by AhmetSerkan on 8.09.2019.
//
//

import Foundation
import CoreData


extension Store {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Store> {
        return NSFetchRequest<Store>(entityName: "Store")
    }

    @NSManaged public var username: String?
    @NSManaged public var key: Int16

}
