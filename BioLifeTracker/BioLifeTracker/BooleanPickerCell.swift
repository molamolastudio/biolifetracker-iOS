//
//  BooleanPickerCell.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 30/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class BooleanPickerCell: UITableViewCell, FormCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var booleanSwitch: UISwitch!
    
    func getValueFromCell() -> AnyObject? {
        return booleanSwitch.on
    }
}
