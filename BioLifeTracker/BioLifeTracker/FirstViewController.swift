//
//  FirstViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 2/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, FBLoginViewDelegate, GPPSignInDelegate {

    @IBOutlet weak var btnLogin: FBLoginView!
    @IBOutlet weak var btnLoginGoogle: GPPSignInButton!

    var signIn: GPPSignIn?
    
    var isSignedIn = false
    
    let labelCreateSession = "Create A Session"
    let labelStartTracking = "Start Tracking"
    
    let messageNoProjects = "You don't have any projects."
    let messageNoSessions = "You don't have any sessions."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFacebookLoginButton()
        setupGoogleLoginButton()
        
        // If user is logged in, move to super vc immediately
        if trySilentAuthentication() {
            showSuperVC()
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // If user is logged in
        if UserAuthService.sharedInstance.hasAccessToken() {
            view.hidden = true
            showSuperVC()
        } else {
            view.hidden = false
        }
    }
    
    func trySilentAuthentication() -> Bool {
        var isSignedIn = false
        return UserAuthService.sharedInstance.hasAccessToken()
    }
    
    func setupFacebookLoginButton() {
        self.btnLogin.delegate = self
        self.btnLogin.readPermissions = ["public_profile", "email", "user_friends"]
    }
    
    func setupGoogleLoginButton() {
        signIn = GPPSignIn.sharedInstance()
        signIn?.shouldFetchGooglePlusUser = true
        signIn?.shouldFetchGoogleUserID = true
        signIn?.shouldFetchGoogleUserEmail = true
        signIn?.clientID = "47253329705-c8p8oqi7j036p5lakqia2jl3v3j1np2g.apps.googleusercontent.com"
        signIn?.scopes = ["profile", "email"]
        signIn?.delegate = self
    }
    
    // IMPORTANT CHANGE TO SIGN OUT NAME
    @IBAction func btnLoginGoogle(sender: UIButton) {
        println("pressed")
        signIn!.signOut()
    }
    
    @IBAction func showSuperVC(sender: AnyObject) {
        showSuperVC()
    }
    
    func showSuperVC() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    // Facebook Delegate Methods
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
        showSuperVC()
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        isSignedIn = true
        let userAuth = UserAuthService.sharedInstance
        userAuth.loginToServerUsingFacebookToken(FBSession.activeSession().accessTokenData.accessToken)
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        isSignedIn = false
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
    // Google Plus Sign in
    func refreshInterfaceBasedOnSignIn() {

    }
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        if error == nil {
            println("User Logged In")
            UserAuthService.sharedInstance.loginToServerUsingGoogleToken(auth.accessToken)
            showSuperVC()
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

