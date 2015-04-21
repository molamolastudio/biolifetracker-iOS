//
//  ProjectFormViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 20/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class ProjectFormViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MemberPickerViewControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var formPlaceholder: UIView!
    @IBOutlet weak var membersView: UITableView!
    @IBOutlet weak var addMembersButton: UIButton!
    
    let cellReuseIdentifier = "MemberCell"
    let cellHeight: CGFloat = 50
    
    let numSections = 1
    
    let form = FormViewController()
    
    var project: Project? = nil
    var admins: [User] = []
    var members: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFormVC()
        
        membersView.dataSource = self
        membersView.delegate = self
        membersView.registerNib(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        membersView.tableFooterView = UIView()
        
        // Sets the subviews to display under the navigation bar
        self.edgesForExtendedLayout = UIRectEdge.None
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func getProject() -> Project? {
        let values = form.getFormData()
        
        let name = values[0] as! String
        if name != "" {
            if let index = values[1] as? Int {
                let project = Project(name: name, ethogram: EthogramManager.sharedInstance.ethograms[index])
                
                project.addAdmins(admins)
                project.addMembers(admins + members)
                
                return project
            }
        }
        return nil
    }
    
    func setupFormVC() {
        form.setFormData(getFormDataForNewProject())
        form.roundedCells = true
        
        form.view.frame = CGRectMake(0, 0, formPlaceholder.frame.width, formPlaceholder.frame.height)
        formPlaceholder.addSubview(form.view)
        
        form.tableView.scrollEnabled = false
    }
    
    func getFormDataForNewProject() -> FormFieldData {
        var ethogramNames = [String]()
        for e in EthogramManager.sharedInstance.ethograms {
            ethogramNames.append(e.name)
        }
        
        let data = FormFieldData(sections: 1)
        data.addTextCell(section: 0, label: "Name", hasSingleLine: true)
        data.addPickerCell(section: 0, label: "Ethogram", pickerValues: ethogramNames, isCustomPicker: true)
        return data
    }
    
    @IBAction func addMembersBtnPressed(sender: UIButton) {
        showMemberPicker()
    }
    
    func showMemberPicker() {
        let memberPicker = MemberPickerViewController(nibName: "MemberPickerView", bundle: nil)
        
        memberPicker.delegate = self
        memberPicker.modalPresentationStyle = .Popover
        memberPicker.preferredContentSize = CGSizeMake(400, 400)
        
        memberPicker.members = UserManager.sharedInstance.getUsersExcept(members)
        
        let popoverController = memberPicker.popoverPresentationController!
        popoverController.permittedArrowDirections = .Any
        popoverController.delegate = self
        popoverController.sourceView = addMembersButton
        popoverController.sourceRect = CGRectMake(0, 0, 0, 0)
        
        presentViewController(memberPicker, animated: true, completion: nil)
    }
    
    // MemberPickerViewControllerDelegate methods
    func userDidSelectMember(member: User) {
        members.append(member)
        membersView.reloadData()
    }
    
    // UITableViewDataSource and UITableViewDelegate METHODS
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! MemberCell
        
        cell.button.removeTarget(self, action: Selector("removeAdmin:"), forControlEvents: .TouchUpInside)
        cell.button.removeTarget(self, action: Selector("makeAdmin:"), forControlEvents: .TouchUpInside)
        
        cell.button.hidden = false
        
        if indexPath.row == 0 { // Is first row, to show self
            let member = UserAuthService.sharedInstance.user
            cell.label.text = member.name
            cell.adminLabel.hidden = false
            cell.button.hidden = true
            
        } else if indexPath.row <= admins.count {
            // Displaying admins
            let index = indexPath.row - 1
            let member = admins[index]
            cell.label.text = member.name
            cell.button.setTitle("Remove Admin", forState: .Normal)
            cell.button.addTarget(self, action: Selector("removeAdmin:"), forControlEvents: .TouchUpInside)
            cell.adminLabel.hidden = false
            
        } else {
            // Displaying members
            let index = indexPath.row - admins.count - 1
            let member = members[index]
            cell.label.text = member.name
            cell.button.setTitle("Make Admin", forState: .Normal)
            cell.button.addTarget(self, action: Selector("makeAdmin:"), forControlEvents: .TouchUpInside)
            cell.adminLabel.hidden = true
        }
        
        cell.rounded = true
        cell.button.tag = indexPath.row
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return admins.count + members.count + 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numSections
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
    
    // For deleting members
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        // Do not allow deletion of self
        if indexPath.row == 0 {
            return UITableViewCellEditingStyle.None
        } else {
            return UITableViewCellEditingStyle.Delete
        }
    }
    
    // If the cell is deleted, delete the project.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            // Delete member
            deleteMemberAtIndex(indexPath.row - 1)
            membersView.reloadData()
        }
    }
    
    // UIPopoverPresentationControllerDelegate method
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle{
        return .None
    }
    
    // Selectors for buttons
    func removeAdmin(sender: UIButton) {
        let index = sender.tag - 1
        
        let member = admins[index]
        admins.removeAtIndex(index)
        members.append(member)
        
        membersView.reloadData()
    }
    
    func makeAdmin(sender: UIButton) {
        let index = sender.tag - admins.count - 1
        
        let member = members[index]
        members.removeAtIndex(index)
        admins.append(member)
        
        membersView.reloadData()
    }
    
    // Helper methods
    func deleteMemberAtIndex(index: Int) {
        if index < admins.count {
            // Delete admin
            admins.removeAtIndex(index)
        } else {
            // Delete member
            let memIndex = index - admins.count
            members.removeAtIndex(memIndex)
        }
    }
}
