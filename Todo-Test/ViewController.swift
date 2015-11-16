//
//  ViewController.swift
//  Todo-Test
//
//  Created by mitchell hudson on 11/15/15.
//  Copyright © 2015 mitchell hudson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    // MARK: IBActions
    
    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
        addTodo()
    }
    
    
    func addTodo() {
        let alert = UIAlertController(title: "Add Todo", message: "Add a new Todo", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction) -> Void in
            let textField = alert.textFields![0]
            TodoManager.sharedInstance.addTodoWithName(textField.text!)
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
            textField.placeholder = "Todo name"
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    
    // MARK: TableView Datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TodoManager.sharedInstance.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        
        let todo = TodoManager.sharedInstance.getTodoAtIndex(indexPath.row)
        cell.textLabel?.text = todo.name
        setCellAccessory(cell, forCompletedState: todo.completed)
        
        return cell
    }
    
    
    // MARK: TableView Delegate
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            TodoManager.sharedInstance.removeTodoAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        let todo = TodoManager.sharedInstance.getTodoAtIndex(indexPath.row)
        
        cell.selected = false
        
        todo.completed = !todo.completed
        setCellAccessory(cell, forCompletedState: todo.completed)
        
        TodoManager.sharedInstance.save()
    }
    
    func setCellAccessory(cell: UITableViewCell, forCompletedState completed: Bool) {
        if completed {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
    }
    
    
    
    
    // MARK: View Lifecycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

