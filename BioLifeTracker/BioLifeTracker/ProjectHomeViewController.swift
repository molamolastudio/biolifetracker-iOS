//
//  ProjectHomeViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 13/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class ProjectHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MemberPickerViewControllerDelegate, UIPopoverPresentationControllerDelegate {
    var delegate: ProjectHomeViewControllerDelegate? = nil
    
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var memberView: UITableView!
    @IBOutlet weak var sessionView: UITableView!
    @IBOutlet weak var addMembersButton: UIButton!
    
    let NOT_FOUND = -1
    
    let memberTag = 2
    let sessionTag = 3
    
    let textCellIdentifier = "SingleLineTextCell"
    let memberCellIdentifier = "MemberCell"
    
    let textCellHeight: CGFloat = 44
    let memberCellHeight: CGFloat = 50
    
    let formatter = NSDateFormatter()
    
    var currentProject: Project? = nil
    
    var graphsVC: GraphsViewController!
    
    override func loadView() {
        self.view = NSBundle.mainBundle().loadNibNamed("ProjectHomeView", owner: self, options: nil).first as! UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableViews()
        setupGraphView()
        // Sets up the date formatter for converting dates to strings
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .MediumStyle
    }
    
    func setupTableViews() {
        // Sets the data source and delegates of table views to self
        memberView.dataSource = self
        memberView.delegate = self
        
        sessionView.dataSource = self
        sessionView.delegate = self
        
        // Registers the nibs used for the table cells
        memberView.registerNib(UINib(nibName: memberCellIdentifier, bundle: nil), forCellReuseIdentifier: memberCellIdentifier)
        sessionView.registerNib(UINib(nibName: textCellIdentifier, bundle: nil), forCellReuseIdentifier: textCellIdentifier)
        
        // Sets the table views to display under the navigation bar
        self.edgesForExtendedLayout = UIRectEdge.None
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Sets the rounded corners for the table views
        memberView.layer.cornerRadius = 8;
        memberView.layer.masksToBounds = true;
        sessionView.layer.cornerRadius = 8;
        sessionView.layer.masksToBounds = true;
    }
    
    func setupGraphView() {
        // Sets the rounded corners for the graph view
        graphView.layer.cornerRadius = 8;
        graphView.layer.masksToBounds = true;
        
        graphsVC = GraphsViewController()
        graphsVC.setProject(currentProject!)
        
        graphsVC.view.frame = CGRectMake(0, 0, graphView.frame.width, graphView.frame.height)
        graphView.addSubview(graphsVC.view)
    }
    
    @IBAction func analyseBtnPressed(sender: AnyObject) {
        if delegate != nil {
            delegate!.userDidSelectGraph(currentProject!)
        }
    }
    
    @IBAction func addMembersBtnPressed() {
        showMemberPicker()
    }
    
    func showMemberPicker() {
        let memberPicker = MemberPickerViewController(nibName: "MemberPickerView", bundle: nil)
        
        memberPicker.delegate = self
        memberPicker.modalPresentationStyle = .Popover
        memberPicker.preferredContentSize = CGSizeMake(400, 400)
        
        memberPicker.members = UserManager.sharedInstance.getUsersExcept(currentProject!.members)
        
        let popoverController = memberPicker.popoverPresentationController!
        popoverController.permittedArrowDirections = .Any
        popoverController.delegate = self
        popoverController.sourceView = addMembersButton
        popoverController.sourceRect = CGRectMake(0, 0, 0, 0)
        
        presentViewController(memberPicker, animated: true, completion: nil)
    }
    
    // MemberPickerViewControllerDelegate methods
    func userDidSelectMember(member: User) {
        currentProject?.addMember(member)
        memberView.reloadData()
    }
    
    @IBAction func createSessionBtnPressed() {
        delegate?.userDidSelectCreateSession()
    }
    
    // UITableViewDataSource and UITableViewDelegate METHODS
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == memberView {
            // Displays all admins and members
            return getCellForMembers(indexPath)
        } else {
            // Displays all sessions of this project
            return getCellForSessions(indexPath)
        }
    }
    
    func getCellForMembers(indexPath: NSIndexPath) -> MemberCell {
        let cell = memberView.dequeueReusableCellWithIdentifier(memberCellIdentifier) as! MemberCell
        
        // Remove previous cell targets
        cell.button.removeTarget(self, action: Selector("removeAdmin:"), forControlEvents: .TouchUpInside)
        cell.button.removeTarget(self, action: Selector("makeAdmin:"), forControlEvents: .TouchUpInside)
        
        let member = currentProject!.members[indexPath.row]
        
        // Set fields of cell
        cell.label.text = member.name
        cell.button.hidden = false
        
        // If this member is an admin
        if contains(currentProject!.admins, member) {
            cell.button.setTitle("Remove Admin", forState: .Normal)
            cell.button.addTarget(self, action: Selector("removeAdmin:"), forControlEvents: .TouchUpInside)
            cell.adminLabel.hidden = false
        } else {
            cell.button.setTitle("Make Admin", forState: .Normal)
            cell.button.addTarget(self, action: Selector("makeAdmin:"), forControlEvents: .TouchUpInside)
            cell.adminLabel.hidden = true
        }
        
        if member == UserAuthService.sharedInstance.user {
            cell.button.hidden = true
        }
        
        cell.button.tag = indexPath.row
        
        return cell
    }
    
    func getCellForSessions(indexPath: NSIndexPath) -> SingleLineTextCell {
        let cell = sessionView.dequeueReusableCellWithIdentifier(textCellIdentifier) as! SingleLineTextCell
        
        cell.textField.userInteractionEnabled = false
        
        let session = currentProject!.sessions[indexPath.row]
        let dateString = formatter.stringFromDate(session.createdAt)
        cell.label.text = dateString
        
        if session.type == .Focal {
            cell.textField.text = "F"
        } else {
            cell.textField.text = "S"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if delegate != nil {
            if tableView == sessionView {
                delegate!.userDidSelectSession(currentProject!, session: currentProject!.sessions[indexPath.row])
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == memberView {
            return currentProject!.members.count
        } else {
            return currentProject!.sessions.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == memberView {
            return memberCellHeight
        } else {
            return textCellHeight
        }
        
    }
    
    // UIPopoverPresentationControllerDelegate method
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle{
        return .None
    }
    
    // Selectors for buttons
    func removeAdmin(sender: UIButton) {
        let members = currentProject!.members
        let member = members[sender.tag]
        currentProject?.removeAdmin(member)
        memberView.reloadData()
    }
    
    func makeAdmin(sender: UIButton) {
        let members = currentProject!.members
        let member = members[sender.tag]
        currentProject?.addAdmin(member)
        memberView.reloadData()
    }

}
