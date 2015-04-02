//
//  MenuViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 31/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    
    var delegate: MenuViewDelegate? = nil
    
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if delegate != nil {
            if loggedIn {
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
            } else {
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
                        delegate!.userDidSelectGraphs()
                        break
                    case 3:
                        delegate!.userDidSelectData()
                        break
                    default:
                        break
                    }
                case 1:
                    delegate!.userDidSelectSettings()
                    break
                case 2:
                    if indexPath.row == 1 {
                        delegate!.userDidSelectLogout()
                    }
                    break
                default:
                    break
                }
            }
        }
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
                return userSection.count
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
