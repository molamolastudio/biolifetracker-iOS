//
//  ProjectHomeViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 13/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//
//  Displays a graph showing a summary of the collected data in this project,
//  a list of members with options and a list of sessions.
//
//  Allows users to add users or create sessions.
//
//  Informs its delegate if the user has selected a graph for further analysis,
//  or a session.

import UIKit

class ProjectHomeViewController: UIViewController, UITableViewDataSource,
                                 UITableViewDelegate, MemberPickerViewControllerDelegate,
                                 UIPopoverPresentationControllerDelegate,
                                 CreateSessionViewControllerDelegate {
    
    var delegate: ProjectHomeViewControllerDelegate? = nil
    
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var memberView: UITableView!
    @IBOutlet weak var sessionView: UITableView!
    @IBOutlet weak var addMembersButton: UIButton!
    @IBOutlet weak var createSessionButton: UIButton!
    
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
    
    /// Updates the current project before the view disappears.
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if currentProject != nil {
            dispatch_async(ProjectManager.storageThread, {
                ProjectManager.sharedInstance.updateProject(self.currentProjectIndex!,
                    project: self.currentProject!)
            })
        }
    }
    
    // MARK: SETUP VIEW METHODS
    
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
    
    // MARK: IBACTIONS FOR BUTTONS
    
    @IBAction func analyseBtnPressed(sender: AnyObject) {
        if delegate != nil {
            delegate!.userDidSelectGraph(currentProject!)
        }
    }
    
    @IBAction func addMembersBtnPressed() {
        showMemberPicker()
    }
    
    @IBAction func createSessionBtnPressed() {
        showCreateSession()
    }
    
    // MARK: SELECTORS FOR BUTTON
    
    func showMemberPicker() {
        let memberPicker = MemberPickerViewController()
        
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
    
    // MARK: MemberPickerViewControllerDelegate METHODS
    
    func userDidSelectMember(member: User) {
        currentProject!.addMember(member)
        memberView.reloadData()
    }

    // MARK: CreateSessionViewControllerDelegate METHODS
    
    func userDidFinishCreatingSession(session: Session) {
        currentProject!.addSession(session)
        sessionView.reloadData()
    }
    
    // MARK: UITableViewDataSource and UITableViewDelegate METHODS
    
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
        cell.button.removeTarget(self, action: Selector("exitProject:"), forControlEvents: .TouchUpInside)
        
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
        
        // Display an option to exit the project if this member is the current user
        if member == user {
            cell.button.removeTarget(self, action: Selector("removeAdmin:"), forControlEvents: .TouchUpInside)
            cell.button.removeTarget(self, action: Selector("makeAdmin:"), forControlEvents: .TouchUpInside)
            cell.button.hidden = false
            cell.button.setTitle("Exit Project", forState: .Normal)
            cell.button.addTarget(self, action: Selector("exitProject:"), forControlEvents: .TouchUpInside)
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
    
    // MARK: UIPopoverPresentationControllerDelegate METHODS
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle{
        return .None
    }
    
    // MARK: TARGETS FOR BUTTONS IN CELLS
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
    
    /// Make the current user exit the project.
    /// Other members will still be able to see the project.
    func exitProject(sender: UIButton) {
        if currentProject == nil { return }
        let project = currentProject!
        let currentUser = UserAuthService.sharedInstance.user
        let isAdmin = project.containsAdmin(currentUser)
        project.removeMember(currentUser)
        
        let projectManager = ProjectManager.sharedInstance

        
        if project.id == nil { // If project has not been uploaded before
            ProjectManager.sharedInstance.removeProjects([currentProjectIndex!])
            invalidateProject()
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        let alertController = UIAlertController(title: "Exiting Project",
            message: "Contacting server to remove membership", preferredStyle: .Alert)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        let worker = CloudStorageWorker()
        let uploadTask = UploadTask(item: project)
        
        worker.enqueueTask(uploadTask)
        worker.setOnFinished {
            if uploadTask.completedSuccessfully == true {
                ProjectManager.sharedInstance.removeProjects([self.currentProjectIndex!])
                self.invalidateProject()
                self.deleteProjectIfHasNoMember(project)
                dispatch_async(dispatch_get_main_queue(), {
                    alertController.dismissViewControllerAnimated(false, completion: nil)
                    self.dismissSelf()
                })
            } else {
                project.addMember(currentUser)
                if isAdmin { project.addAdmin(currentUser) }
                dispatch_async(dispatch_get_main_queue(), {
                    let failAlert = UIAlertController(title: "Fail to Exit Project", message: "The server cannot be contacted at the moment", preferredStyle: .Alert)
                    let actionOk = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    failAlert.addAction(actionOk)
                    alertController.dismissViewControllerAnimated(true, completion: {
                        self.presentViewController(failAlert, animated: true, completion: nil)
                    })
                })
            }
        }
        worker.startExecution()
        
    }
    
    private func invalidateProject() {
        currentProject = nil
        currentProjectIndex = nil
    }
    
    func deleteSession(sender: UIButton) {
        let session = currentProject!.sessions[sender.tag]
        currentProject!.removeSession(session)
        sessionView.reloadData()
    }
    
    func deleteProjectIfHasNoMember(project: Project) {
        if project.members.count == 0 {
            let deleteTask = DeleteTask(item: project)
            let worker = CloudStorageWorker()
            worker.enqueueTask(deleteTask)
            worker.startExecution()
        }
    }
    
    func dismissSelf() {
        if delegate != nil {
            delegate!.userDidLeaveProject()
        }
    }
    
}
