//
//  CircleWithLabelCell.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 18/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

///  Custom UICollectionViewCell for displaying a behaviour state in
///  ScanViewController and FocalSessionViewController.
class CircleWithLabelCell: UICollectionViewCell {
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var circleViewLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    
    /// Makes the circleView circular.
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let frame = circleView.frame
        let radius = circleView.frame.width/2
        let top = frame.origin.y
        let bottom = top + frame.size.height
        var corners = UIRectCorner.AllCorners
        let mask = CAShapeLayer()
        
        mask.path = UIBezierPath(
            roundedRect: CGRectMake(0, 0, frame.size.width, frame.size.height),
            byRoundingCorners: corners,
            cornerRadii: CGSizeMake(radius, radius)).CGPath
        
        circleView.layer.mask = mask
        circleView.layer.masksToBounds = true
    }

}
