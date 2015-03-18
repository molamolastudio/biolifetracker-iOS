//
//  ProjectsViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class ProjectsViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellReuseIdentifier = "ProjectTableCell"
    
    let numSections = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Data.projects.count == 0 {
            Data.projects.append(Project()) // For testing
        }
    }
    
    // UITableViewDataSource and UITableViewDelegate METHODS
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell
        
        let title = cell.viewWithTag(Constants.ViewTags.projectsCellTitle) as UILabel
        let subtitle = cell.viewWithTag(Constants.ViewTags.projectsCellSubtitle) as UILabel
        let project = Data.projects[indexPath.row]
        
        title.text = project.getDisplayName()
        //subtitle.text = project.creator.name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        Data.selectedProject = Data.projects[indexPath.row]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.projects.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numSections
    }
}
