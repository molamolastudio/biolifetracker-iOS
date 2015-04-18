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
    }
    
    // IMPORTANT CHANGE TO SIGN OUT NAME
    @IBAction func btnLoginGoogle(sender: UIButton) {
        println("pressed")
        signIn!.signOut()
    }
    
    @IBAction func showSuperVC(sender: AnyObject) {
        let vc = SuperController()
        presentViewController(vc, animated: true, completion: nil)
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

