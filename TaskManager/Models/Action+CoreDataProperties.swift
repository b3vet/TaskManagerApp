//
//  Action+CoreDataProperties.swift
//  TaskManager
//
//  Created by Berke Üçvet on 18.03.2023.
//
//

import Foundation
import CoreData


extension Action {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Action> {
        return NSFetchRequest<Action>(entityName: "Action")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date?
    @NSManaged public var type: String?
    @NSManaged public var task: UserTask?
    
    public var wrappedDate: Date {
        timestamp ?? Date()
    }
    
}

extension Action : Identifiable {
    
}
