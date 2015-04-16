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

class SuperController: UIViewController, UISplitViewControllerDelegate, MenuViewControllerDelegate, FirstViewControllerDelegate, ProjectsViewControllerDelegate, EthogramsViewControllerDelegate, ProjectHomeViewControllerDelegate, ScanSessionViewControllerDelegate {
    
    let splitVC = UISplitViewController()
    let masterNav = UINavigationController()
    let detailNav = UINavigationController()
    
    let menu = MenuViewController(style: UITableViewStyle.Grouped)
    
    let ethogramPickerValues = ["Ethogram 1", "Ethogram 2"]
    
    let popup = CustomPickerPopup()
    
    var currentProject: Project? = nil
    var currentSession: Session? = nil
    
    override func viewDidLoad() {
        setupForDemo()
        
        setupMenu()
        
        masterNav.setViewControllers([menu], animated: true)
        
        splitVC.viewControllers = [masterNav, detailNav]
        splitVC.delegate = self
        
        self.view.addSubview(splitVC.view)
        splitVC.view.frame = self.view.frame
        
        showStartPage()
    }
    
    func setupForDemo() {
        // Insert some ethograms
        EthogramManager.sharedInstance.addEthogram(Ethogram(name: ethogramPickerValues[0]))
        EthogramManager.sharedInstance.addEthogram(Ethogram(name: ethogramPickerValues[1]))
        
        ProjectManager.sharedInstance.addProject(Project(name: "Activity Pattern with Cobra", ethogram: EthogramManager.sharedInstance.ethograms[0]))
        ProjectManager.sharedInstance.addProject(Project(name: "Activity Pattern with Penguin", ethogram: EthogramManager.sharedInstance.ethograms[1
            ]))
    }
    
    // Setup methods
    func setupMenu() {
        menu.title = "BioLifeTracker"
        menu.delegate = self
    }
    
    // Methods for creating form data
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
    
    // Methods to show pages
    func showStartPage() {
        let vc = FirstViewController(nibName: "FirstView", bundle: nil)
        vc.title = "Home"
        vc.delegate = self
        detailNav.setViewControllers([vc], animated: true)
    }
    
    func showNewProjectPage() {
        let vc = FormViewController(style: UITableViewStyle.Grouped)
        
        vc.title = "New Project"
        vc.setFormData(getFormDataForNewProject())
        vc.cellHorizontalPadding = 10
        vc.roundedCells = true
        
        var createBtn = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("createNewProject"))
        vc.navigationItem.rightBarButtonItem = createBtn
        
        detailNav.pushViewController(vc, animated: true)
    }
    
    func showProjectsPage() {
        let vc = ProjectsViewController()
        
        vc.delegate = self
        vc.title = "Projects"
        
        var createBtn = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("showNewProjectPage"))
        vc.navigationItem.rightBarButtonItem = createBtn
        
        detailNav.setViewControllers([vc], animated: false)
    }
    
    func showProjectHomePage() {
        let vc = ProjectHomeViewController(nibName: "ProjectHomeView", bundle: nil)
        
        vc.delegate = self
        vc.title = currentProject!.name
        vc.currentProject = currentProject!
        
        detailNav.pushViewController(vc, animated: true)
    }
    
    func showEthogramsPage() {
        let vc = EthogramsViewController()
        
        vc.delegate = self
        vc.title = "Ethograms"
        
        var createBtn = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("showNewEthogramPage"))
        vc.navigationItem.rightBarButtonItem = createBtn
        
        detailNav.setViewControllers([vc], animated: false)
    }
    
    func showNewEthogramPage() {
        let vc = EthogramFormViewController()
        
        vc.title = "Create New Ethogram"
        
        var createBtn = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("createNewEthogram"))
        vc.navigationItem.rightBarButtonItem = createBtn
        
        detailNav.pushViewController(vc, animated: true)
    }
    
    func showEthogramDetailsPage() {
        let vc = EthogramFormViewController()
        vc.ethogram = Data.selectedEthogram!
        
        var createBtn = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("showEthogramsPage"))
        vc.navigationItem.rightBarButtonItem = createBtn
        
        detailNav.pushViewController(vc, animated: true)
    }
    
    func showNewSessionPage() {
        let vc = FormViewController()
        
        vc.title = "New Session"
        
        vc.setFormData(getFormDataForNewSession())
        vc.cellHorizontalPadding = 10
        vc.roundedCells = true
        
        var createBtn = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("showObservationsPage"))
        vc.navigationItem.rightBarButtonItem = createBtn
        
        detailNav.pushViewController(vc, animated: true)
    }
    
    func showObservationsPage() {
        let vc = ObservationsViewController()
        
        vc.title = "Observations"
        vc.currentProject = currentProject
        vc.currentSession = currentSession
        
        var createBtn = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.Plain, target: self, action: Selector(""))
        vc.navigationItem.rightBarButtonItem = createBtn
        
        detailNav.pushViewController(vc, animated: true)
    }
    
    func showNewIndividualPage() {
        let vc = FormViewController(style: UITableViewStyle.Grouped)
        
        vc.title = "New Individual"
        vc.setFormData(getFormDataForNewIndividual())
        vc.cellHorizontalPadding = 10
        vc.roundedCells = true
        
        detailNav.pushViewController(vc, animated: true)
    }
    
    func showSession(session: Session) {
        if session.type == SessionType.Focal {
            showFocalSessionPage(session)
        } else {
            showScanSessionPage(session)
        }
    }
    
    func showFocalSessionPage(session: Session) {
        
    }
    
    func showScanSessionPage(session: Session) {
        
    }
    
    func clearNavigationStack() {
        detailNav.popToRootViewControllerAnimated(false)
    }
    
    // Selectors for creating Model objects
    func createNewProject() {
        if let vc = detailNav.visibleViewController as? FormViewController {
            let values = vc.getFormData()
            
            if let name = values[0] as? String {
                if let index = values[1] as? Int {
                    let project = Project(name: name, ethogram: EthogramManager.sharedInstance.ethograms[index])
                    
                    ProjectManager.sharedInstance.addProject(project)
                    
                    showProjectsPage()
                }
            }
        }
    }
    
    func createNewEthogram() {
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
    
    // ProjectHomeViewControllerDelegate methods
    func userDidSelectSession(project: Project, session: Session) {
        showSession(session)
    }
    
    func userDidSelectMember(project: Project, member: User) {
        
    }
    
    func userDidSelectGraph() {
        
    }
    
    func userDidSelectCreateSession() {
        // Popup options: name, type
        // After popup -> create then show the type of session
    }
    
    func userDidSelectEditMembers() {
        
    }
    
    // ScanSessionViewControllerDelegate methods
    func userDidSelectScan(session: Session, index: Int) {
        
    }
    
}
