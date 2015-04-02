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
        
        let master = MenuViewController()
        let masterNav = UINavigationController(rootViewController: master)
        
        let data = FormFieldData()
        data.addTextCell(label: "Text1", hasSingleLine: true)
        data.addTextCell(label: "Text2", hasSingleLine: false)
        data.addBooleanCell(label: "YES?")
        
        let detail = FormViewController()
        detail.setFormData(data)
        
        let detailNav = UINavigationController(rootViewController: detail)
        
        splitVC.viewControllers = [masterNav, detailNav]
        splitVC.delegate = self
        
        self.view.addSubview(splitVC.view)
        splitVC.view.frame = self.view.frame
    }
}
