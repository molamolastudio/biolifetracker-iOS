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

class SuperController: UIViewController, UISplitViewControllerDelegate, MenuViewControllerDelegate, FirstViewControllerDelegate {
    
    let splitVC = UISplitViewController()
    let masterNav = UINavigationController()
    let detailNav = UINavigationController()
    
    let menu = MenuViewController(style: UITableViewStyle.Grouped)
    
    let startPage = FirstViewController(nibName: "FirstView", bundle: nil)
    let newProject = FormViewController(style: UITableViewStyle.Grouped)
    let newIndividual = FormViewController(style: UITableViewStyle.Grouped)
    
    let ethogramPickerValues = ["Ethogram 1", "Ethogram 2"]
    
    let popup = CustomPickerPopup()
    
    override func viewDidLoad() {
        setupForDemo()
        
        setupMenu()
        setupNewProject()
        setupStartPage()
        
        masterNav.setViewControllers([menu], animated: true)
        detailNav.setViewControllers([startPage], animated: true)

        splitVC.viewControllers = [masterNav, detailNav]
        splitVC.delegate = self
        
        self.view.addSubview(splitVC.view)
        splitVC.view.frame = self.view.frame
    }
    
    func setupForDemo() {
        // Insert some ethograms
        EthogramManager.sharedInstance.addEthogram(Ethogram(name: ethogramPickerValues[0]))
        EthogramManager.sharedInstance.addEthogram(Ethogram(name: ethogramPickerValues[1]))
    }
    
    func setupMenu() {
        menu.title = "BioLifeTracker"
        menu.delegate = self
    }
    
    func setupStartPage() {
        startPage.title = "Home"
        startPage.delegate = self
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
        data.addPickerCell(section: 0, label: "Ethogram", pickerValues: ethogramPickerValues, isCustomPicker: true)
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
    
    func showNewProjectPage() {
        detailNav.pushViewController(newProject, animated: true)
        var createBtn = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("createNewProject"))
        newProject.navigationItem.rightBarButtonItem = createBtn
    }
    
    func createNewProject() {
        let values = newProject.getFormData()
        
        if let name = values[0] as? String {
            if let index = values[1] as? Int {
                let project = Project(name: name, ethogram: EthogramManager.sharedInstance.ethograms[index])
                
                ProjectManager.sharedInstance.addProject(project)
                
                detailNav.popViewControllerAnimated(true)
            }
        }
    }
    
    // MenuViewDelegate methods
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
    
    // FirstViewControllerDelegate methods
    func userDidSelectCreateProjectButton() {
        showNewProjectPage()
    }
    
    func userDidSelectCreateSessionButton() {
        
    }
}
