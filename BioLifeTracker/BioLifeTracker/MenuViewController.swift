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
    
    let homeSection = ["Home"]
    let projectSection = ["Projects", "Ethograms", "Analyse"]
    let settingsSection = ["Settings"]
    let socialSectionLoggedIn = ["Email", "Logout"]
    let socialSectionLoggedOut = ["Google+ Login", "Facebook Login"]
    
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
            cell.label.text = homeSection[indexPath.row]
            break
        case 1:
            cell.label.text = projectSection[indexPath.row]
            break
        case 2:
            cell.label.text = settingsSection[indexPath.row]
            break
        case 3:
            if loggedIn {
                cell.label.text = socialSectionLoggedIn[indexPath.row]
                if indexPath.row == 0 {
                    cell.textField.text = user.name + "@gmail.com"
                }
            } else {
                cell.label.text = socialSectionLoggedOut[indexPath.row]
            }
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
            case 1:
                switch indexPath.row {
                case 0:
                    delegate!.userDidSelectProjects()
                    break
                case 1:
                    delegate!.userDidSelectEthograms()
                    break
                case 2:
                    delegate!.userDidSelectGraphs()
                    break
                case 3:
                    delegate!.userDidSelectData()
                    break
                default:
                    break
                }
            case 2:
                delegate!.userDidSelectSettings()
                break
            case 3:
                if indexPath.row == 1 {
                    delegate!.userDidSelectLogout()
                }
                break
            default:
                break
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return homeSection.count
        case 1:
            return projectSection.count
        case 2:
            return settingsSection.count
        case 3:
            if loggedIn {
                return socialSectionLoggedIn.count
            } else {
                return socialSectionLoggedOut.count
            }
        default:
            return 0
        }
    }
}
