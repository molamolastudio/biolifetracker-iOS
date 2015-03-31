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
    var editable: Bool = true // Determines if the cells can be edited.
    
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
                let cell = self.tableView!.cellForRowAtIndexPath(NSIndexPath(forRow: j, inSection: i)) as FormCell
                result.append(cell.getValueFromCell())
            }
        }
        return result
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if fields != nil {
            if let field = fields!.getFieldForIndex(indexPath) {
                switch field.type {
                case .TextSingleLine:
                    return getSingleLineTextCell(field, indexPath: indexPath)
                case .TextMultiLine:
                    return getMultiLineTextCell(field, indexPath: indexPath)
                case .PickerBoolean:
                    return getBooleanPickerCell(field, indexPath: indexPath)
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
    
    func getSingleLineTextCell(field: FormField, indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            nibNames[FormField.FieldType.TextSingleLine.rawValue]) as SingleLineTextCell

        cell.label.text = field.label
        if let text = field.value as? String {
            cell.textField.text = text
        }
        
        if editable {
            cell.textField.enabled = true
        }
        
        return cell
    }
    
    func getMultiLineTextCell(field: FormField, indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            nibNames[FormField.FieldType.TextMultiLine.rawValue]) as MultiLineTextCell
        
        cell.label.text = field.label
        if let text = field.value as? String {
            cell.textField.text = text
        }
        
        if editable {
            cell.textField.enabled = true
        }
        
        return cell
    }
    
    func getBooleanPickerCell(field: FormField, indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            nibNames[FormField.FieldType.PickerBoolean.rawValue]) as BooleanPickerCell
        
        cell.label.text = field.label
        if let value = field.value as? Bool {
            cell.booleanSwitch.on = value
        }
        
        if editable {
            cell.booleanSwitch.enabled = true
        }
        
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
