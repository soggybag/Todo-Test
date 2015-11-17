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
    
    @IBAction func addNewCellButtonTapped(sender: UIButton) {
        print("Add New Cell button")
        addTodo()
    }
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // return 2 sections
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return TodoManager.sharedInstance.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellId = "cell"
        if indexPath.section == 1 {
            cellId = "lastCell"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId)!
        
        if cellId == "cell" {
            let todo = TodoManager.sharedInstance.getTodoAtIndex(indexPath.row)
            cell.textLabel?.text = todo.name
            cell.detailTextLabel?.text = "\(todo.tag)"
            setCellAccessory(cell, forCompletedState: todo.completed)
            cell.imageView?.image = UIImage(named: "tag-\(todo.tag)")
            self.setCellColorForTag(TagType(rawValue: Int(todo.tag))!, cell: cell)
        } else {
            
        }
        
        return cell
    }
    
    
    // MARK: TableView Delegate
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            deleteRowAtIndexPath(indexPath)
        }
    }
    
    func deleteRowAtIndexPath(indexPath: NSIndexPath) {
        TodoManager.sharedInstance.removeTodoAtIndex(indexPath.row)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
    }
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { (action: UITableViewRowAction, indexPath: NSIndexPath) -> Void in
            self.deleteRowAtIndexPath(indexPath)
        }
        delete.backgroundColor = UIColor.redColor()
        
        let tag1 = UITableViewRowAction(style: .Normal, title: "Tag A") { (action: UITableViewRowAction, index: NSIndexPath) -> Void in
            // Set the tag
            self.setTag(.Tag1, index: indexPath.row)
            self.setCellColorForTag(.Tag1, cell: self.tableView.cellForRowAtIndexPath(indexPath)!)
        }
        tag1.backgroundColor = TagType.Tag1.tagColor()
        
        let tag2 = UITableViewRowAction(style: .Normal, title: "Tag b") { (action: UITableViewRowAction, index: NSIndexPath) -> Void in
            // Set the tag
            self.setTag(.Tag2, index: indexPath.row)
            self.setCellColorForTag(.Tag2, cell: self.tableView.cellForRowAtIndexPath(indexPath)!)
        }
        tag2.backgroundColor = TagType.Tag2.tagColor()
        
        let tag3 = UITableViewRowAction(style: .Normal, title: "Tag C") { (action: UITableViewRowAction, index: NSIndexPath) -> Void in
            // Set the tag
            self.setTag(.Tag3, index: indexPath.row)
            self.setCellColorForTag(.Tag3, cell: self.tableView.cellForRowAtIndexPath(indexPath)!)
        }
        tag3.backgroundColor = TagType.Tag3.tagColor()
        
        return [delete, tag1, tag2, tag3]
    }
    
    func setTag(tag: TagType, index: Int) {
        TodoManager.sharedInstance.setTagForTodoAtIndex(index, tagType: tag)
        tableView.editing = false
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func setCellColorForTag(tag: TagType, cell: UITableViewCell) {
        cell.backgroundColor = tag.tagColor()
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

