//
//  SessionsViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 13/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class SessionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let segueToSessionDetails = "SessionsToSessionDetails"
    
    let cellReuseIdentifier = "SessionTableCell"
    
    let messageCellSubtitle = "Observations: "
    
    let numSections = 1
    
    override func viewDidLoad() {
        if Data.selectedProject!.sessions.count == 0 {
            var sessions = [Session]()
            sessions.append(Session(project: Data.selectedProject!, type: .Focal))
            Data.selectedProject!.addSessions(sessions)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func btnCreatePressed(sender: AnyObject) {
        // Create new sessions
    }
    
    // UITableViewDataSource and UITableViewDelegate METHODS
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell
        
        let title = cell.viewWithTag(Constants.ViewTags.ethogramsCellTitle) as UILabel
        let subtitle = cell.viewWithTag(Constants.ViewTags.ethogramsCellSubtitle) as UILabel
        let session = Data.selectedProject!.sessions[indexPath.row]
        
        //title.text = session.id
        subtitle.text = messageCellSubtitle + String(session.observations.count)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        Data.selectedSession = Data.selectedProject!.sessions[indexPath.row]
        self.performSegueWithIdentifier(segueToSessionDetails, sender: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.selectedProject!.sessions.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numSections
    }

}
