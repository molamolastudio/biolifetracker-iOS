//
//  StartViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 2/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, FBLoginViewDelegate, GPPSignInDelegate {
    @IBOutlet weak var displaySessionTitle: UITextField!
    
    @IBOutlet weak var displayProject: UITextField!
    @IBOutlet weak var displaySession: UITextField!

    @IBOutlet weak var btnLogin: FBLoginView!
    @IBOutlet weak var btnAllProjects: UIButton!
    @IBOutlet weak var btnCreateProject: UIButton!
    
    @IBOutlet weak var btnSession: UIButton!
    
    @IBAction func btnLoginGoogle(sender: UIButton) {
        // Configure Google login
        signIn = GPPSignIn.sharedInstance()
        signIn?.shouldFetchGooglePlusUser = true
        signIn?.clientID = "47253329705-c8p8oqi7j036p5lakqia2jl3v3j1np2g.apps.googleusercontent.com"
        signIn?.scopes = [kGTLAuthScopePlusLogin]
        signIn?.delegate = self
        signIn?.authenticate()
        
    }
    var signIn: GPPSignIn?
    
    let labelCreateSession = "Create A Session"
    let labelStartTracking = "Start Tracking"
    
    let messageNoProjects = "You don't have any projects."
    let messageNoSessions = "You don't have any sessions."
    
    
    let superVC = SuperController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnLogin.delegate = self
        self.btnLogin.readPermissions = ["public_profile", "email", "user_friends"]
        
        refreshView()

        self.view.addSubview(superVC.view)
        superVC.view.frame = self.view.frame
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
    
    // Facebook Delegate Methods
    
//    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
//        println("User Logged In")
//    }
    
//    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
//        println("User: \(user)")
//        println("User ID: \(user.objectID)")
//        println("User Name: \(user.name)")
//        var userEmail = user.objectForKey("email") as String
//        println("User Email: \(userEmail)")
//    }
    
//    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
//        println("User Logged Out")
//    }
//    
//    func loginView(loginView : FBLoginView!, handleError:NSError) {
//        println("Error: \(handleError.localizedDescription)")
//    }
    
    // Google Plus Sign in
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        println(auth)
    }
    
    func didDisconnectWithError(error: NSError!) {
        println(error)
    }
    
}

