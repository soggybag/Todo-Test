//
//  ViewController.swift
//  Todo-Test
//
//  Created by mitchell hudson on 11/15/15.
//  Copyright © 2015 mitchell hudson. All rights reserved.
//


/* 

This example collects some ideas for different ways of working with tableview.
The app acts as a simple Todo list using Core Data. 

Some of the ideas contained are: 

* Working with UIAlertController. This is used to add new todo items
* Using more than one section. Here a second section is used to add a button at the bottom of the tableview 
* Managing two different table views cells via their identifier
* Commit editing style, to delete cells. 
* Row Edit actions, used for adding tag and delete.
* Setting tag color for cell background. 
* Setting an image in the cells imageview 
* Setting the cell accessory

*/


import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: IBOutlets
    
    // A reference to tableView in storyboard
    @IBOutlet weak var tableView: UITableView!
    
    
    
    // MARK: IBActions
    
    // This action is connected to the button (New) in the cell id: lastCell
    @IBAction func addNewCellButtonTapped(sender: UIButton) {
        addTodo()
    }
    
    // This action is connected to the + button in the bar at the bottom of the screen.
    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
        addTodo()
    }
    
    
    // This method opens an alert with a text field, which adds a new todo.
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
    
    // The tableview will use two sections.
    // All of the todos are in section 0
    // The New button in the last row is in section 1
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // return 2 sections
        return 2
    }
    
    // since there are two sections we need to return a different number of cells for each section. 
    // Section 1 contains only 1 cell.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            // Section 2 has only one cell
            return 1
        }
        return TodoManager.sharedInstance.count
    }
    
    // There two different cell types. One for todos, and the other for the cell with the 
    // new button. Check indexPath.section to find the section the table view is asking for
    // and use the correct id, to generate correct cell type.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellId = "cell" // This is the cell id for Todo Cells
        if indexPath.section == 1 {
            cellId = "lastCell" // This is the cell id for the Add Button
        }
        
        // Get a cell with one or the other id
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId)!
        
        // Configure the cell depending on what type it is...
        if cellId == "cell" {
            // Configure a todo cell
            let todo = TodoManager.sharedInstance.getTodoAtIndex(indexPath.row)
            cell.textLabel?.text = todo.name
            cell.detailTextLabel?.text = "\(todo.tag)"
            setCellAccessory(cell, forCompletedState: todo.completed)
            cell.imageView?.image = UIImage(named: "tag-\(todo.tag)")
            self.setCellColorForTag(TagType(rawValue: Int(todo.tag))!, cell: cell)
        } else {
            // No need to configure the New Todo Cell, it has a button already. 
            // If there were need to configure it do it here.
        }
        
        // Return the cell
        return cell
    }
    
    
    // MARK: TableView Delegate
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Check the section.
        if indexPath.section == 1 {
            // Cells in section 1 can not be edited
            return false
        }
        // Cells in section 0 can be edited
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // Use this with canEditRowAtIndexPath to delete cells
        if editingStyle == UITableViewCellEditingStyle.Delete {
            deleteRowAtIndexPath(indexPath)
        }
    }
    
    // This is a helper function to delete rows. Pass the indexPath to delete.
    func deleteRowAtIndexPath(indexPath: NSIndexPath) {
        // Delete the todo from the Manager
        TodoManager.sharedInstance.removeTodoAtIndex(indexPath.row)
        // Then delete the row from the tableview
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
    }
    
    // This method shows the button on swipe.
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        // Each button is a UITableViewRowAction. Set the parameters, and define a block that will 
        // be executed when the button is tapped. You can use unicode icons and emojis in the action 
        // title. See the delete button.
        
        // Make a delete button
        let delete = UITableViewRowAction(style: .Normal, title: "\u{267A}\n Delete") { (action: UITableViewRowAction, indexPath: NSIndexPath) -> Void in
            // Call the helper method to delete the cell.
            self.deleteRowAtIndexPath(indexPath)
        }
        delete.backgroundColor = UIColor.redColor() // Set the color
        
        // This button sets the .Tag1
        let tag1 = UITableViewRowAction(style: .Normal, title: "Tag A") { (action: UITableViewRowAction, index: NSIndexPath) -> Void in
            // Set the tag
            // Set the tag for the todo at this index.
            self.setTag(.Tag1, index: indexPath.row)
            // Call the helper method to update the background color of the cell.
            self.setCellColorForTag(.Tag1, cell: self.tableView.cellForRowAtIndexPath(indexPath)!)
        }
        tag1.backgroundColor = TagType.Tag1.tagColor()
        
        // Set the button to .Tag2
        let tag2 = UITableViewRowAction(style: .Normal, title: "Tag b") { (action: UITableViewRowAction, index: NSIndexPath) -> Void in
            // Set the tag
            self.setTag(.Tag2, index: indexPath.row)
            self.setCellColorForTag(.Tag2, cell: self.tableView.cellForRowAtIndexPath(indexPath)!)
        }
        tag2.backgroundColor = TagType.Tag2.tagColor()
        
        // Set the button to .Tag3
        let tag3 = UITableViewRowAction(style: .Normal, title: "Tag C") { (action: UITableViewRowAction, index: NSIndexPath) -> Void in
            // Set the tag
            self.setTag(.Tag3, index: indexPath.row)
            self.setCellColorForTag(.Tag3, cell: self.tableView.cellForRowAtIndexPath(indexPath)!)
        }
        tag3.backgroundColor = TagType.Tag3.tagColor()
        
        // Return an array of UITableViewRowActions.
        return [delete, tag1, tag2, tag3]
    }
    
    // This is a helper function to change the tag of a row, and update the todo item tag property.
    func setTag(tag: TagType, index: Int) {
        TodoManager.sharedInstance.setTagForTodoAtIndex(index, tagType: tag)
        tableView.editing = false
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    // A helper function to set the background color for cells, based on the tag.
    func setCellColorForTag(tag: TagType, cell: UITableViewCell) {
        cell.backgroundColor = tag.tagColor()
    }
    
    // Tableview delegate method notifies us when a cell is selected. 
    // I'm using this here to deselect the cell, and set the completed property.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Get the cell.
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        // Get the todo associated with that cell.
        let todo = TodoManager.sharedInstance.getTodoAtIndex(indexPath.row)
        
        // Deselect the cell, otherwise we see the gray highlight color.
        cell.selected = false
        
        // Set the todo's completed property.
        todo.completed = !todo.completed
        // Call on a helper function to update the cell accessory.
        setCellAccessory(cell, forCompletedState: todo.completed)
        // Save changes to the todo item.
        TodoManager.sharedInstance.save()
    }
    
    // A helper function to update the cell acccessory. In this case the accessory is the 
    // checkmark. The checkmark shows the completed state for the todo item.
    // Pass this function the cell, and the completed value (true or false)
    func setCellAccessory(cell: UITableViewCell, forCompletedState completed: Bool) {
        if completed {
            // Set the accessory to the checkmark.
            cell.accessoryType = .Checkmark
        } else {
            // Set the accessory to none. 
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

