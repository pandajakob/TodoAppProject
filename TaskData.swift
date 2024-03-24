//
//  TaskData.swift
//  TodoListProject
//
//  Created by Jakob Michaelsen on 12/03/2024.
//

import Foundation
import CoreData

enum TaskFilter {
    case all
    case completed
}

class TaskData: ObservableObject {
    
    let container = NSPersistentContainer(name: "DataModel")
    @Published var savedData: [TaskGroup] = []
    
    @Published var taskFilter: TaskFilter = .all
    init() {
        container.loadPersistentStores { desc, error in
            
            if let error = error {
                print("failed to load data, error: \(error.localizedDescription)")
            }
            
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            // merges the data
        }
        fetchTaskGroups()
    }
    
    func fetchTaskGroups() {
        let request = NSFetchRequest<TaskGroup>(entityName: "TaskGroup")
        
        let datePredicate = NSPredicate(format: "groupDate > %@", NSDate())
        
        let nonEmptyPredicate = NSPredicate(format: "ANY tasks != nil")

        if taskFilter == .completed {
            let completedTasksPredicate = NSPredicate(format: "ANY tasks.completed == true")
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates:  [datePredicate, nonEmptyPredicate, completedTasksPredicate])
        } else {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates:  [datePredicate, nonEmptyPredicate])
            
        }

        request.sortDescriptors = [NSSortDescriptor(keyPath: \TaskGroup.groupDate, ascending: true)] // sorts b
        
        request.fetchLimit = 100 // only fetches 100 tasks
        
        do {
            let data = try container.viewContext.fetch(request)
            savedData = data
            
        } catch let error {
            print("Error getching. \(error)")
        }
    }
    
    func addTask(name: String, repeated: Bool, dates: Set<DateComponents>) {
        var dateCount = 0
        dates.forEach { day in
            dateCount += 1
          
            guard let uwDate = Calendar.current.date(from: day) else { return }
            
            let task = Task(context: container.viewContext)
            task.dueDate = uwDate
            task.name = name
            task.repeated = repeated
            
            print("date:", uwDate)
            
            if let dateGroup = savedData.first(where: {  Calendar.current.isDate(uwDate, inSameDayAs: $0.uwGroupDate)}) {
                
                    dateGroup.addToTasks(task)
                
            } else {
                
                let taskGroup = TaskGroup(context: container.viewContext)
                taskGroup.groupDate = uwDate
                taskGroup.addToTasks(task)
            }
            
        }
        save()
        fetchTaskGroups()
    }
    
    func repeatTask(repeatOption: RepeatOptions, name: String, rootDate: DateComponents) {

        guard let uwRootDate = rootDate.date else { return }
        
        var dates: [Date] = [uwRootDate]
        
        let taskDateLimit = Date().addYear(n: 20)
        
        var newDate: Date = Date()

            while newDate < taskDateLimit {
                switch repeatOption {
                case .never:
                    return
                case .daily:
                    newDate = Calendar.current.date(byAdding: .day, value: 1, to: newDate.self) ?? Date()
                    dates.append(newDate)
                    print(newDate)
                    
                case .weekly:
                    newDate = newDate.addWeek(n: 1)
                    dates.append(newDate)
                    print(newDate)
                    
                case .monthly:
                    newDate = newDate.addMonth(n: 1)
                    dates.append(newDate)
                    print(newDate)
                }
            }
        
        

        let newSet = dates.map { Date in
            Calendar.current.dateComponents([.day, .month, .year], from: Date)
        }
        newSet.forEach { dc in
            print("dc", Calendar.current.date(from: dc) ?? Date())
        }
        let firstHundred = newSet.prefix(101)
        
        addTask(name: name, repeated: true, dates: Set(firstHundred))
        
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                let rest = newSet.suffix(102)
                self.addTask(name: name, repeated: true, dates: Set(rest))

            }
        }
        
        
    }
    
    
    func removeTask(task: Task) {
        if let dateGroup = savedData.first(where: {  Calendar.current.isDate($0.uwGroupDate, inSameDayAs: task.uwDueDate)}) {
            dateGroup.removeFromTasks(task)
        }
        save()
        fetchTaskGroups()
    }
    
    
    func addTaskGroup(date: Date, task: Task) {
        let taskGroup = TaskGroup(context: container.viewContext)
        taskGroup.tasks = NSSet(array: [task])
        taskGroup.groupDate = date
        save()
        fetchTaskGroups()
    }
    
    
    func save() {
        do {
            try container.viewContext.save()
            print("data saved")
            
        }
        catch {
            print("failed to save data")
        }
    }
    
    
    func removeAllRepeated(task: Task) {
        var tasksToDelete: [Task] = []
        
        let request = NSFetchRequest<TaskGroup>(entityName: "TaskGroup")
        request.predicate = NSPredicate(format: "groupDate > %@", NSDate())
        
        do {
            let data = try container.viewContext.fetch(request)
            data.forEach { TaskGroup in
                tasksToDelete.append(contentsOf: TaskGroup.uwTasks.filter { Task in
                    Task.uwDueDate >= task.uwDueDate && Task.uwName == task.uwName
                })
            }
        } catch let error {
            print("Error fetching and deleting all data. \(error)")
        }
        
        tasksToDelete.forEach { t in
            container.viewContext.delete(t)
        }
        save()
        fetchTaskGroups()
        
    }
    
    func removeAll() {
        
        let request = NSFetchRequest<TaskGroup>(entityName: "TaskGroup")
        
        do {
            let data = try container.viewContext.fetch(request)
            data.forEach { taskGroup in
                container.viewContext.delete(taskGroup)
            }
        } catch let error {
            print("Error fetching and deleting all data. \(error)")
        }
        save()
        fetchTaskGroups()
    }
    
    
}

extension Date {
    public  func addMonth(n: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: n, to: self)!
    }
    public  func addWeek(n: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: n*7, to: self)!
        
    }
    public  func addYear(n: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .year, value: n, to: self)!
    }
    
    public   var monthName: String {
        let calendar = Calendar.current
        let monthInt = calendar.component(.month, from: self)
        return calendar.monthSymbols[monthInt-1]
    }
}
