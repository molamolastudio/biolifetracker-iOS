//
//  PhotoPickerCell.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 4/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class PhotoPickerCell: FormCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageDisplay: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    var selectedValue: UIImage? = nil
    
    func setSelectorForButton(target: AnyObject, action: Selector) {
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
    }
    
    func setSelectedImageView(image: UIImage) {
        imageDisplay.contentMode = UIViewContentMode.ScaleAspectFit
        selectedValue = image
        imageDisplay.image = image
    }
    
    override func getValueFromCell() -> AnyObject? {
        return selectedValue
    }
}
