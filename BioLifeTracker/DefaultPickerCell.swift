//
//  DefaultPickerCell.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 2/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class DefaultPickerCell: FormCell, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    
    var values: [String] = []
    var selectedRow: Int = 0
    
    override func getValueFromCell() -> AnyObject? {
        return values[selectedRow]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return values[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
}
