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

class SuperController: UIViewController, UISplitViewControllerDelegate, MenuViewDelegate {
    
    let splitVC = UISplitViewController()
    let menu = MenuViewController(style: UITableViewStyle.Grouped)
    let newProject = FormViewController(style: UITableViewStyle.Grouped)
    let newIndividual = FormViewController(style: UITableViewStyle.Grouped)
    
    override func viewDidLoad() {
        
        setupMenu()
        setupNewProject()
        
        let masterNav = UINavigationController(rootViewController: menu)
        let detailNav = UINavigationController(rootViewController: newProject)
        
        splitVC.viewControllers = [masterNav, detailNav]
        splitVC.delegate = self
        
        self.view.addSubview(splitVC.view)
        splitVC.view.frame = self.view.frame
    }
    
    func setupMenu() {
        menu.title = "BioLifeTracker"
        menu.delegate = self
    }
    
    func setupNewProject() {
        newProject.title = "New Project"
        newProject.setFormData(getFormDataForNewProject())
        newProject.cellHorizontalPadding = 10
        newProject.roundedCells = true
    }
    
    func setupNewIndividual() {
        newIndividual.title = "New Individual"
        newIndividual.setFormData(getFormDataForNewIndividual())
        newIndividual.cellHorizontalPadding = 10
        newIndividual.roundedCells = true
    }
    
    func getFormDataForNewProject() -> FormFieldData {
        let data = FormFieldData(sections: 2)
        data.addTextCell(section: 0, label: "Name", hasSingleLine: true)
        data.addTextCell(section: 0, label: "Ethogram", hasSingleLine: true) // Custom picker cell
        data.setSectionTitle(1, title: "Members")
        data.addTextCell(section: 1, label: "Enter Member Here", hasSingleLine: true) // To be decided
        return data
    }
    
    func getFormDataForNewIndividual() -> FormFieldData {
        let data = FormFieldData(sections: 1)
        data.addTextCell(section: 0, label: "Name", hasSingleLine: true)
        data.addTextCell(section: 0, label: "Tags", hasSingleLine: false)
        data.addTextCell(section: 1, label: "Photos", hasSingleLine: true) // Photo picker cell
        return data
    }
    
    func userDidSelectProjects() {
        println("projects")
        let data = newProject.getFormData()
        let name = data[0] as String
        let ethogram = Ethogram(name: data[1] as String)
        let project = Project(name: name, ethogram: ethogram)
    }
    
    func userDidSelectEthograms() {
        
    }
    
    func userDidSelectGraphs() {
        
    }
    
    func userDidSelectData() {
        
    }
    
    func userDidSelectSettings() {
        
    }
    
    func userDidSelectFacebookLogin() {
        
    }
    
    func userDidSelectGoogleLogin() {
        
    }
    
    func userDidSelectLogout() {
        
    }
    
    func userDidSelectSessions(project: Project) {
        
    }
    
    func userDidSelectIndividuals(project: Project) {
        
    }
    
    func userDidSelectObservations(project: Project, session: Session) {
        
    }
}
