//
//  AppDelegate.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var initialViewController: SuperController?
    var incomingFileUrl: NSURL?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        FBLoginView.self
        
        initialViewController = SuperController()
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = initialViewController
        window!.makeKeyAndVisible()

        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return  FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication) ||
                GPPURLHandler.handleURL(url, sourceApplication: sourceApplication, annotation: annotation) ||
                tryOpenProjectFileInUrl(url)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        EthogramManager.sharedInstance.saveToArchives()
        ProjectManager.sharedInstance.saveToArchives()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func tryOpenProjectFileInUrl(url: NSURL) -> Bool {
        if url.absoluteString!.hasSuffix(".bltproject") {
            incomingFileUrl = url
            var deserializer = BLTProjectDeserializer()
            if let decodedProject = deserializer.process(url) {
                ProjectManager.sharedInstance.addProject(decodedProject)
                initialViewController?.showProjectsPage()
            } else {
                initialViewController?.showCorruptFileAlert()
            }
            return true
        }
        return false
    }
}

