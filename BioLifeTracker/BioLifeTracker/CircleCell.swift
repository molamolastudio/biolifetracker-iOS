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
    
    // Adds rounded corners if the cell is the top or bottom cell.
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let frame = self.frame
        let radius = self.frame.width/2
        let top = frame.origin.y
        let bottom = top + frame.size.height
        var corners = UIRectCorner.AllCorners
        let mask = CAShapeLayer()
        
        for view in self.superview!.subviews {
            if view.frame.origin.y + view.frame.size.height == top {
                corners = corners & ~(UIRectCorner.TopLeft | UIRectCorner.TopRight)
            } else if view.frame.origin.y == bottom {
                corners = corners & ~(UIRectCorner.BottomLeft | UIRectCorner.BottomRight)
            }
        }
        
        mask.path = UIBezierPath(
            roundedRect: CGRectMake(0, 0, frame.size.width, frame.size.height),
            byRoundingCorners: corners,
            cornerRadii: CGSizeMake(radius, radius)).CGPath
        
        self.layer.mask = mask
        self.layer.masksToBounds = true
    }
}
