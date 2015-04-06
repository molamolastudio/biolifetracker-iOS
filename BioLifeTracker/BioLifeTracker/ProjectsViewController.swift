//
//  ProjectsViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class ProjectsViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellReuseIdentifier = "SubtitleTableCell"
    
    let numSections = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Data.projects.count == 0 {
            Data.projects.append(Project()) // For testing
        }
        self.tableView.registerNib(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    // UITableViewDataSource and UITableViewDelegate METHODS
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as SubtitleTableCell
        
        let project = Data.projects[indexPath.row]
        
        cell.title.text = project.getDisplayName()
        cell.subtitle.text = "Created by: " + project.admins.first!.name
        
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
