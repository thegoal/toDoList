//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Ishaq Shafiq on 12/09/2017.
//  Copyright © 2017 Ishaq Shafiq. All rights reserved.
//

import Foundation
import CoreData


class CoreDataManager {
    
    //MARK: Local Variable
    
    var taskArray: [ToDoTask] = []
    
    //MARK: Shared Instance
    
    static let sharedInstance = CoreDataManager()

//    static let sharedInstance : CoreDataManager = {
//        let instance = CoreDataManager()
//        return instance
//    }()
    
    
    //MARK: Init
    
    init() {
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ToDoListModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    
    // MARK: - Core Data Save Task
    
    func saveTask () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Core Data Add Task
    
    func addTask(name:String) {
        let context = persistentContainer.viewContext
        let task = ToDoTask(context: context)
        task.taskName = name
        task.taskId = NSUUID().uuidString.lowercased()
        task.taskDone = false
        self.saveTask()
    }
    
    // MARK: - Core Data Fectch Tasks
    
    func getTaskForTab(pending:Bool) -> [ToDoTask] {
        do {
            let context = persistentContainer.viewContext
            taskArray = try context.fetch(ToDoTask.fetchRequest())
            // We can add predicate on core data too.
            let filteredArray = taskArray.filter({$0.taskDone == pending})
            return filteredArray
        }
        catch {
           return NSMutableArray() as! [ToDoTask]
        }
    }
}
