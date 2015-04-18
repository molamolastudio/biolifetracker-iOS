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
    
    let cellReuseIdentifier = "SingleLineTextCell"
    
    let projectSection = ["Projects", "Ethograms", "Analyse"]
    let settingsSection = ["Settings"]
    let socialSectionLoggedIn = ["Logout"]
    
    var user: User = UserAuthService.sharedInstance.user
    
    var loggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! SingleLineTextCell
        
        cell.rounded = false
        cell.textField.text = ""
        
        switch indexPath.section {
        case 0:
            cell.label.text = projectSection[indexPath.row]
            break
        case 1:
            cell.label.text = settingsSection[indexPath.row]
            break
        case 2:
            
            cell.label.text = socialSectionLoggedIn[indexPath.row]
            
            break
        default:
            break
        }
        
        cell.textField.enabled = false
        
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
                delegate!.userDidSelectSettings()
                break
            case 2:
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
            return settingsSection.count
        case 2:
            return socialSectionLoggedIn.count
        default:
            return 0
        }
    }
}
