//
//  FormFieldData.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 28/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//
//  This class holds data required to initialise the fields of a FormViewController.
//  The user is expected to add fields to this object and pass it to a FormViewController
//  to populate its view.
//

import Foundation

class FormFieldData {
    // Private variables that should not be modified by the user.
    private var sections: Int
    private var sectionTitles: [String] = []
    private var fields = [Int: [FormField]]()
    
    // Creates a FormFieldData with 1 section.
    init() {
        self.sections = 1
        setupSections()
    }
    
    // Creates a FormFieldData with the supplied number of sections. Must have at least 1 section.
    // If the sections value is less than 1, the value is defaulted to 1.
    init(sections: Int) {
        if sections > 0 {
            self.sections = sections
        } else {
            self.sections = 1
        }
        setupSections()
    }
    
    // Initialise the sections in the dictionary.
    func setupSections() {
        for var i = 0; i < sections; i++ {
            fields[i] = []
            sectionTitles.append("")
        }
    }
    
    // Sets the header title for the specified section.
    // If the section does not exist, does nothing.
    func setSectionTitle(section: Int, title: String) {
        if section < sections {
            sectionTitles[section] = title
        }
    }
    
    // Returns the header title for the specified section.
    // If the section does not exist, does nothing.
    func getSectionTitle(section: Int) -> String? {
        if section < sections {
            return sectionTitles[section]
        } else {
            return nil
        }
    }
    
    // Adds a text cell to the first section of the form, unless specified.
    // If the section does not exist, does nothing.
    func addTextCell(section: Int = 0, label: String, hasSingleLine: Bool, value: AnyObject? = nil) {
        if let var array = fields[section] {
            var field = FormField()
            if hasSingleLine {
                field.type = FormField.FieldType.TextSingleLine
            } else {
                field.type = FormField.FieldType.TextMultiLine
            }
            
            field.label = label
            
            if value != nil {
                field.value = value
            }
            array.append(field)
            fields[section] = array
        }
    }
    
    // Adds a boolean picker cell to the first section of the form, unless specified.
    // If the section does not exist, does nothing.
    func addBooleanCell(section: Int = 0, label: String, value: AnyObject? = nil) {
        if let var array = fields[section] {
            var field = FormField()
            
            field.type = FormField.FieldType.PickerBoolean
            field.label = label
            
            if value != nil {
                field.value = value
            }
            array.append(field)
            fields[section] = array
        }
    }
    
    // Adds a date picker cell to the first section of the form, unless specified.
    // If the section does not exist, does nothing.
    func addDatePickerCell(section: Int = 0, label: String, value: AnyObject? = nil) {
        if let var array = fields[section] {
            var field = FormField()
            
            field.type = FormField.FieldType.PickerDate
            field.label = label
            
            if value != nil {
                field.value = value
            }
            array.append(field)
            fields[section] = array
        }
    }
    
    // Adds a picker cell with the given values to the first section of the form, unless specified.
    // If the section does not exist, does nothing.
    func addPickerCell(section: Int = 0, label: String, pickerValues: [String], isCustomPicker: Bool, value: AnyObject? = nil) {
        if let var array = fields[section] {
            var field = FormField()
            
            if isCustomPicker {
                field.type = FormField.FieldType.PickerCustom
            } else {
                field.type = FormField.FieldType.PickerDefault
            }
            
            field.label = label
            
            if value != nil {
                field.value = value
            }
            array.append(field)
            fields[section] = array
        }
    }
    
    // Adds a photo picker cell to the first section of the form, unless specified.
    // If the section does not exist, does nothing.
    func addPhotoPickerCell(section: Int = 0, label: String, value: AnyObject? = nil) {
        if let var array = fields[section] {
            var field = FormField()
            
            field.type = FormField.FieldType.PickerPhoto
            field.label = label
            
            if value != nil {
                field.value = value
            }
            array.append(field)
            fields[section] = array
        }
    }
    
    // Returns the field for the specified index path in this form.
    // If the section or row does not exist, returns nil.
    func getFieldForIndex(index: NSIndexPath) -> FormField? {
        if let var array = fields[index.section] {
            if index.row < array.count {
                return array[index.row]
            }
        }
        return nil
    }
    
    // Returns the field type for the specified index path in this form.
    // If the section or row does not exist, returns nil.
    func getFieldTypeForIndex(index: NSIndexPath) -> FormField.FieldType? {
        if let field = getFieldForIndex(index) {
            return field.type
        } else {
            return nil
        }
    }
    
    // Returns the field label for the specified index path in this form.
    // If the section or row does not exist, returns nil.
    func getLabelForIndex(index: NSIndexPath) -> String? {
        if let field = getFieldForIndex(index) {
            return field.label
        } else {
            return nil
        }
    }
    
    // Returns the field picker values for the specified index path in this form.
    // If the section or row does not exist or the field has no picker values, returns nil.
    func getPickerValuesForIndex(index: NSIndexPath) -> [AnyObject?]? {
        if let field = getFieldForIndex(index) {
            return field.pickerValues
        } else {
            return nil
        }
    }
    
    // Returns the field value for the specified index path in this form.
    // If the section or row does not exist or the field has no value, returns nil.
    func getValueForIndex(index: NSIndexPath) -> AnyObject? {
        if let field = getFieldForIndex(index) {
            return field.value
        } else {
            return nil
        }
    }
    
    // Returns the number of sections in this form.
    func getNumberOfSections() -> Int {
        return sections
    }
    
    // Returns the number of rows in the specified section in this form.
    // If the section does not exist, returns 0.
    func getNumberOfRowsForSection(section: Int) -> Int {
        if let var array = fields[section] {
            return array.count
        } else {
            return 0
        }
    }
}
