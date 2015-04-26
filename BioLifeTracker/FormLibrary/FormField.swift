//
//  FormField.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 30/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

///  This class defines a FormField object, to be used in FormFieldData.
///  A FormField object contains a FieldType, a label and values which
///  will be used to initialise a FormFieldCell view.
///  Its values are publicly accessible and must not be nil.
class FormField {
    enum FieldType: Int {
        case TextSingleLine = 0
        case TextMultiLine = 1
        case PickerBoolean = 2
        case PickerDate = 3
        case PickerDefault = 4
        case PickerCustom = 5
        case PickerPhoto = 6
        case Button = 7
    }
    
    var type: FieldType
    var label: String
    var value: AnyObject?
    var pickerValues: [String] = []
    var buttonValues: [AnyObject?] = []
    
    init() {
        self.type = FieldType.TextSingleLine
        self.label = ""
    }
    
    init(type: FieldType) {
        self.type = type
        self.label = ""
    }
    
    init(type: FieldType, label: String) {
        self.type = type
        self.label = label
    }
    
    init(type: FieldType, label: String, pickerValues: [String]) {
        self.type = type
        self.label = label
        self.pickerValues = pickerValues
    }
}