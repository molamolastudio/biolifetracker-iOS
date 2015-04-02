//
//  DatePickerCell.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 2/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class DatePickerCell: FormCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func getValueFromCell() -> AnyObject? {
        return datePicker!.date
    }
}
