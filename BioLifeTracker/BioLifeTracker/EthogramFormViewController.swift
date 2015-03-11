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
    
    let tagCellLabel = 200
    let tagCellTextField = 201
    let tagCellFullTextField = 202
    
    let tagNameField = 203
    let tagCodeField = 204
    
    let cellReuseLabelAndText = "LabelWithTextField"
    let cellReuseTextField = "TextFieldOnly"
    
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
    
    // For segues
    var source: UIViewController? = nil
    
    // Collected data
    var ethogram: Ethogram?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if ethogram == nil {
            ethogram = Ethogram()  // Create a blank ethogram to fill in.
        }
    }
    
    // UITableViewDataSource and UITableViewDelegate METHODS
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Fill in static data for first section and setup listeners for text fields
        if indexPath.section == firstSection {
            let cell = self.tableView.dequeueReusableCellWithIdentifier(cellReuseLabelAndText) as UITableViewCell
            
            let label = cell.viewWithTag(tagCellLabel) as UILabel
            let textField = cell.viewWithTag(tagCellTextField) as UITextField
            
            label.text = firstSectionRowTitles[indexPath.row]
            textField.delegate = self
            
            if indexPath.row == firstRow {
                textField.tag = tagNameField
            } else {
                textField.tag = tagCodeField
                textField.text = ethogram?.id
            }
            
            return cell
        } else {
            // Populate behaviour states in second section
            let cell = self.tableView.dequeueReusableCellWithIdentifier(cellReuseTextField) as UITableViewCell
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == firstSection {
            return firstSectionNumRows
        } else {
            return secondSectionNumRows
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numSections
    }
    
    // UITextFieldDelegate METHODS
    
    // Updates data for the ethogram being created when user finishes keying in text
    func textFieldDidEndEditing(textField: UITextField) {
        switch textField.tag {
        case tagNameField:
            ethogram!.name = textField.text
            break
        case tagCodeField:
            ethogram!.code = textField.text
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
    
}