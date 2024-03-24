//
//  TaskGroup+CoreDataProperties.swift
//  TodoListProject
//
//  Created by Jakob Michaelsen on 10/03/2024.
//
//

import Foundation
import CoreData


extension TaskGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskGroup> {
        return NSFetchRequest<TaskGroup>(entityName: "TaskGroup")
    }

    @NSManaged public var groupDate: Date?
    @NSManaged public var tasks: NSSet?
    
    
    var uwGroupDate: Date {
        groupDate ?? Date()
    }
    
    var uwTasks: [Task] {
        let set = tasks as? Set<Task> ?? []
        
        return Array(set).sorted(by: {$0.uwName < $1.uwName })
    }
    
    var compTasks: [Task] {
        let tasks = uwTasks.filter { Task in
            Task.completed == true
        }
        return tasks
    }
    
    var fmDueDate: String {
        let df = StringFormat.dateFormatter
        let dateString = df.string(from: uwGroupDate)
        return dateString
    }
    
    

}

// MARK: Generated accessors for tasks
extension TaskGroup {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Task)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Task)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}

extension TaskGroup : Identifiable {

}
