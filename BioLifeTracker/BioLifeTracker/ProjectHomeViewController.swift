//
//  ProjectHomeViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 13/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class ProjectHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var delegate: ProjectHomeViewControllerDelegate? = nil
    
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var memberView: UITableView!
    @IBOutlet weak var sessionView: UITableView!
    
    let memberTag = 2
    let sessionTag = 3
    
    let cellReuseIdentifier = "SingleLineTextCell"
    let cellHeight: CGFloat = 44
    
    let formatter = NSDateFormatter()
    
    var currentProject: Project? = nil
    
    var graphsVC: GraphsViewController!
    
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
        memberView.registerNib(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        sessionView.registerNib(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        
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
        graphsVC = GraphsViewController(nibName: "GraphsView", bundle: nil)
        //self.addChildViewController(graphsVC)
        graphsVC.setProject(currentProject!)
        graphsVC.view.frame = self.graphView.frame
        graphView.addSubview(graphsVC.view)
    }
    
    @IBAction func editMembersBtnPressed() {
        if delegate != nil {
            delegate!.userDidSelectEditMembers()
        }
    }
    
    @IBAction func createSessionBtnPressed() {
        if delegate != nil {
            delegate!.userDidSelectCreateSession()
        }
    }
    
    // UITableViewDataSource and UITableViewDelegate METHODS
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! SingleLineTextCell
        
        cell.textField.userInteractionEnabled = false
        
        if tableView.tag == memberTag {
            // Displays all admins and members
            if indexPath.row < currentProject!.admins.count {
                cell.label.text = currentProject!.admins[indexPath.row].name
            } else {
                cell.label.text = currentProject!.members[indexPath.row - currentProject!.admins.count].name
            }
        } else if tableView.tag == sessionTag {
            // Displays all sessions of this project
            let dateString = formatter.stringFromDate(currentProject!.sessions[indexPath.row].createdAt)
            cell.label.text = dateString
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if delegate != nil {
            if tableView.tag == memberTag {
                if indexPath.row < currentProject!.admins.count {
                    delegate!.userDidSelectMember(currentProject!, member: currentProject!.admins[indexPath.row])
                } else {
                    delegate!.userDidSelectMember(currentProject!, member: currentProject!.members[indexPath.row - currentProject!.admins.count])
                }
                
            } else if tableView.tag == sessionTag {
                delegate!.userDidSelectSession(currentProject!, session: currentProject!.sessions[indexPath.row])
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == memberTag {
            return currentProject!.admins.count + currentProject!.members.count
        } else if tableView.tag == sessionTag {
            return currentProject!.sessions.count
        } else {
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
}
