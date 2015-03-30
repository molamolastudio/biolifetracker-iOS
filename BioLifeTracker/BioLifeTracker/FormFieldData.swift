//
//  FormFieldData.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 28/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class FormFieldData {
    // Private variables that should not be modified by the user.
    private var sections: Int
    private var fields = [Int: [FormField]]()
    
    let firstSection: Int = 0
    
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
    
    // Adds a text cell to the first section of the form, unless specified.
    func addTextCell(section: Int = 0, label: String, hasSingleLine: Bool) {
        if let var array = fields[section] {
            if hasSingleLine {
                array.append(FormField(type: FormField.FieldType.TextSingleLine, label: label))
            } else {
                array.append(FormField(type: FormField.FieldType.TextMultiLine, label: label))
            }
        }
    }
    
    func addBooleanCell(section: Int = 0, label: String) {
        if let var array = fields[section] {
            array.append(FormField(type: FormField.FieldType.PickerBoolean, label: label))
        }
    }
    
    func addDatePickerCell(section: Int = 0, label: String, dates: [NSDate]) {
        if let var array = fields[section] {
            array.append(FormField(type: FormField.FieldType.PickerDate, label: label, values: dates))
        }
    }
    
    func addPickerCell(section: Int = 0, label: String, values: [String], isCustomPicker: Bool) {
        if let var array = fields[section] {
            if isCustomPicker {
                array.append(FormField(type: FormField.FieldType.PickerCustom , label: label, values: values))
            } else {
                array.append(FormField(type: FormField.FieldType.PickerDefault , label: label, values: values))
            }
        }
    }
    
    func addPhotoPickerCell(section: Int = 0, label: String) {
        if let var array = fields[section] {
            array.append(FormField(type: FormField.FieldType.PickerPhoto , label: label))
        }
    }
    
    func getFieldTypeForIndex(index: NSIndexPath) -> FormField.FieldType {
        if let var array = fields[index.section] {
            return array[index.row].type
        } else {
            return FormField.FieldType.Empty
        }
    }
    
    func getNumberOfSections() -> Int {
        return sections
    }
    
    func getNumberOfRowsForSection(section: Int) -> Int {
        if let var array = fields[section] {
            return array.count
        } else {
            return 0
        }
    }
}
