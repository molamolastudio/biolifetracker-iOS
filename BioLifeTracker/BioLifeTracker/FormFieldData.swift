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
    func addTextCell(section: Int = 0, label: String, hasSingleLine: Bool) {
        if let var array = fields[section] {
            if hasSingleLine {
                array.append(FormField(type: FormField.FieldType.TextSingleLine, label: label))
            } else {
                array.append(FormField(type: FormField.FieldType.TextMultiLine, label: label))
            }
        }
    }
    
    // Adds a boolean picker cell to the first section of the form, unless specified.
    // If the section does not exist, does nothing.
    func addBooleanCell(section: Int = 0, label: String) {
        if let var array = fields[section] {
            array.append(FormField(type: FormField.FieldType.PickerBoolean, label: label))
        }
    }
    
    // Adds a date picker cell to the first section of the form, unless specified.
    // If the section does not exist, does nothing.
    func addDatePickerCell(section: Int = 0, label: String) {
        if let var array = fields[section] {
            array.append(FormField(type: FormField.FieldType.PickerDate, label: label))
        }
    }
    
    // Adds a picker cell with the given values to the first section of the form, unless specified.
    // If the section does not exist, does nothing.
    func addPickerCell(section: Int = 0, label: String, values: [String], isCustomPicker: Bool) {
        if let var array = fields[section] {
            if isCustomPicker {
                array.append(FormField(type: FormField.FieldType.PickerCustom , label: label, values: values))
            } else {
                array.append(FormField(type: FormField.FieldType.PickerDefault , label: label, values: values))
            }
        }
    }
    
    // Adds a photo picker cell to the first section of the form, unless specified.
    // If the section does not exist, does nothing.
    func addPhotoPickerCell(section: Int = 0, label: String) {
        if let var array = fields[section] {
            array.append(FormField(type: FormField.FieldType.PickerPhoto , label: label))
        }
    }
    
    // Returns the field type for the specified index path in this form.
    // If the section or row does not exist, returns FormField.FieldType.Empty.
    func getFieldTypeForIndex(index: NSIndexPath) -> FormField.FieldType {
        if let var array = fields[index.section] {
            if index.row < array.count {
                return array[index.row].type
            } else {
                return FormField.FieldType.Empty
            }
        } else {
            return FormField.FieldType.Empty
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
