//
//  CircleCell.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 18/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class CircleCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    
    // Makes the cell circular.
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let frame = self.frame
        let radius = self.frame.width/2
        let top = frame.origin.y
        let bottom = top + frame.size.height
        var corners = UIRectCorner.AllCorners
        let mask = CAShapeLayer()
        
        mask.path = UIBezierPath(
            roundedRect: CGRectMake(0, 0, frame.size.width, frame.size.height),
            byRoundingCorners: corners,
            cornerRadii: CGSizeMake(radius, radius)).CGPath
        
        self.layer.mask = mask
        self.layer.masksToBounds = true
    }
}
