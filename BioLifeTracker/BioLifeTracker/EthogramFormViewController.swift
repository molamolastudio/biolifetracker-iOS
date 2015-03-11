//
//  EthogramFormViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 11/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class EthogramFormViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    let segueToNewProject = "NewEthogramToNewProject"
    
    let tagNameField = 200
    let tagCodeField = 201
    let tagCellFullTextField = 202
    
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
    let firstSectionRowTitles = ["Name", "Code"]
    let firstRow = 0
    let secondRow = 1
    
    var secondSectionNumRows = 1
    var secondSectionRowTitles = []
    let extraRow = 1
    
    // For segues
    var source: UIViewController? = nil
    
    // Collected data
    var ethogram: Ethogram?
    
    // UI elements to add later
    var btnAdd: UIButton? // For the behaviour state section
    let frameBtnAdd = CGRectMake(317, 9, 50, 30)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = rowHeight
        if ethogram == nil {
            ethogram = Ethogram()  // Create a blank ethogram to fill in.
        }
        btnAdd = createAddButton()
    }
    
    func refreshView() {
        self.tableView.reloadData()
    }
    
    func createAddButton() -> UIButton {
        let button = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.setTitle("Add", forState: UIControlState.Normal)
        button.addTarget(self, action: Selector("addButtonPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }
    
    // Gets the name for the new behaviour state from the cell and adds it to the ethogram,
    // then refreshes the view.
    func addButtonPressed(sender: UIButton) {
        let cell = sender.superview! as UITableViewCell
        let textField = cell.viewWithTag(tagCellFullTextField) as UITextField
        
        let state = BehaviourState(name: textField.text!, id: ethogram!.behaviourStates.count)
        ethogram!.addBehaviourState(state)
        
        sender.removeFromSuperview()
        
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
    
    // Sets up listeners for text fields in first section
    func getCellForFirstSection(indexPath: NSIndexPath) -> UITableViewCell {
        if isFirstRow(indexPath.row) {
            let cell = self.tableView.dequeueReusableCellWithIdentifier(cellReuseNameCell) as UITableViewCell
            let textField = cell.viewWithTag(tagNameField) as UITextField
            textField.delegate = self
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCellWithIdentifier(cellReuseCodeCell) as UITableViewCell
            let textField = cell.viewWithTag(tagCodeField) as UITextField
            textField.delegate = self
            
            textField.text = ethogram?.id
            return cell
        }
    }
    
    // Populates behaviour states in second section and sets up listeners for adding new state.
    func getCellForSecondSection(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellReuseTextField) as UITableViewCell
        let textField = cell.viewWithTag(tagCellFullTextField) as UITextField
        
        textField.delegate = self
        
        if ethogram!.behaviourStates.count < indexPath.row {
            textField.text = ethogram!.behaviourStates[indexPath.row].name
            textField.userInteractionEnabled = false
            
        } else if ethogram!.behaviourStates.count == indexPath.row {
            textField.placeholder = messageNewState
            textField.userInteractionEnabled = true
        }
        return cell
    }
    
    func extraRowTouched(sender: UITextField) {
        let cell = sender.superview!.superview! as UITableViewCell
        cell.addSubview(btnAdd!)
        btnAdd!.frame = frameBtnAdd
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == firstSection {
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
        return isSecondSection(indexPath.row) && !isExtraRow(indexPath.row)
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    // If the cell is deleted, delete the behaviour state related to it.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                let index = indexPath.row
                ethogram!.behaviourStates.removeAtIndex(index)
            }
        }
    }
    
    // UITextFieldDelegate METHODS
    
    func textFieldDidBeginEditing(textField: UITextField) {
        switch textField.tag {
        case tagCellFullTextField:
            extraRowTouched(textField)
            break
        default:
            break
        }
    }

    // Updates data for the ethogram being created when user finishes keying in text
    func textFieldDidEndEditing(textField: UITextField) {
        switch textField.tag {
        case tagNameField:
            ethogram!.name = textField.text
            break
        case tagCodeField:
            ethogram!.code = textField.text
            break
        case tagCellFullTextField:
            if textField.text != "" {
                extraRowTouched(textField)
            } else {
                textField.placeholder = messageNewState
                btnAdd!.removeFromSuperview()
            }
            break
        default:
            break
        }
    }
    
    @IBAction func btnBackPressed(sender: UIBarButtonItem) {
        ethogram = nil // Clear ethogram data
        self.performSegueWithIdentifier(segueToNewProject, sender: self)
    }
    
    @IBAction func btnDonePressed(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier(segueToNewProject, sender: self)
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