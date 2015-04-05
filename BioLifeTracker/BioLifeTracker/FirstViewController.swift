//
//  FirstViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 2/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, FBLoginViewDelegate, GPPSignInDelegate {
    
    @IBOutlet weak var displayProject: UILabel!
    @IBOutlet weak var displaySession: UILabel!
    @IBOutlet weak var displaySessionTitle: UILabel!
    @IBOutlet weak var btnCreateProject: UIButton!
    @IBOutlet weak var btnCreateSession: UIButton!

    /************Important***************/
    @IBOutlet weak var btnLogin: FBLoginView!
    /************************************/
    @IBOutlet weak var btnLoginGoogle: GPPSignInButton!

    /******************Important****************/
    // TODO: Make the google login button/view type of GPPSignInButton
    // More information on https://developers.google.com/+/mobile/ios/sign-in#add_the_sign-in_button
    @IBAction func btnLoginGoogle(sender: UIButton) {
        // Configure Google login
        if !isSignedIn {
            isSignedIn = true
            btnLogin.hidden = true
            
            /************Important***************/
            signIn = GPPSignIn.sharedInstance()
            signIn?.shouldFetchGooglePlusUser = true
            signIn?.shouldFetchGoogleUserID = true
            signIn?.shouldFetchGoogleUserEmail = true
            signIn?.clientID = "47253329705-c8p8oqi7j036p5lakqia2jl3v3j1np2g.apps.googleusercontent.com"
            signIn?.scopes = ["profile", "email"]
            signIn?.delegate = self
            signIn?.authenticate()
            /************************************/
            
        } else if isSignedIn {
            isSignedIn = false
            btnLogin.hidden = false
            println(UserAuthService.sharedInstance.user.name)
            println(UserAuthService.sharedInstance.user.email)
            println(UserAuthService.sharedInstance.accessToken)
            signIn!.signOut()
            println("signed out")
        }

    }
    
    /************Important***************/
    var signIn: GPPSignIn?
    /************************************/
    
    /************Important***************/
    // TODO: Can try implementing google login button and see whether it will change to logout button after login. if so, remove the variable below
    var isSignedIn = false
    /************************************/
    
    let labelCreateSession = "Create A Session"
    let labelStartTracking = "Start Tracking"
    
    let messageNoProjects = "You don't have any projects."
    let messageNoSessions = "You don't have any sessions."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /************Important***************/
        // Facebook login
        self.btnLogin.delegate = self
        self.btnLogin.readPermissions = ["public_profile", "email", "user_friends"]
        
        // Google plus
        signIn?.trySilentAuthentication()
        /************************************/
        
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
    
    
    /******************************Important******************************/
    // Facebook Delegate Methods
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
        // TODO: Make google login button hidden
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        isSignedIn = true
        
        let userEmail = user.objectForKey("email") as String
        let currentUser = User(name: user.name, email: userEmail)
        let userAuth = UserAuthService.sharedInstance
        userAuth.setUserAuth(currentUser, accessToken: FBSession.activeSession().accessTokenData.accessToken)
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        // TODO: Make facebook login button hidden
        
        isSignedIn = false
        println("User Logged Out")
        println(UserAuthService.sharedInstance.user.name)
        println(UserAuthService.sharedInstance.user.email)
        println(UserAuthService.sharedInstance.accessToken)

    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
    // Google Plus Sign in
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        if error == nil {
            
            let currentUser = User(name: signIn!.googlePlusUser.displayName, email: signIn!.userEmail)
            let userAuth = UserAuthService.sharedInstance
            userAuth.setUserAuth(currentUser, accessToken: auth.accessToken)
        } else {
            println("Error: \(error)")
        }
    }
    
    func didDisconnectWithError(error: NSError!) {
        println(error)
    }
    /****************************************************************************/
}

