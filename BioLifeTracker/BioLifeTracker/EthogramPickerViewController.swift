//
//  EthogramPickerViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 11/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class EthogramPickerViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    let fileName = "EthogramPickerCell"
    let cellReuseIdentifier = "PickerCell"
    
    let numSections = 1
    
    var selectedIndex: Int? = nil
    
    var data: [String] = []
    
    override init() {
        super.init()
        tableView.registerNib(UINib(nibName: fileName, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell
        
        let text = cell.viewWithTag(Constants.ViewTags.pickerCell)
        
        if selectedIndex != nil {
            if indexPath.row == selectedIndex {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numSections
    }

}
