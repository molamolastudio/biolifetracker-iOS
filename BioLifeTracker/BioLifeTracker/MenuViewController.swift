//
//  MenuViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 31/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    
    let cellIdentifier = "MenuCell"
    
    let userSection = ["Welcome"]
    let projectSection = ["Projects", "Ethograms", "Graphs", "All Data"]
    let settingsSection = ["Settings"]
    let socialSectionLoggedIn = ["Email", "Logout"]
    let socialSectionLoggedOut = ["Google+ Login", "Facebook Login"]
    
    var user: User = User(id: "", name: "User")
    
    var loggedIn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "SingleLineTextCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as SingleLineTextCell
        
        cell.rounded = false
        cell.textField.text = ""
        
        if loggedIn {
            switch indexPath.section {
            case 0:
                cell.label.text = userSection[indexPath.row]
                cell.textField.text = user.name
                break
            case 1:
                cell.label.text = projectSection[indexPath.row]
                break
            case 2:
                cell.label.text = settingsSection[indexPath.row]
                break
            case 3:
                cell.label.text = socialSectionLoggedIn[indexPath.row]
                if indexPath.row == 0 {
                    cell.textField.text = user.name + "@gmail.com"
                }
                break
            default:
                break
            }
        } else {
            switch indexPath.section {
            case 0:
                cell.label.text = projectSection[indexPath.row]
                break
            case 1:
                cell.label.text = settingsSection[indexPath.row]
                break
            case 2:
                cell.label.text = socialSectionLoggedOut[indexPath.row]
                break
            default:
                break
            }
        }
        
        cell.textField.enabled = false
        
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if loggedIn {
            return 4
        } else {
            return 3
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loggedIn {
            switch section {
            case 0:
                return 1
            case 1:
                return projectSection.count
            case 2:
                return settingsSection.count
            case 3:
                return socialSectionLoggedIn.count
            default:
                return 0
            }
        } else {
            switch section {
            case 0:
                return projectSection.count
            case 1:
                return settingsSection.count
            case 2:
                return socialSectionLoggedOut.count
            default:
                return 0
            }
        }
    }
    
}
