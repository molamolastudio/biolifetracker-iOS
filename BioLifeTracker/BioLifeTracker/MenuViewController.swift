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
    let settingsSection = ["Settings"]
    let settingsSectionIcons = ["gearicon"]
    let socialSectionLoggedIn = ["Logout"]
    let socialSectionLoggedInIcons = ["logouticon"]
    
    var user: User = UserAuthService.sharedInstance.user
    
    var loggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! UITableViewCell
        
        var icon: UIImageView
        
        switch indexPath.section {
        case 0:
            cell.textLabel!.text = projectSection[indexPath.row]
            var image: UIImage? = nil
            image = UIImage(named: projectSectionIcons[indexPath.row])
            cell.imageView!.image = image
        case 1:
            cell.textLabel!.text = settingsSection[indexPath.row]
            var image: UIImage? = nil
            image = UIImage(named: settingsSectionIcons[indexPath.row])
            cell.imageView!.image = image
        case 2:
            cell.textLabel!.text = socialSectionLoggedIn[indexPath.row]
            var image: UIImage? = nil
            image = UIImage(named: socialSectionLoggedInIcons[indexPath.row])
            cell.imageView!.image = image
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
