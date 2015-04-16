//
//  EthogramDetailsViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 12/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class EthogramDetailsViewController: UITableViewController {
    
    let nameCellIdentifier = "SingleLineTextCell"
    let stateCellIdentifier = "BehaviourStateCell"
    
    let messageNewState = "+ Add new state"
    
    let rowHeight = Constants.Table.rowHeight
    
    let numSections = 2
    let firstSection = 0
    let secondSection = 1
    let sectionTitles = ["Details", "Behaviour States"]
    
    let firstSectionNumRows = 1
    let firstRow = 0
    
    var secondSectionNumRows = 1
    var secondSectionRowTitles = []
    let extraRow = 1
    
    // Collected data
    var ethogram = Ethogram()
    
    // UI elements to add later
    var btnAdd: UIButton? // For the behaviour state section
    let btnAddFrame = CGRectMake(317, 9, 50, 30)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = rowHeight
        ethogram = Data.selectedEthogram!
        btnAdd = createAddButton()
        
        self.tableView.registerNib(UINib(nibName: nameCellIdentifier, bundle: nil), forCellReuseIdentifier: nameCellIdentifier)
        self.tableView.registerNib(UINib(nibName: stateCellIdentifier, bundle: nil), forCellReuseIdentifier: stateCellIdentifier)
        
        self.navigationItem.title = ethogram.name
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
        let cell = sender.superview! as! BehaviourStateCell
        
        let state = BehaviourState(name: cell.textField.text!, information: "must add information")
        ethogram.addBehaviourState(state)
        
        cell.button.hidden = true
        
        refreshView()
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
        
        cell.textField.userInteractionEnabled = false
        
        cell.label.text = "Name"
        cell.textField.text = ethogram.name
        return cell
    }
    
    // Populates behaviour states in second section and sets up listeners for adding new state.
    func getCellForSecondSection(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(stateCellIdentifier) as! BehaviourStateCell
        let textField = cell.textField
        
        if ethogram.behaviourStates.count > indexPath.row {
            textField.text = ethogram.behaviourStates[indexPath.row].name
            textField.addTarget(self, action: Selector("textFieldTouched:"), forControlEvents: UIControlEvents.EditingChanged)
        } else if ethogram.behaviourStates.count == indexPath.row {
            textField.placeholder = messageNewState
            textField.addTarget(self, action: Selector("extraRowDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
        }
        textField.userInteractionEnabled = true
        cell.button.hidden = true
        return cell
    }
    
    // Selectors for text fields
    func nameRowDidChange(sender: UITextField) {
        if sender.text != "" {
            ethogram.updateName(sender.text)
        }
    }
    
    func textFieldTouched(sender: UITextField) {
        let cell = sender.superview! as! BehaviourStateCell
        if sender.text != "" {
            cell.button.setTitle("Edit", forState: .Normal)
            cell.button.hidden = false
            cell.button.addTarget(self, action: Selector("addButtonPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
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
            cell.button.addTarget(self, action: Selector("addButtonPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
        } else {
            sender.placeholder = messageNewState
            cell.button.hidden = true
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFirstSection(section) {
            return firstSectionNumRows
        } else {
            return ethogram.behaviourStates.count + extraRow
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
                if !isExtraRow(indexPath.row) {
                    ethogram.removeBehaviourState(indexPath.row)
                }
            }
        }
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