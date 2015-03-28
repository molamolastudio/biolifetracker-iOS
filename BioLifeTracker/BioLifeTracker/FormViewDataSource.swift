//
//  FormViewDataSource.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 28/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class FormViewDataSource {
    
    enum FormViewCellType {
        case TextSingleLine
        case TextMultiLine
        case PickerBoolean
        case PickerDate
        case PickerDefault
        case PickerCustom
        case PickerPhoto
    }
    
    var cells: [FormViewCell] = [] // AnyObject?
    
    func addTextCell(label: String, hasSingleLine: Bool) {
        if hasSingleLine {
            
        } else {
            
        }
    }
    
    func addBooleanCell(label: String) {
        
    }
    
    func addDatePickerCell(label: String, dates: [NSDate]) {
        
    }
    
    func addPickerCell(label: String, values: [String], isCustomPicker: Bool) {
        if isCustomPicker {
            
        } else {
            
        }
    }
    
    func addPhotoPickerCell(label: String) {
        
    }
    
    func getAllCells() -> [FormViewCell] {
        return cells
    }
    
}
