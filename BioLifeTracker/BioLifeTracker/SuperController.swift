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

class SuperController: UIViewController, UISplitViewControllerDelegate, MenuViewControllerDelegate, FirstViewControllerDelegate, ProjectsViewControllerDelegate, EthogramsViewControllerDelegate, SessionsViewControllerDelegate, ProjectHomeViewControllerDelegate {
    
    let splitVC = UISplitViewController()
    let masterNav = UINavigationController()
    let detailNav = UINavigationController()
    
    let menu = MenuViewController(style: UITableViewStyle.Grouped)
    
    let startPage = FirstViewController(nibName: "FirstView", bundle: nil)
    let newProject = FormViewController(style: UITableViewStyle.Grouped)
    let newIndividual = FormViewController(style: UITableViewStyle.Grouped)
    
    let ethogramPickerValues = ["Ethogram 1", "Ethogram 2"]
    
    let popup = CustomPickerPopup()
    
    var currentProject: Project? = nil
    var currentSession: Session? = nil
    
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
        
        ProjectManager.sharedInstance.addProject(Project(name: "Activity Pattern with Cobra", ethogram: EthogramManager.sharedInstance.ethograms[0]))
        ProjectManager.sharedInstance.addProject(Project(name: "Activity Pattern with Penguin", ethogram: EthogramManager.sharedInstance.ethograms[1
            ]))
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
    
    func getFormDataForNewSession() -> FormFieldData {
        let data = FormFieldData(sections: 1)
        data.addTextCell(section: 0, label: "Name", hasSingleLine: true)
        data.addPickerCell(section: 0, label: "Locations", pickerValues: ["Location 1", "Location 2"], isCustomPicker: true)
        data.addPhotoPickerCell(section: 0, label: "Photos")
        return data
    }
    
    func showNewProjectPage() {
        detailNav.pushViewController(newProject, animated: true)
        var createBtn = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("createNewProject"))
        newProject.navigationItem.rightBarButtonItem = createBtn
    }
    
    func createNewProject() {
        let values = newProject.getFormData()
        
        if let name = values[0] as? String {
            if let index = values[1] as? Int {
                let project = Project(name: name, ethogram: EthogramManager.sharedInstance.ethograms[index])
                
                ProjectManager.sharedInstance.addProject(project)
                
                showProjectsPage()
            }
        }
    }
    
    func showProjectsPage() {
        let projects = ProjectsViewController()
        projects.delegate = self
        projects.title = "Projects"
        var createBtn = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("showNewProjectPage"))
        projects.navigationItem.rightBarButtonItem = createBtn
        detailNav.setViewControllers([projects], animated: false)
    }
    
    func showProjectHomePage() {
        let home = ProjectHomeViewController(nibName: "ProjectHomeView", bundle: nil)
        home.delegate = self
        home.title = currentProject!.name
        home.currentProject = currentProject!
        detailNav.pushViewController(home, animated: true)
    }
    
    func showEthogramsPage() {
        let ethograms = EthogramsViewController()
        ethograms.delegate = self
        ethograms.title = "Ethograms"
        var createBtn = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("showNewEthogramPage"))
        ethograms.navigationItem.rightBarButtonItem = createBtn
        detailNav.setViewControllers([ethograms], animated: false)
    }
    
    func showNewEthogramPage() {
        println("show new ethogram page")
        let newEthogram = EthogramFormViewController()
        newEthogram.title = "Create New Ethogram"
        var createBtn = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("newEthogramCreated"))
        newEthogram.navigationItem.rightBarButtonItem = createBtn
        detailNav.pushViewController(newEthogram, animated: true)
    }
    
    func showEthogramDetailsPage() {
        let details = EthogramDetailsViewController()
        detailNav.pushViewController(details, animated: true)
    }
    
    func showSessionsPage() {
        let sessions = SessionsViewController()
        sessions.title = "Sessions"
        sessions.delegate = self
        sessions.currentProject = currentProject
        var createBtn = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.Plain, target: self, action: Selector(""))
        sessions.navigationItem.rightBarButtonItem = createBtn
        detailNav.pushViewController(sessions, animated: true)
    }
    
    func showNewSessionPage() {
        let newSession = FormViewController()
        newSession.title = "New Session"
        var createBtn = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("showObservationsPage"))
        newSession.navigationItem.rightBarButtonItem = createBtn
        
        newSession.setFormData(getFormDataForNewSession())
        newSession.cellHorizontalPadding = 10
        newSession.roundedCells = true
        detailNav.pushViewController(newSession, animated: true)
    }
    
    func showObservationsPage() {
        let observations = ObservationsViewController()
        observations.title = "Observations"
        observations.currentProject = currentProject
        observations.currentSession = currentSession
        var createBtn = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.Plain, target: self, action: Selector(""))
        observations.navigationItem.rightBarButtonItem = createBtn
        
        detailNav.pushViewController(observations, animated: true)
    }
    
    func clearNavigationStack() {
        detailNav.popToRootViewControllerAnimated(false)
    }
    
    // Selectors for creation
    func newEthogramCreated() {
        if let vc = detailNav.visibleViewController as? EthogramFormViewController {
            if let ethogram = vc.getEthogram() {
                EthogramManager.sharedInstance.addEthogram(vc.ethogram)
                detailNav.popViewControllerAnimated(true)
            }
        }
    }
    
    // MenuViewDelegate methods
    func userDidSelectProjects() {
        clearNavigationStack()
        showProjectsPage()
    }
    
    func userDidSelectEthograms() {
        clearNavigationStack()
        showEthogramsPage()
    }
    
    func userDidSelectGraphs() {
        clearNavigationStack()
    }
    
    func userDidSelectData() {
        clearNavigationStack()
    }
    
    func userDidSelectSettings() {
        clearNavigationStack()
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
    
    // ProjectsViewControllerDelegate methods
    func userDidSelectProject(selectedProject: Project) {
        println(selectedProject.name)
        currentProject = selectedProject
        showProjectHomePage()
    }
    
    // EthogramsViewControllerDelegate methods
    func userDidSelectEthogram(selectedEthogram: Ethogram) {
        Data.selectedEthogram = selectedEthogram
        showEthogramDetailsPage()
    }
    
    // SessionsViewControllerDelegate methods
    func userDidSelectSession(selectedProject: Project, selectedSession: Session) {
        currentProject = selectedProject
        currentSession = selectedSession
        showObservationsPage()
    }
    
    // ProjectHomeViewControllerDelegate methods
    func userDidSelectSession(tag: Int, project: Project, session: Session) {
        
    }
    
    func userDidSelectMember(project: Project, member: User) {
        
    }
    
    func userDidChangeEthogram(project: Project, ethogram: Ethogram) {
        
    }
    
}
