//
//  MemberPickerViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 20/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

///  Requires: A list of members.
///  Presents a picker for a list of members to the user.
///  Informs its delegate of the selected member when the done button is pressed.
class MemberPickerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var delegate: MemberPickerViewControllerDelegate? = nil
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button: UIButton!
    
    let cellReuseIdentifier = "SingleLineTextCell"
    let numSections = 1
    let cellHeight: CGFloat = 44
    
    var members: [User] = []
    
    var selectedMember: Int? = nil
    
    override func loadView() {
        self.view = NSBundle.mainBundle().loadNibNamed("MemberPickerView", owner: self, options: nil).first as! UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNib(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        
        button.hidden = true
    }
    
    @IBAction func btnDonePressed(sender: UIButton) {
        if delegate != nil && selectedMember != nil {
            delegate!.userDidSelectMember(members[selectedMember!])
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    // MARK: UITableViewDataSource AND UITableViewDelegate METHODS
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! SingleLineTextCell
        
        cell.textField.hidden = true
        cell.label.text = members[indexPath.row].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numSections
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
    
    /// Updates the selected member after a row is selected.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        button.hidden = false
        selectedMember = indexPath.row
    }
    
}
