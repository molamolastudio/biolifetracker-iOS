//
//  EthogramDetailsViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 11/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//
//  This class displays a form to edit an ethogram.
//  It can be made editable or not.
//  The user must enter a name and at least one behaviour state to
//  edit the ethogram, otherwise an alert will be shown.
//
//  The ethogram being edited must be set as 'originalEthogram' and its
//  data will be deep copied to 'ethogram' after 'getData' is called.
//  To retrieve the data edited, call 'saveData', which returns a boolean
//  to indicate the success of the save. If the save was successful, the
//  original ethogram object has already been updated. If not, an alert
//  will inform the user of the incomplete form.

import UIKit

class EthogramDetailsViewController: UIViewController, UITableViewDataSource,
                                     UITableViewDelegate, UITextFieldDelegate,
                                     UITextViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    
    let nameCellIdentifier = "SingleLineTextCell"
    let stateCellIdentifier = "BehaviourStateCell"
    
    let messageNewState = " + Add new state"
    
    let firstSectionRowHeight: CGFloat = 44
    let secondSectionRowHeight: CGFloat = 120
    
    let numSections = 2
    let firstSection = 0
    let secondSection = 1
    let sectionTitles = ["Details", "Behaviour States"]
    
    let firstSectionNumRows = 1
    let firstRow = 0
    
    var secondSectionNumRows = 1
    
    var alert = UIAlertController()
    let alertTitle = "Incomplete Ethogram"
    let alertMessage = "You must add a name and behaviour state for the ethogram."
    
    var editable = false
    var deletionEnabled = true
    
    // Collected data
    var originalEthogram: Ethogram? = nil
    var ethogram = Ethogram()
    
    override func loadView() {
        self.view = NSBundle.mainBundle().loadNibNamed("PaddedTableView", owner: self, options: nil).first as! UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.registerNib(UINib(nibName: nameCellIdentifier, bundle: nil), forCellReuseIdentifier: nameCellIdentifier)
        self.tableView.registerNib(UINib(nibName: stateCellIdentifier, bundle: nil), forCellReuseIdentifier: stateCellIdentifier)
        
        // Sets the subviews to display under the navigation bar
        self.edgesForExtendedLayout = UIRectEdge.None
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Sets rounded corners
        self.tableView.layer.cornerRadius = 8
        self.tableView.layer.masksToBounds = true
        
        setupAlertController()
        getData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.editing = false
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
    
    /// Copies the data of the original ethogram into a temporary ethogram for editing.
    func getData() {
        if originalEthogram != nil {
            // Enables deletion if this ethogram is not being used
            deletionEnabled = !ProjectManager.sharedInstance.isEthogramInProjects(originalEthogram!)
            
            // Copy over original ethogram
            ethogram = Ethogram()
            ethogram.updateName(originalEthogram!.name)
            for s in originalEthogram!.behaviourStates {
                let state = BehaviourState(name: s.name, information: s.information)
                ethogram.addBehaviourState(state)
            }
        }
    }
    
    /// Copies over the edited behaviour states into the original ethogram.
    func saveData() -> Bool {
        if originalEthogram != nil && ethogram.behaviourStates.count != 0 {
            
            originalEthogram!.updateName(ethogram.name)
            
            for (var i = 0; i < ethogram.behaviourStates.count; i++) {
                if i < originalEthogram!.behaviourStates.count {
                    originalEthogram!.behaviourStates[i].updateName(ethogram.behaviourStates[i].name)
                    originalEthogram!.behaviourStates[i].updateInformation(ethogram.behaviourStates[i].name)
                } else {
                    originalEthogram!.addBehaviourState(ethogram.behaviourStates[i])
                }
            }
            return true
        } else {
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
    }
    
    func refreshView() {
        self.tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource AND UITableViewDelegate METHODS
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == firstSection {
            return getCellForFirstSection(indexPath)
        } else {
            return getCellForSecondSection(indexPath)
        }
    }
    
    /// Sets up data in the cells
    func getCellForFirstSection(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(nameCellIdentifier) as! SingleLineTextCell
        println(ethogram.name)
        cell.textField.userInteractionEnabled = editable
        
        cell.label.text = "Name"
        cell.textField.text = ethogram.name
        cell.textField.addTarget(self, action: Selector("nameRowDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
        
        return cell
    }
    
    /// Populates behaviour states in second section and sets up listeners for adding new state.
    func getCellForSecondSection(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(stateCellIdentifier) as! BehaviourStateCell
        
        
        let textField = cell.textField
        let textView = cell.textView
        
        // Sets delegates
        textField.delegate = self
        textView.delegate = self
        
        // Remove previous cell targets
        textField.removeTarget(self, action: Selector("extraRowDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
        textField.removeTarget(self, action: Selector("textFieldDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
        
        // Set up cells that have been filled out
        if ethogram.behaviourStates.count > indexPath.row {
            textField.text = ethogram.behaviourStates[indexPath.row].name
            textView.text = ethogram.behaviourStates[indexPath.row].information
            textField.addTarget(self, action: Selector("textFieldDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
            cell.button.tag = indexPath.row
            
        } else if ethogram.behaviourStates.count == indexPath.row {
            textField.text = ""
            textView.text = ""
            textField.placeholder = messageNewState
            textField.addTarget(self, action: Selector("extraRowDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
        }
        
        // Adds borders for text field and text view
        textField.layer.borderColor = UIColor.lightGrayColor().CGColor
        textField.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGrayColor().CGColor
        textView.layer.borderWidth = 1.0
        
        textField.userInteractionEnabled = editable
        textView.userInteractionEnabled = editable
        
        textField.tag = indexPath.row
        textView.tag = indexPath.row
        
        cell.button.hidden = true
        
        return cell
    }
    
    // MARK: TARGETS FOR TEXT FIELDS
    
    /// Updates the name of the ethogram if its field is updated.
    func nameRowDidChange(sender: UITextField) {
        if sender.text != "" {
            ethogram.updateName(sender.text)
        }
    }
    
    /// Sets up the edit button after the existing behaviour states are edited.
    func textFieldDidChange(sender: UITextField) {
        let cell = sender.superview! as! BehaviourStateCell
        if sender.text != "" {
            showEditButton(cell)
        } else {
            sender.placeholder = messageNewState
            cell.button.hidden = true
        }
    }
    
    /// Sets up the add button after a new behaviour states is added.
    func extraRowDidChange(sender: UITextField) {
        let cell = sender.superview! as! BehaviourStateCell
        if sender.text != "" {
            showAddButton(cell)
        } else {
            sender.placeholder = messageNewState
            cell.button.hidden = true
        }
    }
    
    /// Sets the button on the given BehaviourStateCell to an 'Add' button.
    func showAddButton(cell: BehaviourStateCell) {
        cell.button.setTitle("Add", forState: .Normal)
        cell.button.hidden = false
        cell.button.removeTarget(self, action: Selector("editButtonPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
        cell.button.addTarget(self, action: Selector("addButtonPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    /// Sets the button on the given BehaviourStateCell to an 'Edit' button.
    func showEditButton(cell: BehaviourStateCell) {
        cell.button.setTitle("Edit", forState: .Normal)
        cell.button.hidden = false
        cell.button.removeTarget(self, action: Selector("addButtonPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
        cell.button.addTarget(self, action: Selector("editButtonPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    /// Gets the name for the new behaviour state from the cell and updates the behaviour state
    /// of the ethogram, then refreshes the view.
    func editButtonPressed(sender: UIButton) {
        let cell = sender.superview! as! BehaviourStateCell
        ethogram.updateBehaviourStateName(cell.button.tag, bsName: cell.textField.text!)
        ethogram.updateBehaviourStateInformation(cell.button.tag, bsInformation: cell.textView.text!)
        cell.button.hidden = true
        
        refreshView()
    }
    
    /// Gets the name for the new behaviour state from the cell and adds it to the ethogram,
    /// then refreshes the view.
    func addButtonPressed(sender: UIButton) {
        let cell = sender.superview! as! BehaviourStateCell
        
        let state = BehaviourState(name: cell.textField.text!, information: cell.textView.text!)
        ethogram.addBehaviourState(state)
        
        cell.button.hidden = true
        
        refreshView()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if isFirstSection(indexPath.section) {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! SingleLineTextCell
            cell.textField.becomeFirstResponder()
        } else {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! BehaviourStateCell
            cell.textField.becomeFirstResponder()
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numSections
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if isFirstSection(indexPath.section) {
            return firstSectionRowHeight
        } else {
            return secondSectionRowHeight
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if editable {
            return isSecondSection(indexPath.section) && !isExtraRow(indexPath.row)
        } else {
            return false
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if deletionEnabled {
            return UITableViewCellEditingStyle.Delete
        } else {
            return UITableViewCellEditingStyle.None
        }
    }
    
    /// If the cell is deleted, delete the behaviour state related to it.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                
                if !isExtraRow(indexPath.row) {
                    
                    ethogram.removeBehaviourState(indexPath.row)
                    
                    refreshView()
                }
            }
        }
    }
    
    // MARK: UITextFieldDelegate METHODS
    
    /// After user presses enter key, call the methods to update the behaviour states.
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
    
    // MARK: UITextViewDelegate methods
    
    /// Shows the edit button if an existing behaviour state's information is edited.
    func textViewDidChange(textView: UITextView) {
        let cell = textView.superview as! BehaviourStateCell
        if !isExtraRow(textView.tag) {
            showEditButton(cell)
        }
    }
    
    // MARK: HELPER METHODS
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