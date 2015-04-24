//
//  ProjectsViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//
//  Displays a list of projects retrieved from ProjectManager.
//  Informs its delegate if a project is selected.

import UIKit

class ProjectsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var delegate: ProjectsViewControllerDelegate? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellReuseIdentifier = "SubtitleTableCell"
    let cellHeight: CGFloat = 50
    
    let numSections = 1
    
    override func loadView() {
        self.view = NSBundle.mainBundle().loadNibNamed("PaddedTableView", owner: self, options: nil).first as! UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var test: Int? = nil
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.registerNib(UINib(nibName: cellReuseIdentifier, bundle: nil),
                                         forCellReuseIdentifier: cellReuseIdentifier)
        
        // Sets the subviews to display under the navigation bar
        self.edgesForExtendedLayout = UIRectEdge.None
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Sets rounded corners
        self.tableView.layer.cornerRadius = 8
        self.tableView.layer.masksToBounds = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.editing = false
    }
    
    // MARK: UITableViewDataSource AND UITableViewDelegate METHODS
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! SubtitleTableCell
        
        let project = ProjectManager.sharedInstance.projects[indexPath.row]
        
        cell.title.text = project.getDisplayName()
        cell.subtitle.text = "Created by: " + project.createdBy.name
        
        return cell
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if delegate != nil {
            delegate!.userDidSelectProject(indexPath.row)
        }
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProjectManager.sharedInstance.projects.count
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numSections
    }
    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
    
     func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
     func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    /// Deletes the related project if the cell is deleted.
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            // Deleting a project means exiting the project
            // Other members can still see the project
            let projectManager = ProjectManager.sharedInstance
            let project = projectManager.projects[indexPath.row]
            
            if project.id == nil { // If project has not been uploaded before
                ProjectManager.sharedInstance.removeProjects([indexPath.row])
                tableView.reloadData()
                return
            }
            
            let alertController = UIAlertController(title: "Exiting Project",
                message: "Contacting server to remove membership", preferredStyle: .Alert)
            
            presentViewController(alertController, animated: true, completion: nil)
            
            let currentUser = UserAuthService.sharedInstance.user
            let isAdmin = project.containsAdmin(currentUser)
            project.removeMember(currentUser)
            let worker = CloudStorageWorker()
            let uploadTask = UploadTask(item: project)
            
            worker.enqueueTask(uploadTask)
            worker.setOnFinished {
                if uploadTask.completedSuccessfully == true {
                    ProjectManager.sharedInstance.removeProjects([indexPath.row])
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                        alertController.dismissViewControllerAnimated(false, completion: nil)
                        self.deleteProjectIfHasNoMember(project)
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
                        self.tableView.reloadData()
                    })
                }
            }
            worker.startExecution()
        }
    }
    
    func deleteProjectIfHasNoMember(project: Project) {
        if project.members.count == 0 {
            let deleteTask = DeleteTask(item: project)
            let worker = CloudStorageWorker()
            worker.enqueueTask(deleteTask)
            worker.startExecution()
        }
    }
}
