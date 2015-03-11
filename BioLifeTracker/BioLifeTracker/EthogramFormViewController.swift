//
//  EthogramFormViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 11/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class EthogramFormViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tagCellLabel = 200
    let tagCellTextField = 201
    let tagCellFullTextField = 202
    
    let cellReuseLabelAndText = "LabelWithTextField"
    let cellReuseTextField = "TextFieldOnly"
    
    let numSections = 2
    let firstSection = 0
    let secondSection = 1
    let sectionTitles = ["Details", "Behaviour States"]
    
    let firstSectionNumRows = 2
    let firstSectionRowTitles = []
    
    var secondSectionNumRows = 1
    var secondSectionRowTitles = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // UITableViewDataSource and UITableViewDelegate METHODS
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == firstSection {
            let cell = self.tableView.dequeueReusableCellWithIdentifier(cellReuseLabelAndText) as UITableViewCell
            
            return cell
        } else {
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
}