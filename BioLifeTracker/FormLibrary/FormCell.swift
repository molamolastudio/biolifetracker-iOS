//
//  FormCell.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 30/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class FormCell: UITableViewCell {
    let radius: CGFloat = 10
    
    var sizeSet: Bool = false // Make sure padding is only applied once.
    var rounded: Bool = false
    
    var horizontalPadding: CGFloat = 0
    var verticalPadding: CGFloat = 0
    
    var updatedFrame = CGRect()
    
    func getValueFromCell() -> AnyObject? {
        return nil
    }
    
    // Applies padding if it has not been applied yet.
    // Adds rounded corners if the cell is the top or bottom cell.
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Apply padding
        if !sizeSet {
            updatedFrame = CGRectMake(
                self.frame.origin.x + horizontalPadding,
                self.frame.origin.y + verticalPadding,
                self.frame.width - 2 * horizontalPadding,
                self.frame.height - 2 * verticalPadding)
            sizeSet = true
        }
        
        self.frame = updatedFrame
        
        if rounded {
            let frame = self.frame
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
    
    // Removes top and bottom seperators if the cell is the top or bottom cell.
    override func addSubview(view: UIView) {
        if rounded {
            if view.frame.origin.x > 0 || view.frame.size.width < self.frame.size.width {
                super.addSubview(view)
            }
        } else {
            super.addSubview(view)
        }
    }
}
