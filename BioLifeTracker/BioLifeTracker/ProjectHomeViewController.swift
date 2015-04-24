//
//  ProjectHomeViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 13/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class ProjectHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MemberPickerViewControllerDelegate, UIPopoverPresentationControllerDelegate, CreateSessionViewControllerDelegate {
    var delegate: ProjectHomeViewControllerDelegate? = nil
    
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var memberView: UITableView!
    @IBOutlet weak var sessionView: UITableView!
    @IBOutlet weak var addMembersButton: UIButton!
    @IBOutlet weak var createSessionButton: UIButton!
    
    let NOT_FOUND = -1
    
    let memberTag = 2
    let sessionTag = 3
    
    let memberCellIdentifier = "MemberCell"
    let sessionCellIdentifier = "SessionCell"
    
    let textCellHeight: CGFloat = 44
    let memberCellHeight: CGFloat = 50
    
    var currentProjectIndex: Int? = nil
    var currentProject: Project? = nil
    
    var graphsVC: GraphsViewController!
    
    override func loadView() {
        self.view = NSBundle.mainBundle().loadNibNamed("ProjectHomeView", owner: self, options: nil).first as! UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableViews()
        setupGraphView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // We have to use dispatch async. Super heavy operation.
        dispatch_async(ProjectManager.storageThread, {
            ProjectManager.sharedInstance.updateProject(self.currentProjectIndex!,
                project: self.currentProject!)
            println("Finish updating project at index \(self.currentProjectIndex!)")
        })
    }
    
    func setupTableViews() {
        // Sets the data source and delegates of table views to self
        memberView.dataSource = self
        memberView.delegate = self
        
        sessionView.dataSource = self
        sessionView.delegate = self
        
        // Registers the nibs used for the table cells
        memberView.registerNib(UINib(nibName: memberCellIdentifier, bundle: nil), forCellReuseIdentifier: memberCellIdentifier)
        sessionView.registerNib(UINib(nibName: sessionCellIdentifier, bundle: nil), forCellReuseIdentifier: sessionCellIdentifier)
        
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
        graphsVC.setThreshold(4)
        
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
        currentProject!.addMember(member)
        memberView.reloadData()
    }
    
    @IBAction func createSessionBtnPressed() {
        showCreateSession()
    }
    
    func showCreateSession() {
        let sessionForm = CreateSessionViewController()
        
        sessionForm.delegate = self
        sessionForm.modalPresentationStyle = .Popover
        sessionForm.preferredContentSize = CGSizeMake(400, 200)
        
        sessionForm.currentProject = currentProject
        
        let popoverController = sessionForm.popoverPresentationController!
        popoverController.permittedArrowDirections = .Any
        popoverController.delegate = self
        popoverController.sourceView = createSessionButton
        popoverController.sourceRect = CGRectMake(0, 0, 0, 0)
        
        presentViewController(sessionForm, animated: true, completion: nil)
    }
    
    // CreateSessionViewControllerDelegate methods
    func userDidFinishCreatingSession(session: Session) {
        println("before \(currentProject!.sessions.count)")
        currentProject!.addSession(session)
        println("after \(currentProject!.sessions.count)")
        sessionView.reloadData()
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
        
        // Show the admin label
        cell.adminLabel.hidden = !(currentProject!.containsAdmin(member))
        
        // Allow admin privileges if current user is an admin
        let user = UserAuthService.sharedInstance.user
        if currentProject!.containsAdmin(user) {
            cell.button.hidden = false
            addMembersButton.hidden = false
            if currentProject!.containsAdmin(member) {
                cell.button.setTitle("Remove Admin", forState: .Normal)
                cell.button.addTarget(self, action: Selector("removeAdmin:"), forControlEvents: .TouchUpInside)
            } else {
                cell.button.setTitle("Make Admin", forState: .Normal)
                cell.button.addTarget(self, action: Selector("makeAdmin:"), forControlEvents: .TouchUpInside)
            }
        } else {
            cell.button.hidden = true
            addMembersButton.hidden = false
        }
        
        // If this member was the creator, do not allow removal of admin privileges
        if member == currentProject!.createdBy {
            cell.button.hidden = true
        }
        
        // Display an option to leave the project if this member is the current user
        if member == user {
            cell.button.hidden = false
            cell.button.setTitle("Leave Project", forState: .Normal)
            cell.button.addTarget(self, action: Selector("leaveProject:"), forControlEvents: .TouchUpInside)
        }

        cell.button.tag = indexPath.row
        
        return cell
    }
    
    func getCellForSessions(indexPath: NSIndexPath) -> SessionCell {
        let cell = sessionView.dequeueReusableCellWithIdentifier(sessionCellIdentifier) as! SessionCell
        
        cell.button.removeTarget(self, action: Selector("deleteSession:"), forControlEvents: .TouchUpInside)
        
        let session = currentProject!.sessions[indexPath.row]
        cell.label.text = session.name
        
        if session.type == .Focal {
            cell.typeLabel.text = "F"
        } else {
            cell.typeLabel.text = "S"
        }
        
        cell.button.hidden = false
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action: Selector("deleteSession:"), forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if delegate != nil {
            if tableView == sessionView {
                delegate!.userDidSelectSession(currentProject!, session: indexPath.row)
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
    
    func leaveProject(sender: UIButton) {
        // Make current user leave current project
        // ANDHIEKA
    }
    
    func deleteSession(sender: UIButton) {
        let session = currentProject!.sessions[sender.tag]
        currentProject!.removeSession(session)
        sessionView.reloadData()
    }
    
}
