//
//  SuperController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 31/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//
//  This class controls all controllers of the application, and
//  swaps the presented view controller if needed.
//

import UIKit

class SuperController: UIViewController, UISplitViewControllerDelegate {
    
    let splitVC = UISplitViewController()
    
    override func viewDidLoad() {
        
        let master = MenuViewController(style: UITableViewStyle.Grouped)
        master.title = "BioLifeTracker"
        let masterNav = UINavigationController(rootViewController: master)
        
        let data = FormFieldData(sections: 3)
        data.addTextCell(label: "Text1", hasSingleLine: true)
        data.addTextCell(label: "Text2", hasSingleLine: false)
        data.addBooleanCell(label: "YES?")
        data.addTextCell(section: 1, label: "Sec2A", hasSingleLine: true)
        data.addTextCell(section: 1, label: "Sec2B", hasSingleLine: true)
        data.addTextCell(section: 1, label: "Sec2C", hasSingleLine: true)
        data.addTextCell(section: 2, label: "Sec2A", hasSingleLine: true)
        data.addTextCell(section: 2, label: "Sec2B", hasSingleLine: true)
        data.addTextCell(section: 2, label: "Sec2C", hasSingleLine: true)
        
        let detail = FormViewController(style: UITableViewStyle.Grouped)
        detail.title = "Form"
        detail.setFormData(data)
        detail.cellHorizontalPadding = 10
        
        let detailNav = UINavigationController(rootViewController: detail)
        
        splitVC.viewControllers = [masterNav, detailNav]
        splitVC.delegate = self
        
        self.view.addSubview(splitVC.view)
        splitVC.view.frame = self.view.frame
    }
}
