//
//  FirstViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 2/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, FBLoginViewDelegate, GPPSignInDelegate {
    var delegate: FirstViewControllerDelegate? = nil
    
    @IBOutlet weak var displayProject: UILabel!
    @IBOutlet weak var displaySession: UILabel!
    @IBOutlet weak var displaySessionTitle: UILabel!
    @IBOutlet weak var btnCreateProject: UIButton!
    @IBOutlet weak var btnCreateSession: UIButton!

    @IBOutlet weak var btnLogin: FBLoginView!
    @IBOutlet weak var btnLoginGoogle: GPPSignInButton!
    
    
    @IBAction func projectBtnPressed(sender: UIButton) {
        if delegate != nil {
            delegate!.userDidSelectCreateProjectButton()
        }
    }

    @IBAction func sessionBtnPressed(sender: UIButton) {
        if delegate != nil {
            delegate!.userDidSelectCreateSessionButton()
        }
    }

    // IMPORTANT CHANGE TO SIGN OUT NAME
    @IBAction func btnLoginGoogle(sender: UIButton) {
        println("pressed")
        signIn!.signOut()
    }
    
    var signIn: GPPSignIn?

    var isSignedIn = false
    
    let labelCreateSession = "Create A Session"
    let labelStartTracking = "Start Tracking"
    
    let messageNoProjects = "You don't have any projects."
    let messageNoSessions = "You don't have any sessions."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Facebook login
        self.btnLogin.delegate = self
        self.btnLogin.readPermissions = ["public_profile", "email", "user_friends"]
        
        // Google plus
        signIn = GPPSignIn.sharedInstance()
        signIn?.shouldFetchGooglePlusUser = true
        signIn?.shouldFetchGoogleUserID = true
        signIn?.shouldFetchGoogleUserEmail = true
        signIn?.clientID = "47253329705-c8p8oqi7j036p5lakqia2jl3v3j1np2g.apps.googleusercontent.com"
        signIn?.scopes = ["profile", "email"]
        signIn?.delegate = self

//        println(UserAuthService.sharedInstance.user.name)
//        println(UserAuthService.sharedInstance.user.email)
//        println(UserAuthService.sharedInstance.accessToken)

 //       signIn?.trySilentAuthentication()
        
        refreshView()
    }

    // Changes the visibility of UI elements based on state variables.
    func refreshView() {
        
        // May need to change due to button having log in and log out function
 /*       if Data.isLoggedIn {
            btnLogin.hidden = true
        } else {
            btnLogin.hidden = false
        } */
        
        // There is a project currently selected
        if let project = Data.selectedProject {
            displayProject.text = project.getDisplayName()
            showSessionSection()
            
            if let session = Data.selectedSession {
                displaySession.text = session.getDisplayName()
                btnCreateSession.titleLabel!.text = labelStartTracking
            } else {
                displaySession.text = messageNoSessions
                btnCreateSession.titleLabel!.text = labelCreateSession
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
        btnCreateSession.hidden = false
    }
    
    func hideSessionSection() {
        displaySessionTitle.hidden = true
        displaySession.hidden = true
        btnCreateSession.hidden = true
    }
    
    // Facebook Delegate Methods
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
        btnLoginGoogle.hidden = true
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        isSignedIn = true
        let userAuth = UserAuthService.sharedInstance
        userAuth.loginToServerUsingFacebookToken(FBSession.activeSession().accessTokenData.accessToken)
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        // TODO: Make facebook login button hidden
        
        isSignedIn = false
        println("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
    // Google Plus Sign in
    func refreshInterfaceBasedOnSignIn() {

    }
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        if error == nil {
            UserAuthService.sharedInstance.loginToServerUsingGoogleToken(auth.accessToken)
            btnLogin.hidden = true
            btnLoginGoogle.hidden = true
        } else {
            println("Error: \(error)")
        }
    }
    
    func didDisconnectWithError(error: NSError!) {
        println(error)
    }
    
    func signOut() {
        println("User signed out")
        GPPSignIn.sharedInstance().signOut()
    }
    
}

