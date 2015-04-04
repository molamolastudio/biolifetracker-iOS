//
//  ButtonCell.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 4/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class ButtonCell: FormCell, FormPopupDelegate {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var selectedLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var pickerValues: [String] = []
    var selectedValue: AnyObject? = nil
    
    func setSelectorForButton(target: AnyObject, action: Selector) {
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
    }
    
    func userDidSelectValue(value: AnyObject?, valueAsString: String?) {
        selectedValue = value
        selectedLabel.text = valueAsString
    }
    
    override func getValueFromCell() -> AnyObject? {
        return selectedValue
    }
}
