//
//  EthogramPicker.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 11/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class EthogramPicker: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var delegate: EthogramPickerDelegate? = nil
    
    let table = UITableView()
    let overlay = UIView()
    let shadow = UIView()
    
    let alphaQuarter: Float = 0.25
    let cornerRadius: CGFloat = 5
    
    let tableFrame = CGRectMake(10, 150, 355, 200)
    let shadowFrame = CGRectMake(0, 0, 355, 200)
    
    let tableBorderWidth: CGFloat = 0.5
    let tableBorderColor = UIColor.lightGrayColor().CGColor
    
    let fileName = "EthogramPickerCell"
    let cellReuseIdentifier = "PickerCell"
    
    let numSections = 1
    
    var selectedIndex: Int? = nil
    
    var data: [String] = []
    
    override func viewDidLoad() {
        table.registerNib(UINib(nibName: fileName, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        setupOverlay()
        setupShadow()
        setupTableView()
    }
    
    func setupOverlay() {
        overlay.frame = self.view.frame
        overlay.backgroundColor = UIColor.clearColor()
        self.view.addSubview(overlay)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("tapDetected:"))
        overlay.addGestureRecognizer(tapGesture)
    }
    
    func setupShadow() {
        shadow.frame = tableFrame
        shadow.backgroundColor = UIColor.clearColor()
        shadow.layer.masksToBounds = false
        shadow.layer.shadowColor = UIColor.blackColor().CGColor
        shadow.layer.shadowPath = UIBezierPath(roundedRect: shadowFrame, cornerRadius: cornerRadius).CGPath
        shadow.layer.shadowOffset = CGSizeZero
        shadow.layer.shadowOpacity = alphaQuarter
        shadow.layer.shadowRadius = cornerRadius
        self.view.addSubview(shadow)
    }
    
    func setupTableView() {
        table.frame = tableFrame
        table.dataSource = self
        table.delegate = self
        
        table.layer.cornerRadius = cornerRadius
        table.layer.borderWidth = tableBorderWidth
        table.layer.borderColor = tableBorderColor
            
        self.view.addSubview(table)
    }
    
    func tapDetected(sender: UITapGestureRecognizer) {
        let point = sender.locationInView(sender.view)
        if !CGRectContainsPoint(table.frame, point) {
            delegate!.pickerDidDismiss(selectedIndex)
        }
    }
    
    // Changes the accessory type of selected row to a checkmark.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell
        
        let label = cell.viewWithTag(Constants.ViewTags.pickerCellLabel) as UILabel
        label.text = data[indexPath.row]
        
        if selectedIndex != nil {
            if indexPath.row == selectedIndex {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numSections
    }

}
