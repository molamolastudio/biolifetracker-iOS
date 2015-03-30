//
//  FormField.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 30/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class FormField {
    enum Type {
        case TextSingleLine
        case TextMultiLine
        case PickerBoolean
        case PickerDate
        case PickerDefault
        case PickerCustom
        case PickerPhoto
    }
    
    var label: String
    var values: [AnyObject?] = []
    
    init() {
        label = ""
    }
    
    init(label: String, values: [AnyObject?]) {
        self.label = label
        self.values = values
    }
}