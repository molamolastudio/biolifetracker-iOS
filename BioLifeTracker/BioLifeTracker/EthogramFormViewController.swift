//
//  EthogramFormViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 11/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class EthogramFormViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    let segueToNewProject = "NewEthogramToNewProject"
    
    let cellReuseNameCell = "NameCell"
    let cellReuseCodeCell = "CodeCell"
    let cellReuseTextField = "TextFieldOnly"
    
    let messageNewState = "+ Add new state"
    
    let rowHeight = Constants.Table.rowHeight
    
    let numSections = 2
    let firstSection = 0
    let secondSection = 1
    let sectionTitles = ["Details", "Behaviour States"]
    
    let firstSectionNumRows = 2
    let firstRow = 0
    let secondRow = 1
    
    var secondSectionNumRows = 1
    var secondSectionRowTitles = []
    let extraRow = 1
    
    var alert = UIAlertController()
    let alertTitle = "Incomplete Ethogram"
    let alertMessage = "All fields must be filled."
    
    // For segues
    var source: UIViewController? = nil
    
    // Collected data
    var ethogram: Ethogram?
    
    // UI elements to add later
    var btnAdd: UIButton? // For the behaviour state section
    let btnAddFrame = CGRectMake(317, 9, 50, 30)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = rowHeight
        if ethogram == nil {
            ethogram = Ethogram()  // Create a blank ethogram to fill in.
        }
        btnAdd = createAddButton()
        setupAlertController()
    }
    
    func refreshView() {
        self.tableView.reloadData()
    }
    
    func createAddButton() -> UIButton {
        let button = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        button.setTitle("Add", forState: UIControlState.Normal)
        button.addTarget(self, action: Selector("addButtonPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }
    
    // Gets the name for the new behaviour state from the cell and adds it to the ethogram,
    // then refreshes the view.
    func addButtonPressed(sender: UIButton) {
        let cell = sender.superview! as! UITableViewCell
        let textField = cell.viewWithTag(Constants.ViewTags.ethogramFormCellFullTextField) as! UITextField
        
        let state = BehaviourState(name: textField.text!, information: "Must add information")

//        state.saveInBackgroundWithBlock { (success, error) in
//            println("Saving behaviour state success: \(success)\nError: \(error.debugDescription)")
//        }
        
        ethogram!.addBehaviourState(state)

        sender.removeFromSuperview()
        
        refreshView()
    }
    
    func setupAlertController() {
        alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let actionOk = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(actionOk)
    }
    
    // UITableViewDataSource and UITableViewDelegate METHODS
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == firstSection {
            return getCellForFirstSection(indexPath)
        } else {
            return getCellForSecondSection(indexPath)
        }
    }
    
    // Sets up listeners for text fields in first section
    func getCellForFirstSection(indexPath: NSIndexPath) -> UITableViewCell {
        if isFirstRow(indexPath.row) {
            let cell = self.tableView.dequeueReusableCellWithIdentifier(cellReuseNameCell) as! UITableViewCell
            let textField = cell.viewWithTag(Constants.ViewTags.ethogramFormNameField) as! UITextField
            textField.addTarget(self, action: Selector("nameRowDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCellWithIdentifier(cellReuseCodeCell)as! UITableViewCell
            let textField = cell.viewWithTag(Constants.ViewTags.ethogramFormCodeField) as! UITextField
            
            //textField.text = ethogram?.id
            
            textField.addTarget(self, action: Selector("codeRowDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
            return cell
        }
    }
    
    // Populates behaviour states in second section and sets up listeners for adding new state.
    func getCellForSecondSection(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellReuseTextField)as! UITableViewCell
        let textField = cell.viewWithTag(Constants.ViewTags.ethogramFormCellFullTextField) as! UITextField
        
        if ethogram!.behaviourStates.count > indexPath.row {
            textField.text = ethogram!.behaviourStates[indexPath.row].name
            textField.userInteractionEnabled = false
            textField.removeTarget(self, action: Selector("extraRowDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
        } else if ethogram!.behaviourStates.count == indexPath.row {
            textField.placeholder = messageNewState
            textField.userInteractionEnabled = true
            textField.addTarget(self, action: Selector("extraRowDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
        }
        return cell
    }
    
    // Selectors for text fields
    func nameRowDidChange(sender: UITextField) {
        if sender.text != "" {
            ethogram!.updateName(sender.text)
        }
    }
    
    func codeRowDidChange(sender: UITextField) {
        if sender.text != "" {
            //ethogram!.code = sender.text
        }
    }
    
    func extraRowDidChange(sender: UITextField) {
        if sender.text != "" {
            let cell = sender.superview!.superview!as! UITableViewCell
            cell.addSubview(btnAdd!)
            btnAdd!.frame = btnAddFrame
        } else {
            sender.placeholder = messageNewState
            btnAdd!.removeFromSuperview()
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFirstSection(section) {
            return firstSectionNumRows
        } else {
            return ethogram!.behaviourStates.count + extraRow
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numSections
    }
    
    // For deleting extra behaviour states
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return isSecondSection(indexPath.section) && !isExtraRow(indexPath.row)
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    // If the cell is deleted, delete the behaviour state related to it.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                // Unable to delete cell, array out of bounds or hang
                //let index = indexPath.row
                //ethogram!.behaviourStates.removeAtIndex(index)
            }
        }
    }
    
    @IBAction func btnBackPressed(sender: UIBarButtonItem) {
        ethogram = nil // Clear ethogram data
        self.performSegueWithIdentifier(segueToNewProject, sender: self)
    }
    
    // If the form is not filled completely, presents an alert to user to finish filling the form.
    // Else, transitions to the New Project page.
    @IBAction func btnDonePressed(sender: UIBarButtonItem) {
        if ethogram!.name == "" || ethogram!.behaviourStates.isEmpty //|| ethogram!.code == ""
        {
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            self.performSegueWithIdentifier(segueToNewProject, sender: self)
        }
    }
    
    // HELPER METHODS
    func isFirstSection(index: Int) -> Bool {
        return index == firstSection
    }
    
    func isSecondSection(index: Int) -> Bool {
        return index == secondSection
    }
    
    func isFirstRow(index: Int) -> Bool {
        return index == firstRow
    }
    
    func isSecondRow(index: Int) -> Bool {
        return index == secondRow
    }
    
    func isExtraRow(index: Int) -> Bool {
        return index == ethogram!.behaviourStates.count
    }
    
}