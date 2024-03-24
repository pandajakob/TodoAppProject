//
//  Task+CoreDataProperties.swift
//  TodoListProject
//
//  Created by Jakob Michaelsen on 10/03/2024.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var name: String?
    @NSManaged public var completed: Bool
    @NSManaged public var dueDate: Date?
    @NSManaged public var doneDate: Date?
    @NSManaged public var taskGroup: TaskGroup?
    @NSManaged public var repeated: Bool

  
    var uwName: String {
        name ?? ""
    }
    var uwDueDate: Date {
        dueDate ?? Date()
    }
    var uwDoneDate: Date {
        doneDate ?? Date()
    }
    
    var fmDueDate: String {
        let df = StringFormat.dateFormatter
        let dateString = df.string(from: uwDueDate)
        return dateString
    }
    
    var fmDoneDate: String {
        let df = StringFormat.dateFormatter
        let dateString = df.string(from: uwDoneDate)

        return dateString
    }
}

extension Task : Identifiable {

}
