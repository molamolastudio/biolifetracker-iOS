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
    
    let alphaHalf: CGFloat = 0.5
    
    let tableFrame = CGRectMake(10, 150, 355, 200)
    let shadowFrame = CGRectMake(8, 152, 355, 200)
    
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
        shadow.frame = shadowFrame
        shadow.backgroundColor = UIColor.blackColor()
        shadow.alpha = alphaHalf
        self.view.addSubview(shadow)
    }
    
    func setupTableView() {
        table.frame = tableFrame
        table.dataSource = self
        table.delegate = self
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
