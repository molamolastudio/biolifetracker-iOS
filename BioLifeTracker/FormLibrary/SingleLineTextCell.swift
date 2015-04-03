//
//  SingleLineTextCell.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 30/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class SingleLineTextCell: FormCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func getValueFromCell() -> AnyObject? {
        return textField.text
    }
}
