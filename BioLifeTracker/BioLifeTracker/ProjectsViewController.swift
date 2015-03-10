//
//  ProjectsViewController.swift
//  Mockups
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class ProjectsViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellReuseIdentifier = "ProjectTableCell"
    
    let tagCellTitle = 100
    let tagCellSubtitle = 101
    
    let numRowsInSection: [Int] = [3] //[Data.projects.count]
    let numSections = 1
    
    let projectTitles = ["Project 1", "Project 2", "Project 3"]
    let projectCreator = "Default"
    
    override func viewDidLoad() {
        
    }
    
    // UITableViewDataSource and UITableViewDelegate METHODS
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell
        
        let title = cell.viewWithTag(tagCellTitle) as UILabel
        let subtitle = cell.viewWithTag(tagCellSubtitle) as UILabel
        //let project = Data.projects[indexPath.row]
        
        // Default values manually inserted for testing
        title.text = projectTitles[indexPath.row] //project.getDisplayName()
        subtitle.text = projectCreator //project.creator.name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numRowsInSection[section]
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numSections
    }
}
