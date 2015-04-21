//
//  CustomPickerPopup.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 11/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class CustomPickerPopup: FormPopupController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    
    let tableBorderWidth: CGFloat = 0.5
    let tableBorderColor = UIColor.lightGrayColor().CGColor
    
    let cellReuseIdentifier = "CustomPickerPopupCell"
    
    let numSections = 1
    
    var selectedIndex: Int? = nil
    
    var data: [String] = []
    
    override func loadView() {
        self.view = NSBundle.mainBundle().loadNibNamed("CustomPickerPopupView", owner: self, options: nil).first as! UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        doneBtn.hidden = true
    }
    
    func setupTableView() {
        table.dataSource = self
        table.delegate = self
        
        table.registerNib(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        
        table.layer.borderWidth = tableBorderWidth
        table.layer.borderColor = tableBorderColor

        self.view.addSubview(table)
    }
    
    func setSelectedIndex(index: Int) {
        selectedIndex = index
        table.reloadData()
    }
    
    @IBAction func doneBtnPressed(sender: UIButton) {
        if delegate != nil {
            var message: String? = nil
            if selectedIndex != nil {
                message = data[selectedIndex!]
            }
            delegate!.userDidSelectValue(selectedIndex, valueAsString: message)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // Changes the accessory type of selected row to a checkmark.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! CustomPickerPopupCell
        
        cell.label.text = data[indexPath.row]
        
        if selectedIndex != nil {
            if indexPath.row == selectedIndex {
                cell.backgroundColor = UIColor.groupTableViewBackgroundColor()
            } else {
                cell.backgroundColor = UIColor.whiteColor()
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath.row
        doneBtn.hidden = false
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numSections
    }    
}
