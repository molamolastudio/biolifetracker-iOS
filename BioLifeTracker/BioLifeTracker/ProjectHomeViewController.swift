//
//  ProjectHomeViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 11/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class ProjectHomeViewController: UIViewController {
    // Load all data from Data.selectedProject
    @IBOutlet weak var labelProjectName: UILabel!
    let project = Data.selectedProject!
    
    override func viewDidLoad() {
        labelProjectName.text = project.getDisplayName()
    }
}
