//
//  SingleLineTextCell.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 30/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class SingleLineTextCell: UITableViewCell, FormCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getValueFromCell() -> AnyObject? {
        return textField.text
    }
}
