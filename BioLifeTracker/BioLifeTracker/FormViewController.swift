//
//  FormViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 28/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class FormViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    var fields: FormFieldData? = nil
    
    var nibNames = ["FormSingleLineTextCell", "FormMultiLineTextCell", "FormBooleanPickerCell"]
    
    override func viewDidLoad() {
        for var i = 0; i < nibNames.count; i++ {
            self.tableView.registerNib(UINib(nibName: nibNames[i], bundle: nil), forCellReuseIdentifier: nibNames[i])
        }
    }
    
    func getFormData() -> [AnyObject?] {
        var result: [AnyObject?] = []
        for var i = 0; i < fields!.getNumberOfSections(); i++ {
            for var j = 0; j < fields!.getNumberOfRowsForSection(i); j++ {
                let cell = self.tableView!.cellForRowAtIndexPath(NSIndexPath(i, j)) as FormCell
                result.append(cell.getValueFromCell())
            }
        }
        return result
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if fields != nil {
            if let type = fields!.getFieldTypeForIndex(indexPath) {
                switch type {
                case .TextSingleLine:
                    return getSingleLineTextCell(indexPath)
                case .TextMultiLine:
                    return getMultiLineTextCell(indexPath)
                case .PickerBoolean:
                    return getBooleanPickerCell(indexPath)
                case .PickerDate:
                    break
                case .PickerDefault:
                    break
                case .PickerCustom:
                    break
                case .PickerPhoto:
                    break
                default:
                    break
                }
            }
        }
        return UITableViewCell()
    }
    
    func getSingleLineTextCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            nibNames[FormField.FieldType.TextSingleLine.rawValue]) as SingleLineTextCell
        
        cell.label.text = fields!.getLabelForIndex(indexPath)
        
        return cell
    }
    
    func getMultiLineTextCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            nibNames[FormField.FieldType.TextMultiLine.rawValue]) as MultiLineTextCell
        
        cell.label.text = fields!.getLabelForIndex(indexPath)
        
        return cell
    }
    
    func getBooleanPickerCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            nibNames[FormField.FieldType.PickerBoolean.rawValue]) as BooleanPickerCell
        
        cell.label.text = fields!.getLabelForIndex(indexPath)
        
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if fields != nil {
            return fields!.getNumberOfSections()
        } else {
            return 1
        }
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
