//
//  ProjectFormViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class ProjectFormViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    let table = UITableViewController()
    
    let cellReuseIdentifier = "ProjectFormTableCell"
    
    var isTableEditable = false
    
    
    var cellTypes: [Constants.CellType] = []
    
    override func viewDidLoad() {
        
    }
}
