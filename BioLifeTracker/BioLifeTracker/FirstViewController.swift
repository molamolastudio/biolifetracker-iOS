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
    
    let labelCreateSession = "Create A Session"
    let labelStartTracking = "Start Tracking"
    
    let messageNoProjects = "You don't have any projects."
    let messageNoSessions = "You don't have any sessions."
    
    var alert: UIAlertController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFacebookLoginButton()
        setupGoogleLoginButton()
        
        // Set up alert controller
        let alertTitle = "Signing In"
        let alertMessage = "Please wait..."
        alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
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
    
    @IBAction func showSuperVC(sender: AnyObject) {
        showSuperVC()
    }
    
    func showSuperVC() {
        if alert != nil {
            alert!.dismissViewControllerAnimated(true, completion: nil)
        }
        let userAuthService = UserAuthService.sharedInstance
        if !userAuthService.hasAccessToken() {
            let failAlert = UIAlertController(title: "Login Fail", message: "The server rejected your social account login", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            failAlert.addAction(defaultAction)
            self.presentViewController(failAlert, animated: true, completion: nil)
            return
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // FACEBOOK METHODS
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        // this method is called before loginViewFetchedUserInfo
        // do nothing
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        // Show loading alert
        self.presentViewController(alert!, animated: false, completion: nil)
        
        let userAuth = UserAuthService.sharedInstance
        userAuth.loginToServerUsingFacebookToken(
            FBSession.activeSession().accessTokenData.accessToken,
            onCompletion: showSuperVC)
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
    // GOOGLE PLUS METHODS
    func refreshInterfaceBasedOnSignIn() {
        
    }
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        if error == nil {
            println("User Logged In")
            
            // Show loading alert
            self.presentViewController(alert!, animated: false, completion: nil)
            
            UserAuthService.sharedInstance.loginToServerUsingGoogleToken(
                auth.accessToken,
                onCompletion: showSuperVC)
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

