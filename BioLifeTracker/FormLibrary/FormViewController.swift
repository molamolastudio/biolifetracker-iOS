//
//  FormViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 28/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//
//  This controller accepts a FormFieldData object and uses the data
//  to populate its table view and create a form for the user.
//
//  This controller contains methods to initialise and set up various
//  types of FormCells which accept a form of user input and return
//  a value. It also contains methods to set up alerts, popover controllers,
//  and custom popups for its cells.
//
//  The parent controller can retrieve all values from the cells of this
//  controller by calling 'getFormData', which returns an array of all
//  the values of this form.
//
//  There are 4 main customisation options available: if the form is
//  editable, if the cells appear rounded, and horizontal and vertical
//  padding for the table view within this controller's view, or the
//  table view's cells.

import UIKit

class FormViewController: UIViewController, UITableViewDataSource,
                          UITableViewDelegate, UIImagePickerControllerDelegate,
                          UINavigationControllerDelegate,
                          UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let defaultCellHeight: CGFloat = 44
    
    let popup = CustomPickerPopup()
    
    var alert = UIAlertController()
    let alertTitle = "Pick Photo From"
    var alertCaller: PhotoPickerCell? = nil
    
    // Contains data on the types of cells to create for each row of this form.
    var fields: FormFieldData? = nil
    
    var editable: Bool = true // Determines if the cells can be edited.
    var roundedCells: Bool = false // Determines if the cells have rounded corners.
    
    // Variables for the padding between this view and its child tableview
    var horizontalPadding: CGFloat = 0
    var verticalPadding: CGFloat = 0
    
    // Variables for the amount of cell padding.
    var cellHorizontalPadding: CGFloat = 0
    var cellVerticalPadding: CGFloat = 0
    
    var nibNames = ["SingleLineTextCell", "MultiLineTextCell",
                    "BooleanPickerCell", "DatePickerCell", "DefaultPickerCell",
                    "CustomPickerCell", "PhotoPickerCell", "ButtonCell"]
    
    override func loadView() {
        self.view = NSBundle.mainBundle().loadNibNamed("FormView", owner: self,
                    options: nil).first as! UIView
    }
    
    /// Sets the frame of the table view, registers the nibs for the FormCells 
    /// used and sets up the alert controller.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.frame = CGRectMake(
            self.view.frame.origin.x + horizontalPadding,
            self.view.frame.origin.y + verticalPadding,
            self.view.frame.width + 2 * horizontalPadding,
            self.view.frame.height + 2 * verticalPadding)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        for var i = 0; i < nibNames.count; i++ {
            self.tableView.registerNib(UINib(nibName: nibNames[i], bundle: nil), forCellReuseIdentifier: nibNames[i])
        }
        setupAlertController()
    }
    
    /// Creates a UIAlertController to display a menu for choosing a source for 
    /// picking photos.
    func setupAlertController() {
        alert = UIAlertController(title: alertTitle, message: "",
            preferredStyle: .ActionSheet)
        
        // Checks if the camera is available
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
                
            let actionCamera = UIAlertAction(title: "Camera", style: .Default,
                handler: { UIAlertAction in self.openCameraPicker()})
                
            alert.addAction(actionCamera)
        }
        
        let actionGallery = UIAlertAction(title: "Gallery", style: .Default,
            handler: { UIAlertAction in self.openGalleryPicker()})
        let actionCancel = UIAlertAction(title: "Cancel", style: .Cancel,
            handler: nil)
        
        alert.addAction(actionGallery)
        alert.addAction(actionCancel)
    }
    
    func openCameraPicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .Camera
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func openGalleryPicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .PhotoLibrary
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    /// Returns an array of AnyObject? after retrieving the values from each cell 
    /// defined in this form.
    func getFormData() -> [AnyObject?] {
        var result: [AnyObject?] = []
        for var i = 0; i < fields!.getNumberOfSections(); i++ {
            for var j = 0; j < fields!.getNumberOfRowsForSection(i); j++ {
                
                let index = NSIndexPath(forRow: j, inSection: i)
                let cell = tableView.cellForRowAtIndexPath(index) as! FormCell
                result.append(cell.getValueFromCell())
            }
        }
        return result
    }
    
    func setFormData(data: FormFieldData) {
        fields = data
    }

    /// Displays the CustomPickerPopup view and sets up the values for the picker.
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
            popoverController.sourceView = cell.button
            popoverController.sourceRect = CGRectMake(0, 0, 0, 0)
            
            presentViewController(popup, animated: true, completion: nil)
        }
    }
    
    /// Displays the PhotoPickerViewController and sets up the values for the 
    /// picker.
    func showPhotoPicker(sender: UIButton) {
        if let cell = sender.superview as? PhotoPickerCell {
            alertCaller = cell
            alert.popoverPresentationController!.sourceView = sender
            self.parentViewController!.presentViewController(alert,
                animated: true, completion: nil)
        }
    }
    
    // MARK: UIImagePickerControllerDelegate METHODS
    
    /// Sets the image view of the caller after an image is picked.
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
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
    
    // MARK: UITableViewControllerDataSource AND UITableViewDelegate METHODS
    
    /// Returns a UITableViewCell based on the type of field in the given index.
    func tableView(tableView: UITableView, cellForRowAtIndexPath
                   indexPath: NSIndexPath) -> UITableViewCell {
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
    
    /// Returns the cell height depending on the type of cell in the row.
    func tableView(tableView: UITableView, heightForRowAtIndexPath
        indexPath: NSIndexPath) -> CGFloat {
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
    
    /// Creates a SingleLineTextCell with values as specified in the FormField.
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
    
    /// Creates a MultiLineTextCell with values as specified in the FormField.
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
    
    /// Creates a BooleanPickerCell with values as specified in the FormField.
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
    
    /// Creates a DatePickerCell with values as specified in the FormField.
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
    
    /// Creates a DefaultPickerCell with values as specified in the FormField.
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
    
    /// Creates a CustomPickerCell with label and picker values as specified in 
    /// the FormField.
    /// Sets its button action to call the 'showPicker()' method of this controller.
    /// Sets the new cell as the given target's delegate.
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
    
    /// Creates a PhotoPickerCell with label and image as specified in the FormField.
    /// Sets its button action to call the 'showPhotoPicker()' method of this controller.
    /// Sets the new cell as the given target's delegate.
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
    
    /// Creates a ButtonCell with label, button title and target as specified in 
    //// the FormField.
    /// Sets the new cell as the given target's delegate.
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
        
        cell.button.enabled = editable
        
        return cell
    }
    
    // MARK: UITableView METHODS
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if fields != nil {
            return fields!.getNumberOfSections()
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int)
        -> String? {
        if fields != nil {
            return fields!.getSectionTitle(section)
        } else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
        if fields != nil {
            return fields!.getNumberOfRowsForSection(section)
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath
        indexPath: NSIndexPath) {
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
    
    // MARK: UIPopoverPresentationControllerDelegate METHODS
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}
