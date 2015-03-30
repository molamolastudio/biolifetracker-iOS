//
//  FormField.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 30/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class FormField {
    enum FieldType {
        case TextSingleLine
        case TextMultiLine
        case PickerBoolean
        case PickerDate
        case PickerDefault
        case PickerCustom
        case PickerPhoto
        case Empty
    }
    
    var type: FieldType
    var label: String
    var values: [AnyObject?] = []
    
    init(type: FieldType) {
        self.type = type
        label = ""
    }
    
    init(type: FieldType, label: String) {
        self.type = type
        self.label = label
    }
    
    init(type: FieldType, label: String, values: [AnyObject?]) {
        self.type = type
        self.label = label
        self.values = values
    }
}