//
//  FormViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 28/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class FormViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    // table view
    var fields: FormFieldData? = nil
    
    override func viewDidLoad() {
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "")
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if fields != nil {
            switch fields!.getFieldTypeForIndex(indexPath) {
            case .TextSingleLine:
                break
            case .TextMultiLine:
                break
            case .PickerBoolean:
                break
            case .PickerDate:
                break
            case .PickerDefault:
                break
            case .PickerCustom:
                break
            case .PickerPhoto:
                break
            case .Empty:
                break
            default:
                break
            }
        }
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if fields != nil {
            return fields!.getSectionTitle(section)
        } else {
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fields != nil {
            return fields!.getNumberOfRowsForSection(section)
        } else {
            return 0
        }
    }
}
