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
    
    @IBOutlet weak var leftTableView: UITableView!
    @IBOutlet weak var rightTableView: UITableView!
    @IBOutlet weak var bottomTableView: UITableView!
    
    let leftTag = 1
    let rightTag = 2
    let bottomTag = 3
    
    let cellReuseIdentifier = "SingleLineTextCell"
    let cellHeight: CGFloat = 44
    
    let formatter = NSDateFormatter()
    
    var currentProject: Project? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftTableView.dataSource = self
        leftTableView.delegate = self
        
        rightTableView.dataSource = self
        rightTableView.delegate = self
        
        bottomTableView.dataSource = self
        bottomTableView.delegate = self
        
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .MediumStyle
        
        leftTableView.registerNib(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        rightTableView.registerNib(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        bottomTableView.registerNib(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    // UITableViewDataSource and UITableViewDelegate METHODS
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! SingleLineTextCell
        
        cell.textField.userInteractionEnabled = false
        
        if tableView.tag == leftTag {
            // Displays all admins and members
            if indexPath.row < currentProject!.admins.count {
                cell.label.text = currentProject!.admins[indexPath.row].name
            } else {
                cell.label.text = currentProject!.members[indexPath.row - currentProject!.admins.count].name
            }
        } else if tableView.tag == rightTag {
            // Displays all behaviour states of this project's ethogram
            cell.label.text = currentProject!.ethogram.behaviourStates[indexPath.row].name
        } else if tableView.tag == bottomTag {
            // Displays all sessions of this project
            let dateString = formatter.stringFromDate(currentProject!.sessions[indexPath.row].createdAt)
            cell.label.text = dateString
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if delegate != nil {
            if tableView.tag == leftTag {
                if indexPath.row < currentProject!.admins.count {
                    delegate!.userDidSelectMember(currentProject!, member: currentProject!.admins[indexPath.row])
                } else {
                    delegate!.userDidSelectMember(currentProject!, member: currentProject!.members[indexPath.row - currentProject!.admins.count])
                }
                
            } else if tableView.tag == rightTag {
                delegate!.userDidChangeEthogram(currentProject!, ethogram: currentProject!.ethogram)
            } else if tableView.tag == bottomTag {
                delegate!.userDidSelectSession(0, project: currentProject!, session: currentProject!.sessions[indexPath.row])
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == leftTag {
            return currentProject!.admins.count + currentProject!.members.count
        } else if tableView.tag == rightTag {
            return currentProject!.ethogram.behaviourStates.count
        } else if tableView.tag == bottomTag {
            return currentProject!.sessions.count
        } else {
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.tag == leftTag {
            return "Members"
        } else if tableView.tag == rightTag {
            return "Selected Ethogram: " + currentProject!.ethogram.name
        } else if tableView.tag == bottomTag {
            return "Sessions"
        } else {
            return ""
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
}
