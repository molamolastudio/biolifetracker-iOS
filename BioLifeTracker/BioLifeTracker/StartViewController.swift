//
//  StartViewController.swift
//  Mockups
//
//  Created by Michelle Tan on 2/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    @IBOutlet weak var displaySessionTitle: UITextField!
    
    @IBOutlet weak var displayProject: UITextField!
    @IBOutlet weak var displaySession: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnAllProjects: UIButton!
    @IBOutlet weak var btnCreateProject: UIButton!
    
    @IBOutlet weak var btnSession: UIButton!
    
    let labelCreateSession = "Create A Session"
    let labelStartTracking = "Start Tracking"
    
    let messageNoProjects = "You don't have any projects."
    let messageNoSessions = "You don't have any sessions."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshView()
    }
    
    override func viewDidAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // Changes the visibility of UI elements based on state variables.
    func refreshView() {
        if Data.isLoggedIn {
            btnLogin.hidden = true
        } else {
            btnLogin.hidden = false
        }
        
        // There is a project currently selected
        if let project = Data.selectedProject {
            displayProject.text = project.getDisplayName()
            showSessionSection()
            
            if let session = Data.selectedSession {
                displaySession.text = session.getDisplayName()
                btnSession.titleLabel!.text = labelStartTracking
            } else {
                displaySession.text = messageNoSessions
                btnSession.titleLabel!.text = labelCreateSession
            }
        } else {
            // Else, show the appropriate text.
            displayProject.text = messageNoProjects
            hideSessionSection()
        }
    }
    
    func showSessionSection() {
        displaySessionTitle.hidden = false
        displaySession.hidden = false
        btnSession.hidden = false
    }
    
    func hideSessionSection() {
        displaySessionTitle.hidden = true
        displaySession.hidden = true
        btnSession.hidden = true
    }
}

