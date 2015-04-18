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

class SuperController: UIViewController, UISplitViewControllerDelegate, MenuViewControllerDelegate,ProjectsViewControllerDelegate, EthogramsViewControllerDelegate, ProjectHomeViewControllerDelegate, ScanSessionViewControllerDelegate, FocalSessionViewControllerDelegate {
    
    let splitVC = UISplitViewController()
    let masterNav = UINavigationController()
    let detailNav = UINavigationController()
    
    let menu = MenuViewController(style: UITableViewStyle.Grouped)
    
    let popup = CustomPickerPopup()
    
    var currentProject: Project? = nil
    var currentSession: Session? = nil
    
    override func viewDidLoad() {
        // Load data
        UserAuthService.sharedInstance.useDefaultUser()
        //setupForDemo()
        
        setupSplitView()
        
        showStartPage()
    }
    
    // Closes the master view of the split view before dismissing self.
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
        dismissMenuView()
        super.dismissViewControllerAnimated(flag, completion: completion)
    }
    
    // Closes the master view of the split view.
    func dismissMenuView() {
        let barButtonItem = splitVC.displayModeButtonItem()
        UIApplication.sharedApplication().sendAction(barButtonItem.action, to: barButtonItem.target, from: nil, forEvent: nil)
    }
    
    func setupForDemo() {
        let state1 = BehaviourState(name: "Feeding", information: "Small claws bringing food to mouth")
        let state2 = BehaviourState(name: "Fighting", information: "Engagement of large clawa with another crab")
        let state3 = BehaviourState(name: "Hiding", information: "Withdrawal of fiddler crab into its burrow")
        var ethogram = Ethogram(name: "Fiddler Crabs")
        
        
        let user1 = User(name: "Captain America", email: "iamcaptamerica@default.com")
        let user2 = User(name: "The Hulk", email: "iamgreen@default.com")
        let user3 = User(name: "Black Power Ranger", email: "black.ranger@default.com")
        
        ethogram.addBehaviourState(state1)
        ethogram.addBehaviourState(state2)
        ethogram.addBehaviourState(state3)
        
        var project = Project(name: "A Day in a Fiddler Crab life", ethogram: ethogram)
        
        var session1 = Session(project: project, name: "Session1", type: SessionType.Scan)
        var session2 = Session(project: project, name: "Session2", type: SessionType.Scan)
        var session3 = Session(project: project, name: "Session3", type: SessionType.Scan)
        
        var session4 = Session(project: project, name: "Session4", type: SessionType.Focal)
        
        let individual1 = Individual(label: "M1")
        let individual2 = Individual(label: "M2")
        let individual3 = Individual(label: "F1")
        
        project.addIndividuals([individual1, individual2, individual3])
        
        // Observations for session 1
        var observation1 = Observation(session: session1, individual: individual1, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        observation1.changeCreator(user1)
        var observation2 = Observation(session: session1, individual: individual1, state: state2, timestamp: NSDate(), information: "")
        observation2.changeCreator(user1)
        var observation3 = Observation(session: session1, individual: individual1, state: state3, timestamp: NSDate(), information: "")
        observation3.changeCreator(user1)
        var observation4 = Observation(session: session1, individual: individual2, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        observation4.changeCreator(user2)
        var observation5 = Observation(session: session1, individual: individual2, state: state2, timestamp: NSDate(), information: "")
        observation5.changeCreator(user2)
        var observation6 = Observation(session: session1, individual: individual2, state: state3, timestamp: NSDate(), information: "")
        observation6.changeCreator(user2)
        var observation7 = Observation(session: session1, individual: individual3, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        observation7.changeCreator(user3)
        var observation8 = Observation(session: session1, individual: individual3, state: state2, timestamp: NSDate(), information: "")
        observation8.changeCreator(user3)
        var observation9 = Observation(session: session1, individual: individual3, state: state3, timestamp: NSDate(), information: "")
        observation9.changeCreator(user3)
        
        // Observations for session 2
        var observation10 = Observation(session: session2, individual: individual1, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        observation10.changeCreator(user1)
        var observation11 = Observation(session: session2, individual: individual1, state: state2, timestamp: NSDate(), information: "")
        observation11.changeCreator(user1)
        var observation12 = Observation(session: session2, individual: individual2, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        observation12.changeCreator(user2)
        var observation13 = Observation(session: session2, individual: individual2, state: state2, timestamp: NSDate(), information: "")
        observation13.changeCreator(user2)
        var observation14 = Observation(session: session2, individual: individual3, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        observation14.changeCreator(user3)
        var observation15 = Observation(session: session2, individual: individual3, state: state2, timestamp: NSDate(), information: "")
        observation15.changeCreator(user3)
        
        
        // Observations for session 3
        var observation16 = Observation(session: session3, individual: individual1, state: state2, timestamp: NSDate(), information: "")
        observation16.changeCreator(user1)
        var observation17 = Observation(session: session3, individual: individual1, state: state3, timestamp: NSDate(), information: "")
        observation17.changeCreator(user1)
        var observation18 = Observation(session: session3, individual: individual2, state: state2, timestamp: NSDate(), information: "")
        observation18.changeCreator(user2)
        var observation19 = Observation(session: session3, individual: individual2, state: state3, timestamp: NSDate(), information: "")
        observation19.changeCreator(user2)
        
        var observation20 = Observation(session: session4, individual: individual2, state: state2, timestamp: NSDate(), information: "")
        observation20.changeCreator(user3)
        var observation21 = Observation(session: session4, individual: individual3, state: state3, timestamp: NSDate(), information: "")
        observation21.changeCreator(user3)
        
        session1.addObservation([observation1, observation2, observation3, observation4,
            observation5, observation6, observation7, observation8, observation9])
        session2.addObservation([observation10, observation11, observation12,
            observation13, observation14, observation15])
        session3.addObservation([observation16, observation17, observation18, observation19, observation20, observation21])
        session4.addObservation([observation20, observation21])
        
        project.addSessions([session1, session2, session3, session4])
        
        ProjectManager.sharedInstance.addProject(project)
        EthogramManager.sharedInstance.addEthogram(ethogram)
        
        ProjectManager.sharedInstance.saveToArchives()
        EthogramManager.sharedInstance.saveToArchives()
    }
    
    // Setup methods
    func setupSplitView() {
        setupMenu()
        
        masterNav.setViewControllers([menu], animated: true)
        
        splitVC.viewControllers = [masterNav, detailNav]
        splitVC.delegate = self
        
        self.view.addSubview(splitVC.view)
        splitVC.view.frame = self.view.frame
        
        self.addChildViewController(splitVC)
        splitVC.didMoveToParentViewController(self)
    }
    
    func setupMenu() {
        menu.title = "BioLifeTracker"
        menu.delegate = self
    }
    
    // Methods to show pages
    func showStartPage() {
        showProjectsPage()
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
        
        var createBtn = UIBarButtonItem(title: "Sync", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("syncProject"))
        vc.navigationItem.rightBarButtonItem = createBtn
        
        detailNav.pushViewController(vc, animated: true)
    }
    
    func showEthogramsPage() {
        for n in EthogramManager.sharedInstance.ethograms {
            println(n.name)
        }
        if Data.selectedEthogram != nil {
            println(Data.selectedEthogram!)
        }
        
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
        // Popup instead
        // selector to create new session
        // set currentSession here
        // then showSession
    }
    
    func showNewIndividualPage() {
        let vc = FormViewController(style: UITableViewStyle.Grouped)
        
        vc.title = "New Individual"
        vc.setFormData(getFormDataForNewIndividual())
        vc.cellHorizontalPadding = 10
        vc.roundedCells = true
        
        detailNav.pushViewController(vc, animated: true)
    }
    
    func showSession() {
        if currentSession != nil {
            if currentSession!.type == SessionType.Focal {
                showFocalSessionPage(currentSession!)
            } else {
                showScanSessionPage(currentSession!)
            }
        }
    }
    
    func showFocalSessionPage(session: Session) {
        let vc = FocalSessionViewController(nibName: "FocalSessionView", bundle: nil)
        
        vc.delegate = self
        vc.title = session.name
        vc.currentSession = session
        
        var createBtn = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("showCreateObservationPage"))
        vc.navigationItem.rightBarButtonItem = createBtn
        
        detailNav.pushViewController(vc, animated: true)
    }
    
    func showScanSessionPage(session: Session) {
        let vc = ScanSessionViewController()
        
        vc.delegate = self
        vc.title = session.name
        vc.currentSession = session
        
        var createBtn = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("showCreateScanPage"))
        vc.navigationItem.rightBarButtonItem = createBtn
        
        detailNav.pushViewController(vc, animated: true)
    }
    
    func showCreateObservationPage() {
        // Observation Form VC
    }
    
    func showCreateScanPage() {
        // Scan View
    }
    
    func clearNavigationStack() {
        detailNav.popToRootViewControllerAnimated(false)
    }
    
    // Methods for creating form data
    func getFormDataForNewProject() -> FormFieldData {
        var ethogramNames = [String]()
        for e in EthogramManager.sharedInstance.ethograms {
            ethogramNames.append(e.name)
        }
        
        let data = FormFieldData(sections: 2)
        data.addTextCell(section: 0, label: "Name", hasSingleLine: true)
        data.addPickerCell(section: 0, label: "Ethogram", pickerValues: ethogramNames, isCustomPicker: true)
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
    
    // Selectors for navigation bar items
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
    
    func syncProject() {
        let project = currentProject!
        
        // Set up alert controller
        let alertTitle = "Sync In Progress"
        let alertMessage = "Starting sync..."
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        // Set up cloud storage worker
        let worker = CloudStorageWorker()
        let uploadTask = UploadTask(item: project)
        worker.enqueueTask(uploadTask)
        worker.setOnProgressUpdate { percentage, message in
            // Update popup here
            alert.message = "\(message) [\(percentage)%]"
        }
        
        // worker.setOnFailure { dismiss alert and open new alert with ok button
        //}
        
        worker.setOnFinished {
            // Dismiss popup here
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        
        //presentViewController(alert, animated: true, completion: nil)
        //worker.startExecution()
    }
    
    // MenuViewDelegate methods
    func userDidSelectProjects() {
        showProjectsPage()
    }
    
    func userDidSelectEthograms() {
        showEthogramsPage()
    }
    
    func userDidSelectAnalysis() {
        
    }
    
    func userDidSelectSettings() {
        
    }
    
    func userDidSelectLogout() {
        UserAuthService.sharedInstance.handleLogOut()
        ProjectManager.sharedInstance.handleLogOut()
        EthogramManager.sharedInstance.handleLogOut()
        
        // Move back to start page
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func userDidSelectSessions(project: Project) {
        
    }
    
    func userDidSelectIndividuals(project: Project) {
        
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
        currentSession = session
        showSession()
    }
    
    func userDidSelectMember(project: Project, member: User) {
        
    }
    
    func userDidSelectGraph(project: Project) {
        // Show analysis with the particular project
    }
    
    func userDidSelectCreateSession() {
        // Popup options: name, type
        // After popup -> create then show the type of session
    }
    
    func userDidSelectEditMembers() {
        
    }
    
    // ScanSessionViewControllerDelegate methods
    func userDidSelectScan(session: Session, timestamp: NSDate) {
        // Open the ScanView
    }
    
    // FocalSessionViewControllerDelegate methods
    func userDidSelectObservation(session: Session, observation: Observation) {
        // Open the Observation View
    }
}
