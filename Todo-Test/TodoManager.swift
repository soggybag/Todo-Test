//
//  TodoManager.swift
//  Todo-Test
//
//  Created by mitchell hudson on 11/15/15.
//  Copyright © 2015 mitchell hudson. All rights reserved.
//

// Using Core Data 
// 1) Start a project with Core Data
// 2) Add an entity to .xcdatamodeld
// 3) Add some properties to your entity. Be sure to set the data type for each!
// 4) Select your entity and choose: Editor > Create NSManagedObject Subclass...
//      ok your way through the dialogs and save this new file into your project. 
// 5) Edit the manager class. We need a refernce to the managed object context.
//      Think of this as a reference to the database. 
//      add a var to hold the context
// 6) Set the value of the context in init()

// 7) You'll need to fetch data from the context to display saved data.
//      Add a fetch method look for fetchTodos() in this example.
// 8) When making any changes to Managed Objects you need to save those changes. This
//      updates the data store, making it possible to retreive the data later. 
//      add a save method.
// 9) Edit add todo. Here we need to make a new Managed Object.
// 10) Edit removeTodoAtIndex(). Here you remove the todo from the array, but you'll
//      also need to remove the entity from the context, and save the context.


import UIKit
import CoreData

class TodoManager {
    
    // MARK: Init
    static let sharedInstance = TodoManager()
    
    private init() {
        // 6) Get reference to the managed object context
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        context = appDelegate.managedObjectContext
        
        fetchTodos()
    }
    
    // MARK: Private Vars 
    
    private let context: NSManagedObjectContext! // 5) add a property to hold the context
    private var todos = [Todo]()
    
    
    // MARK: Public Vars
    
    var count: Int {
        get {
            return todos.count
        }
    }
    
    
    // MARK: Public Methods 
    
    // 10) Since Todo is now a managed object We need to make these. 
    func addTodoWithName(name: String) {
        // Make a new entity. Supply the entity name, and context.
        let todo = NSEntityDescription.insertNewObjectForEntityForName("Todo", inManagedObjectContext: context) as! Todo
        // Set any properties.
        todo.name = name
        todo.completed = false
        // Add the new todo to the todos array
        todos.append(todo)
        // Save the results.
        save()
    }
    
    func getTodoAtIndex(index: Int) -> Todo {
        return todos[index]
    }
    
    // 11) Remove todo.
    func removeTodoAtIndex(index: Int) {
        // Remove the entity from the context
        self.context.deleteObject(getTodoAtIndex(index))
        todos.removeAtIndex(index)
        save() // save the context
    }
    
    // 8) Use this method to fetch daved todo items.
    func fetchTodos() {
        // Make a fetch request
        let fetchRequest = NSFetchRequest(entityName: "Todo")
        // Use a do, try, catch block to check for errors.
        do {
            // execute your fetch request, this returns an array of Todos (hopefully...)
            let results = try context.executeFetchRequest(fetchRequest)
            // Assign the results to the todos array. Cast it as [Todo] (an array of Todo)
            todos = results as! [Todo]
        } catch let error as NSError {
            // If there's an error, we catch it here and print a message.
            print("Error fetching Todos:\(error), \(error.userInfo)")
        }
    }
    
    // 9) This method saves changes to any objects managed by the context
    func save() {
        // Use the do, try, and catch block here to check for errors.
        do {
            // Try to save the context
            try context.save()
        } catch let error as NSError {
            // Check for an error. Print the error message.
            print("Error saving:\(error), \(error.userInfo)")
        }
    }
    
    
    func setTagForTodoAtIndex(index: Int, tagType: TagType) {
        let todo = getTodoAtIndex(index)
        todo.tag = Int16(tagType.rawValue)
        save()
    }
    
    
}
