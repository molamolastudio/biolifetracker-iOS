//
//  MenuViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 31/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    
    var delegate: MenuViewControllerDelegate? = nil
    
    let cellReuseIdentifier = "MenuCell"
    
    let projectSection = ["Projects", "Ethograms", "Analyse"]
    let projectSectionIcons = ["foldericon", "tableicon", "graphicon"]
    let socialSectionLoggedIn = ["Logout"]
    let socialSectionLoggedInIcons = ["logouticon"]
    
    var user: User = UserAuthService.sharedInstance.user
    
    var loggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerNib(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! MenuCell
        
        switch indexPath.section {
        case 0:
            cell.label.text = projectSection[indexPath.row]
            var image = UIImage(named: projectSectionIcons[indexPath.row])
            cell.icon.image = image
        case 1:
            cell.label.text = socialSectionLoggedIn[indexPath.row]
            var image = UIImage(named: socialSectionLoggedInIcons[indexPath.row])
            cell.icon.image = image
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if delegate != nil {
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    delegate!.userDidSelectProjects()
                    break
                case 1:
                    delegate!.userDidSelectEthograms()
                    break
                case 2:
                    delegate!.userDidSelectAnalysis()
                    break
                default:
                    break
                }
            case 1:
                delegate!.userDidSelectLogout()
                break
            default:
                break
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return projectSection.count
        case 1:
            return socialSectionLoggedIn.count
        default:
            return 0
        }
    }
}
