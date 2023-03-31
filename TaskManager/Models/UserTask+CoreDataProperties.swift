//
//  UserTask+CoreDataProperties.swift
//  TaskManager
//
//  Created by Berke Üçvet on 31.03.2023.
//
//

import Foundation
import CoreData


extension UserTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserTask> {
        return NSFetchRequest<UserTask>(entityName: "UserTask")
    }

    @NSManaged public var currentlyDoing: Bool
    @NSManaged public var dailyGoal: Int32
    @NSManaged public var id: UUID?
    @NSManaged public var lastStart: Date?
    @NSManaged public var name: String
    @NSManaged public var totalDone: Int32
    @NSManaged public var doNotDisturb: Bool
    @NSManaged public var actions: NSSet?

    public var actionsArray: [Action] {
        actions?.allObjects as? [Action] ?? []
    }
    
    public var wrappedStartDate: Date {
        self.lastStart ?? Date()
    }
}

// MARK: Generated accessors for actions
extension UserTask {

    @objc(addActionsObject:)
    @NSManaged public func addToActions(_ value: Action)

    @objc(removeActionsObject:)
    @NSManaged public func removeFromActions(_ value: Action)

    @objc(addActions:)
    @NSManaged public func addToActions(_ values: NSSet)

    @objc(removeActions:)
    @NSManaged public func removeFromActions(_ values: NSSet)

}

extension UserTask : Identifiable {

}
