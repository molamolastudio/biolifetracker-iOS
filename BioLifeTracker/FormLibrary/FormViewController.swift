//
//  FormViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 28/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class FormViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    let defaultCellHeight: CGFloat = 44
    
    let popup = CustomPickerPopup()
    
    var alert = UIAlertController()
    let alertTitle = "Pick Photo From"
    var alertCaller: PhotoPickerCell? = nil
    
    var fields: FormFieldData? = nil
    var editable: Bool = true // Determines if the cells can be edited.
    var roundedCells: Bool = false // Determines if the cells have rounded corners.
    
    // Variables for the amount of cell padding.
    var cellHorizontalPadding: CGFloat = 0
    var cellVerticalPadding: CGFloat = 0
    
    var nibNames = ["SingleLineTextCell", "MultiLineTextCell", "BooleanPickerCell", "DatePickerCell", "DefaultPickerCell", "CustomPickerCell", "PhotoPickerCell", "ButtonCell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for var i = 0; i < nibNames.count; i++ {
            self.tableView.registerNib(UINib(nibName: nibNames[i], bundle: nil), forCellReuseIdentifier: nibNames[i])
        }
        setupAlertController()
    }
    
    // Creates a UIAlertController to display a menu for choosing a source for picking photos.
    func setupAlertController() {
        alert = UIAlertController(title: alertTitle, message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let actionCamera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: { UIAlertAction in self.openCameraPicker()})
            alert.addAction(actionCamera)
        }
        
        let actionGallery = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default, handler: { UIAlertAction in self.openGalleryPicker()})
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alert.addAction(actionGallery)
        alert.addAction(actionCancel)
    }
    
    func openCameraPicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func openGalleryPicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func getFormData() -> [AnyObject?] {
        var result: [AnyObject?] = []
        for var i = 0; i < fields!.getNumberOfSections(); i++ {
            for var j = 0; j < fields!.getNumberOfRowsForSection(i); j++ {
                let cell = self.tableView!.cellForRowAtIndexPath(NSIndexPath(forRow: j, inSection: i)) as! FormCell
                result.append(cell.getValueFromCell())
            }
        }
        return result
    }
    
    func setFormData(data: FormFieldData) {
        fields = data
    }
    
    // Displays the CustomPickerPopup view and sets up the values for the picker.
    func showPicker(sender: UIButton) {
        if let cell = sender.superview as? ButtonCell {
            popup.modalPresentationStyle = .Popover
            popup.preferredContentSize = CGSizeMake(400, 400)
            
            popup.data = cell.pickerValues
            
            // Sets the currently selected index if it exists.
            if let index = cell.selectedValue as? Int {
                popup.selectedIndex = index
            }
            
            let popoverController = popup.popoverPresentationController!
            popoverController.permittedArrowDirections = .Any
            popoverController.delegate = self
            popoverController.sourceView = cell
            popoverController.sourceRect = cell.frame
            
            presentViewController(popup, animated: true, completion: nil)
        }
    }
    
    // Displays the PhotoPickerViewController and sets up the values for the picker.
    func showPhotoPicker(sender: UIButton) {
        if let cell = sender.superview as? PhotoPickerCell {
            alertCaller = cell
            alert.popoverPresentationController!.sourceView = sender
            self.parentViewController!.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // UIImagePickerControllerDelegate methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            if alertCaller != nil {
                alertCaller!.setSelectedImageView(image)
            }
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // UITableViewControllerDataSource and UITableViewDelegate methods
    // Returns a UITableViewCell based on the type of field in the given index path.
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = FormCell()
        if fields != nil {
            if let field = fields!.getFieldForIndex(indexPath) {
                switch field.type {
                case .TextSingleLine:
                    cell = getSingleLineTextCell(field, indexPath: indexPath)
                    break
                case .TextMultiLine:
                    cell = getMultiLineTextCell(field, indexPath: indexPath)
                    break
                case .PickerBoolean:
                    cell = getBooleanPickerCell(field, indexPath: indexPath)
                    break
                case .PickerDate:
                    cell = getDatePickerCell(field, indexPath: indexPath)
                    break
                case .PickerDefault:
                    cell = getDefaultPickerCell(field, indexPath: indexPath)
                    break
                case .PickerCustom:
                    cell = getCustomPickerCell(field, indexPath: indexPath)
                    break
                case .PickerPhoto:
                    cell = getPhotoPickerCell(field, indexPath: indexPath)
                    break
                case .Button:
                    cell = getButtonCell(field, indexPath: indexPath)
                    break
                default:
                    break
                }
            }
        }
        
        cell.horizontalPadding = cellHorizontalPadding
        cell.verticalPadding = cellVerticalPadding
        cell.rounded = roundedCells
        
        return cell
    }
    
    // Returns the cell height depending on the type of cell in the row.
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if fields != nil {
            if let type = fields!.getFieldTypeForIndex(indexPath) {
                if type == FormField.FieldType.TextMultiLine ||
                    type == FormField.FieldType.PickerDate ||
                    type == FormField.FieldType.PickerDefault ||
                    type == FormField.FieldType.PickerPhoto {
                        return defaultCellHeight * 3
                }
            }
        }
        return defaultCellHeight
    }
    
    // Creates a SingleLineTextCell with values as specified in the FormField.
    func getSingleLineTextCell(field: FormField, indexPath: NSIndexPath) -> FormCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            nibNames[FormField.FieldType.TextSingleLine.rawValue]) as! SingleLineTextCell
        
        cell.label.text = field.label
        if let text = field.value as? String {
            cell.textField.text = text
        }
        
        cell.textField.enabled = editable
        
        return cell
    }
    
    // Creates a MultiLineTextCell with values as specified in the FormField.
    func getMultiLineTextCell(field: FormField, indexPath: NSIndexPath) -> FormCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            nibNames[FormField.FieldType.TextMultiLine.rawValue]) as! MultiLineTextCell
        
        cell.label.text = field.label
        if let text = field.value as? String {
            cell.textView.text = text
        }
        
        cell.textView.editable = editable
        
        return cell
    }
    
    // Creates a BooleanPickerCell with values as specified in the FormField.
    func getBooleanPickerCell(field: FormField, indexPath: NSIndexPath) -> FormCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            nibNames[FormField.FieldType.PickerBoolean.rawValue]) as! BooleanPickerCell
        
        cell.label.text = field.label
        if let value = field.value as? Bool {
            cell.booleanSwitch.on = value
        }
        
        cell.booleanSwitch.enabled = editable
        
        return cell
    }
    
    // Creates a DatePickerCell with values as specified in the FormField.
    func getDatePickerCell(field: FormField, indexPath: NSIndexPath) -> FormCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            nibNames[FormField.FieldType.PickerDate.rawValue]) as! DatePickerCell
        
        cell.label.text = field.label
        if let value = field.value as? NSDate {
            cell.datePicker.date = value
        }
        
        cell.datePicker.enabled = editable
        
        return cell
    }
    
    // Creates a DefaultPickerCell with values as specified in the FormField.
    func getDefaultPickerCell(field: FormField, indexPath: NSIndexPath) -> FormCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            nibNames[FormField.FieldType.PickerDefault.rawValue]) as! DefaultPickerCell
        
        cell.label.text = field.label
        cell.values = field.pickerValues
        cell.picker.dataSource = cell
        cell.picker.delegate = cell
        
        if let value = field.value as? Int {
            cell.picker.selectRow(value, inComponent: 0, animated: true)
        }
        
        cell.picker.userInteractionEnabled = editable
        
        return cell
    }
    
    // Creates a ButtonCell with label and picker values as specified in the FormField.
    // Sets its button action to call the 'showPicker()' method of this controller.
    // Sets the new cell as the given target's delegate.
    func getCustomPickerCell(field: FormField, indexPath: NSIndexPath) -> FormCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            nibNames[FormField.FieldType.Button.rawValue]) as! ButtonCell
        
        cell.label.text = field.label
        cell.button.setTitle("Select", forState: .Normal)
        cell.pickerValues = field.pickerValues
        
        cell.setSelectorForButton(self, action: Selector("showPicker:"))
        
        popup.delegate = cell
        
        if let index = field.value as? Int {
            cell.userDidSelectValue(index, valueAsString: field.pickerValues[index])
        }
        
        cell.button.enabled = editable
        
        return cell
    }
    
    func getPhotoPickerCell(field: FormField, indexPath: NSIndexPath) -> FormCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            nibNames[FormField.FieldType.PickerPhoto.rawValue]) as! PhotoPickerCell
        
        cell.label.text = field.label
        cell.button.setTitle("Pick Image", forState: .Normal)
        
        cell.setSelectorForButton(self, action: Selector("showPhotoPicker:"))
        
        if let image = field.value as? UIImage {
            cell.setSelectedImageView(image)
        }
        
        cell.button.enabled = editable
        
        return cell
    }
    
    // Creates a ButtonCell with label, button title and target as specified in the FormField.
    // Sets the new cell as the given target's delegate.
    func getButtonCell(field: FormField, indexPath: NSIndexPath) -> FormCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            nibNames[FormField.FieldType.Button.rawValue]) as! ButtonCell
        cell.label.text = field.label
        
        if let buttonTitle = field.buttonValues[0] as? String {
            cell.button.setTitle(buttonTitle, forState: .Normal)
        }
        
        if let target: AnyObject = field.buttonValues[1] {
            if let action = field.buttonValues[2] as? String {
                cell.setSelectorForButton(target, action: Selector(action))
                if let popup = field.buttonValues[3] as? FormPopupController {
                    popup.delegate = cell
                }
            }
        }
        
        // Set the currently selected values
        let selectedValue: AnyObject? = field.buttonValues[4]
        
        // To Michelle: There were some errors over here so I commented them out -Nicholette
        //       let selectedValueAsString = field.buttonValues[5] as String
        //       cell.userDidSelectValue(selectedValue, valueAsString: selectedValueAsString)
        
        cell.button.enabled = editable
        
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch fields!.getFieldTypeForIndex(indexPath)! {
        case .TextSingleLine:
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! SingleLineTextCell
            cell.textField.becomeFirstResponder()
            break
        case .TextMultiLine:
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! MultiLineTextCell
            cell.textView.becomeFirstResponder()
            break
        default:
            break
        }
    }
    
    // UIPopoverPresentationControllerDelegate method
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle{
        return .None
    }
}
