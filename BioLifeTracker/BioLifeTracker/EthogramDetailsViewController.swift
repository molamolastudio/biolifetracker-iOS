//
//  EthogramDetailsViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 11/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class EthogramDetailsViewController: UITableViewController, UITextFieldDelegate {
    
    let nameCellIdentifier = "SingleLineTextCell"
    let stateCellIdentifier = "BehaviourStateCell"
    
    let messageNewState = "+ Add new state"
    
    let rowHeight: CGFloat = 44
    
    let numSections = 2
    let firstSection = 0
    let secondSection = 1
    let sectionTitles = ["Details", "Behaviour States"]
    
    let firstSectionNumRows = 1
    let firstRow = 0
    
    var secondSectionNumRows = 1
    
    var alert = UIAlertController()
    let alertTitle = "Incomplete Ethogram"
    let alertMessage = "You must add a name for the ethogram."
    
    var editable = false
    
    // Collected data
    var originalEthogram: Ethogram? = nil
    var ethogram = Ethogram()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = rowHeight
        
        self.tableView.registerNib(UINib(nibName: nameCellIdentifier, bundle: nil), forCellReuseIdentifier: nameCellIdentifier)
        self.tableView.registerNib(UINib(nibName: stateCellIdentifier, bundle: nil), forCellReuseIdentifier: stateCellIdentifier)
        
        setupAlertController()
    }
    
    func setupAlertController() {
        alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let actionOk = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(actionOk)
    }
    
    func makeEditable(value: Bool) {
        editable = value
        refreshView()
    }
    
    // Copies the data of the original ethogram into a temporary ethogram for editing.
    func getData() {
        if originalEthogram != nil {
            // Copy over original ethogram
            ethogram = Ethogram()
            for s in originalEthogram!.behaviourStates {
                let state = BehaviourState(name: s.name, information: s.information)
                ethogram.addBehaviourState(state)
            }
        }
    }
    
    // Copies over the edited behaviour states into the original ethogram.
    func saveData() {
        if originalEthogram != nil {
            for i in 0...ethogram.behaviourStates.count {
                if i < originalEthogram!.behaviourStates.count {
                    originalEthogram!.behaviourStates[i].updateName(ethogram.behaviourStates[i].name)
                    originalEthogram!.behaviourStates[i].updateInformation(ethogram.behaviourStates[i].name)
                } else {
                    originalEthogram!.addBehaviourState(ethogram.behaviourStates[i])
                }
            }
        }
    }
    
    func refreshView() {
        self.tableView.reloadData()
    }
    
    // UITableViewDataSource and UITableViewDelegate METHODS
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == firstSection {
            return getCellForFirstSection(indexPath)
        } else {
            return getCellForSecondSection(indexPath)
        }
    }
    
    // Sets up data in the cells
    func getCellForFirstSection(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(nameCellIdentifier) as! SingleLineTextCell
        
        cell.textField.userInteractionEnabled = editable
        
        cell.label.text = "Name"
        cell.textField.text = ethogram.name
        cell.textField.addTarget(self, action: Selector("nameRowDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
        return cell
    }
    
    // Populates behaviour states in second section and sets up listeners for adding new state.
    func getCellForSecondSection(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(stateCellIdentifier) as! BehaviourStateCell
        
        let textField = cell.textField
        textField.delegate = self
        
        // Set up cells that have been filled out
        if ethogram.behaviourStates.count > indexPath.row {
            textField.text = ethogram.behaviourStates[indexPath.row].name
            textField.removeTarget(self, action: Selector("extraRowDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
            textField.addTarget(self, action: Selector("textFieldDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
            cell.button.tag = indexPath.row
            
        } else if ethogram.behaviourStates.count == indexPath.row {
            textField.placeholder = messageNewState
            textField.removeTarget(self, action: Selector("textFieldDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
            textField.addTarget(self, action: Selector("extraRowDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
        }
        
        textField.userInteractionEnabled = editable
        textField.tag = indexPath.row
        cell.button.hidden = true
        
        return cell
    }
    
    // Selectors for text fields
    func nameRowDidChange(sender: UITextField) {
        if sender.text != "" {
            ethogram.updateName(sender.text)
        }
    }
    
    func textFieldDidChange(sender: UITextField) {
        let cell = sender.superview! as! BehaviourStateCell
        if sender.text != "" {
            cell.button.setTitle("Edit", forState: .Normal)
            cell.button.hidden = false
            cell.button.removeTarget(self, action: Selector("addButtonPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
            cell.button.addTarget(self, action: Selector("editButtonPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
        } else {
            sender.placeholder = messageNewState
            cell.button.hidden = true
        }
    }
    
    func extraRowDidChange(sender: UITextField) {
        let cell = sender.superview! as! BehaviourStateCell
        if sender.text != "" {
            cell.button.setTitle("Add", forState: .Normal)
            cell.button.hidden = false
            cell.button.removeTarget(self, action: Selector("editButtonPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
            cell.button.addTarget(self, action: Selector("addButtonPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
        } else {
            sender.placeholder = messageNewState
            cell.button.hidden = true
        }
    }
    
    // Gets the name for the new behaviour state from the cell and updates the behaviour state
    // of the ethogram, then refreshes the view.
    func editButtonPressed(sender: UIButton) {
        let cell = sender.superview! as! BehaviourStateCell
        ethogram.updateBehaviourStateName(cell.button.tag, bsName: cell.textField.text!)
        
        cell.button.hidden = true
        
        refreshView()
    }
    
    // Gets the name for the new behaviour state from the cell and adds it to the ethogram,
    // then refreshes the view.
    func addButtonPressed(sender: UIButton) {
        let cell = sender.superview! as! BehaviourStateCell
        
        let state = BehaviourState(name: cell.textField.text!, information: "must add information")
        ethogram.addBehaviourState(state)
        
        cell.button.hidden = true
        
        refreshView()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if isFirstSection(indexPath.section) {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! SingleLineTextCell
            cell.textField.becomeFirstResponder()
        } else {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! BehaviourStateCell
            cell.textField.becomeFirstResponder()
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFirstSection(section) {
            return firstSectionNumRows
        } else {
            // Adds an extra row if this ethogram is editable
            if editable {
                return ethogram.behaviourStates.count + 1
            } else {
                return ethogram.behaviourStates.count
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numSections
    }
    
    // For deleting extra behaviour states
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if editable {
            return isSecondSection(indexPath.section) && !isExtraRow(indexPath.row)
        } else {
            return false
        }
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    // If the cell is deleted, delete the behaviour state related to it.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                
                if !isExtraRow(indexPath.row) {
                    ethogram.removeBehaviourState(indexPath.row)
                }
            }
        }
    }
    
    // UITextFieldDelegate methods
    // After user presses enter key, call the methods to update the behaviour states.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.text != "" {
            let cell = textField.superview! as! BehaviourStateCell
            if isExtraRow(textField.tag) {
                addButtonPressed(cell.button)
            } else {
                editButtonPressed(cell.button)
            }
            return true
        }
        return false
    }
    
    // HELPER METHODS
    func isFirstSection(index: Int) -> Bool {
        return index == firstSection
    }
    
    func isSecondSection(index: Int) -> Bool {
        return index == secondSection
    }
    
    func isExtraRow(index: Int) -> Bool {
        return index == ethogram.behaviourStates.count
    }
    
}