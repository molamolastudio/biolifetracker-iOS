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

class SuperController: UIViewController, UISplitViewControllerDelegate, MenuViewControllerDelegate,ProjectsViewControllerDelegate, EthogramsViewControllerDelegate, ProjectHomeViewControllerDelegate, ScanSessionViewControllerDelegate {
    
    let splitVC = UISplitViewController()
    let masterNav = UINavigationController()
    let detailNav = UINavigationController()
    
    let menu = MenuViewController(style: UITableViewStyle.Grouped)
    
    let popup = CustomPickerPopup()
    
    var currentProject: Project? = nil
    var currentSession: Session? = nil
    
    var loadingAlert: UIAlertController?
    var freshLogin = false
    
    override func viewDidLoad() {
        setupSplitView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let userAuth = UserAuthService.sharedInstance
        if !userAuth.hasAccessToken() { // user has not logged in
            showLoginPage()
            return
        }
        
        // User has logged in
        menu.title = userAuth.user.name
        showProjectsPage()
        if freshLogin {
            loadingAlert = UIAlertController(title: "Loading Data", message: "Downloading your projects from server", preferredStyle: .Alert)
            self.presentViewController(loadingAlert!, animated: true, completion: nil)
            startDownloadingProjectsFromServer()
            freshLogin = false
        } else {
            refreshUserList()
        }
        
        if UserAuthService.sharedInstance.user.email != "Default" {
            setupForDemo()
        }
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
    }
    
    func setupMenu() {
        menu.title = UserAuthService.sharedInstance.user.name
        menu.delegate = self
    }
    
    func showCorruptFileAlert() {
        displayAlert("Save File Corrupt", message: "Unable to load save file.")
    }
    
    // Methods to show pages
    
    func showLoginPage() {
        freshLogin = true
        let vc = FirstViewController(nibName: "FirstView", bundle: nil)
        vc.modalPresentationStyle = .FullScreen
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func showNewProjectPage() {
        // If there are ethograms saved, present the new project page
        if !EthogramManager.sharedInstance.ethograms.isEmpty {
            let vc = ProjectFormViewController(nibName: "ProjectFormView", bundle: nil)
            
            vc.title = "New Project"
            
            var btn = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("createNewProject"))
            vc.navigationItem.rightBarButtonItem = btn
            
            detailNav.pushViewController(vc, animated: true)
        } else {
            // If there are no ethograms saved, display an alert
            displayAlert("No Ethograms Saved", message: "Please create an ethogram before creating a project.")
        }
    }
    
    func showProjectsPage() {
        let vc = ProjectsViewController(style: UITableViewStyle.Grouped)
        
        vc.delegate = self
        vc.title = "Projects"
        
        var btn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("showNewProjectPage"))
        vc.navigationItem.rightBarButtonItem = btn
        
        detailNav.setViewControllers([vc], animated: false)
    }
    
    func showProjectHomePage() {
        let vc = ProjectHomeViewController(nibName: "ProjectHomeView", bundle: nil)
        
        vc.delegate = self
        vc.title = currentProject!.name
        vc.currentProject = currentProject!
        
        var exportBtn = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: Selector("exportToExcel:"))
        var syncBtn = UIBarButtonItem(title: "Sync", style: .Plain, target: self, action: Selector("syncProject"))
        vc.navigationItem.rightBarButtonItems = [exportBtn, syncBtn]
        
        detailNav.pushViewController(vc, animated: true)
    }
    
    func showEthogramsPage() {
        let vc = EthogramsViewController(style: UITableViewStyle.Grouped)
        
        vc.delegate = self
        vc.title = "Ethograms"
        
        var btn = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("showNewEthogramPage"))
        vc.navigationItem.rightBarButtonItem = btn
        
        detailNav.setViewControllers([vc], animated: false)
    }
    
    func showNewEthogramPage() {
        let vc = EthogramFormViewController()
        
        vc.title = "Create New Ethogram"
        
        var btn = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("createNewEthogram"))
        vc.navigationItem.rightBarButtonItem = btn
        
        detailNav.pushViewController(vc, animated: true)
    }
    
    func showEthogramDetailsPage() {
        let vc = EthogramDetailsViewController()
        
        vc.title = Data.selectedEthogram!.name
        vc.ethogram = Data.selectedEthogram!
        
        vc.editable = false
        
        // If user created the object
        if Data.selectedEthogram!.createdBy.name == UserAuthService.sharedInstance.user.name {
            var btn = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: Selector("updateEditButtonForEthogram"))
            vc.navigationItem.rightBarButtonItem = btn
        }
        
        detailNav.pushViewController(vc, animated: true)
    }
    
    func dismissCurrentPage() {
        // Do not allow dismissal if only one view controller is left.
        if detailNav.viewControllers.count > 1 {
            detailNav.popViewControllerAnimated(true)
        }
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
        vc.cellHorizontalPadding = 25
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
        
        vc.title = session.name
        vc.currentSession = session
        vc.editable = false
        
        // If user created the object
        if session.createdBy.name == UserAuthService.sharedInstance.user.name {
            var btn = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: Selector("updateEditButtonForFocalSession"))
            vc.navigationItem.rightBarButtonItem = btn
        }
        
        detailNav.pushViewController(vc, animated: true)
    }
    
    func showScanSessionPage(session: Session) {
        let vc = ScanSessionViewController()
        
        vc.delegate = self
        vc.title = session.name
        vc.currentSession = session
        
        var btn = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("showCreateScanPagePopup"))
        vc.navigationItem.rightBarButtonItem = btn
        
        detailNav.pushViewController(vc, animated: true)
    }
    
    func showScanPage(session: Session, timestamp: NSDate) {
        let vc = ScanViewController(nibName: "ScanView", bundle: nil)
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        
        vc.title = formatter.stringFromDate(timestamp)
        vc.setData(session, timestamp: timestamp)
        vc.editable = false
        
        // If user created the object
        if session.createdBy == UserAuthService.sharedInstance.user {
            var btn = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: Selector("updateEditButtonForScan"))
            vc.navigationItem.rightBarButtonItem = btn
        }
        
        detailNav.pushViewController(vc, animated: true)
    }
    
    func showCreateScanPagePopup() {
        // Popup settings page
        // If all fields entered then showCreateScanPage
    }
    
    func showCreateScanPage() {
        let vc = ScanViewController(nibName: "ScanView", bundle: nil)
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        
        vc.title = "New Scan"
        vc.editable = true
        
        var btn = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("updateEditButtonForScan"))
        vc.navigationItem.rightBarButtonItem = btn
        
        detailNav.pushViewController(vc, animated: true)
    }
    
    func showAnalysisPage() {
        if !ProjectManager.sharedInstance.projects.isEmpty {
            let vc = GraphAnalysisViewController(nibName: "GraphAnalysisView", bundle: nil)
            
            vc.title = "Analyse"
            
            detailNav.setViewControllers([vc], animated: false)
        } else {
            // If there are no projects saved, display alert
            displayAlert("No Projects To Analyse", message: "")
        }
    }
    
    func showAnalysisPageWithProject(project: Project) {
        let vc = GraphAnalysisViewController(nibName: "GraphAnalysisView", bundle: nil)
        
        vc.title = "Analyse"
        vc.setProject(project)
        
        detailNav.setViewControllers([vc], animated: false)
    }
    
    func showSettingsPage() {
        let vc = FormViewController(style: UITableViewStyle.Grouped)
        
        vc.title = "Settings"
        vc.setFormData(getFormDataForSettings())
        vc.cellHorizontalPadding = 25
        vc.roundedCells = true
        
        detailNav.setViewControllers([vc], animated: false)
    }
    
    func clearNavigationStack() {
        detailNav.popToRootViewControllerAnimated(false)
    }
    
    // Methods for creating form data
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
    
    func getFormDataForSettings() -> FormFieldData {
        let data = FormFieldData(sections: 1)
        
        // ANDHIEKA
        
        return data
    }
    
    // Selectors for navigation bar items
    // Methods to create new model objects
    func createNewProject() {
        if let vc = detailNav.visibleViewController as? ProjectFormViewController {
            let project = vc.getProject()
            if project != nil {
                ProjectManager.sharedInstance.addProject(project!)
                showProjectsPage()
            } else {
                // Show an alert to user
                displayAlert("Incomplete Project", message: "Please enter a project name and select an ethogram.")
            }
        }
    }
    
    func createNewEthogram() {
        if let vc = detailNav.visibleViewController as? EthogramFormViewController {
            if let ethogram = vc.getEthogram() {
                EthogramManager.sharedInstance.addEthogram(vc.ethogram)
                dismissCurrentPage()
            }
        }
    }
    
    // Methods to toggle between save and edit states
    func updateEditButtonForEthogram() {
        if let vc = detailNav.visibleViewController as? EthogramDetailsViewController {
            vc.makeEditable(true)
            var btn = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: Selector("saveEthogramData"))
            vc.navigationItem.rightBarButtonItem = btn
        }
    }
    
    func updateEditButtonForScan() {
        if let vc = detailNav.visibleViewController as? ScanViewController {
            vc.makeEditable(true)
            var btn = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: Selector("saveScanData"))
            vc.navigationItem.rightBarButtonItem = btn
        }
    }
    
    func updateEditButtonForFocalSession() {
        if let vc = detailNav.visibleViewController as? FocalSessionViewController {
            vc.makeEditable(true)
            var btn = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: Selector("saveFocalSessionData"))
            vc.navigationItem.rightBarButtonItem = btn
        }
    }
    
    func saveEthogramData() {
        if let vc = detailNav.visibleViewController as? EthogramDetailsViewController {
            vc.saveData()
            dismissCurrentPage()
            vc.makeEditable(false)
            var btn = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: Selector("updateEditButtonForEthogram"))
            vc.navigationItem.rightBarButtonItem = btn
        }
    }
    
    func saveScanData() {
        if let vc = detailNav.visibleViewController as? ScanViewController {
            vc.saveData()
            vc.makeEditable(false)
            var btn = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: Selector("updateEditButtonForScan"))
            vc.navigationItem.rightBarButtonItem = btn
        }
    }
    
    func saveFocalSessionData() {
        if let vc = detailNav.visibleViewController as? FocalSessionViewController {
            vc.saveData()
            vc.makeEditable(false)
            var btn = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: Selector("updateEditButtonForFocalSession"))
            vc.navigationItem.rightBarButtonItem = btn
        }
    }
    
    func syncProject() {
        let project = currentProject!
        
        // Set up alert controller
        let alertTitle = "Sync In Progress"
        let alertMessage = "Uploading your project..."
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert, animated: true, completion: nil)

        let uploadTask = UploadTask(item: project)
        dispatch_async(CloudStorage.networkThread, {
            uploadTask.execute()
            dispatch_async(dispatch_get_main_queue(), {
                alert.dismissViewControllerAnimated(true, completion: {
                    if (uploadTask.completedSuccessfully != true) {
                        self.displayAlert("Fail to Upload", message: "Cannot connect to server")
                    }
                })
            })
        })
        
    }
    
    func exportToExcel(sender: UIBarButtonItem) {
        if let project = currentProject {
            let exportService = ExportObservationsService(project: project)
            exportService.openInOtherApps(sender)
        }
    }
    
    // MenuViewDelegate methods
    func userDidSelectProjects() {
        dismissMenuView()
        showProjectsPage()
    }
    
    func userDidSelectEthograms() {
        dismissMenuView()
        showEthogramsPage()
    }
    
    func userDidSelectAnalysis() {
        dismissMenuView()
        showAnalysisPage()
    }
    
    func userDidSelectSettings() {
        dismissMenuView()
        showSettingsPage()
    }
    
    func userDidSelectLogout() {
        // Log out ProjectManager and EthogramManager first before logging user out
        // Requires the user info to clear directories
        ProjectManager.sharedInstance.handleLogOut()
        EthogramManager.sharedInstance.handleLogOut()
        
        GPPSignIn.sharedInstance().signOut()
        FBSession.activeSession().closeAndClearTokenInformation()
        
        UserAuthService.sharedInstance.handleLogOut()
        CloudStorageManager.sharedInstance.clearCache()
        
        // Move back to start page
        dismissMenuView()
        showLoginPage()
        
        assert(ProjectManager.sharedInstance.projects.count == 0)
    }
    
    func userDidSelectSessions(project: Project) {
        dismissMenuView()
    }
    
    func userDidSelectIndividuals(project: Project) {
        dismissMenuView()
    }
    
    // ProjectsViewControllerDelegate methods
    func userDidSelectProject(selectedProject: Project) {
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
        showAnalysisPageWithProject(project)
    }
    
    func userDidSelectCreateSession() {
        let alert = UIAlertController(title: "New Individual", message: "", preferredStyle: .Alert)
        
        // Adds buttons
        let actionCancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let actionOk = UIAlertAction(title: "OK", style: .Default, handler: {action in
            let textField = alert.textFields!.first as! UITextField
            
        })
        actionOk.enabled = false
        alert.addAction(actionOk)
        alert.addAction(actionCancel)
        
        // Adds a text field for the label
        alert.addTextFieldWithConfigurationHandler({textField in
            textField.placeholder = "Label (eg: M1, F1)"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                actionOk.enabled = textField.text != ""
            }
        })
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func userDidSelectEditMembers() {
        
    }
    
    // ScanSessionViewControllerDelegate methods
    func userDidSelectScan(session: Session, timestamp: NSDate) {
        // Open the ScanView
        showScanPage(session, timestamp: timestamp)
    }
    
    // Helper methods
    
    // Displays an alert controller with given title and message, with an OK button.
    // Dismisses upon pressing the OK button.
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let actionOk = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(actionOk)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func refreshUserList() {
        let worker = CloudStorageWorker()
        let downloadUser = DownloadTask(classUrl: User.ClassUrl)
        worker.enqueueTask(downloadUser)
        worker.setOnFinished {
            if downloadUser.completedSuccessfully == true {
                UserManager.sharedInstance.clearUsers()
                for userInfo in downloadUser.getResults() {
                    let user = User(dictionary: userInfo)
                    UserManager.sharedInstance.addUser(user)
                }
                UserManager.sharedInstance.saveUsersToDisk()
            }
        }
        worker.startExecution()
    }
    
    
    func startDownloadingProjectsFromServer() {
        let worker = CloudStorageWorker()
        
        // downloading items one by one is too slow, we have to warm cache
        // by downloading in batches first
        let downloadUser = DownloadTask(classUrl: User.ClassUrl)
        let downloadLocation = DownloadTask(classUrl: Location.ClassUrl)
        let downloadWeather = DownloadTask(classUrl: Weather.ClassUrl)
        let downloadTag = DownloadTask(classUrl: Tag.ClassUrl)
        let downloadIndividual = DownloadTask(classUrl: Individual.ClassUrl)
        let downloadObservation = DownloadTask(classUrl: Observation.ClassUrl)
        let downloadSession = DownloadTask(classUrl: Session.ClassUrl)
        let downloadBehaviourState = DownloadTask(classUrl: BehaviourState.ClassUrl)
        let downloadEthogram = DownloadTask(classUrl: Ethogram.ClassUrl)
        let downloadProject = DownloadTask(classUrl: Project.ClassUrl)
        let tasks = [
            downloadUser,
            downloadLocation,
            downloadWeather,
            downloadTag,
            downloadIndividual,
            downloadObservation,
            downloadSession,
            downloadBehaviourState,
            downloadEthogram,
            downloadProject
        ]
        tasks.map { worker.enqueueTask($0) }
        
        let manager = CloudStorageManager.sharedInstance
        worker.setOnFinished {
            // put all info into cache
            for userInfo in downloadUser.getResults() {
                manager.putIntoCache(User.ClassUrl, itemInfo: userInfo)
            }
            for locationInfo in downloadLocation.getResults() {
                manager.putIntoCache(Location.ClassUrl, itemInfo: locationInfo)
            }
            for weatherInfo in downloadWeather.getResults() {
                manager.putIntoCache(Weather.ClassUrl, itemInfo: weatherInfo)
            }
            for tagInfo in downloadTag.getResults() {
                manager.putIntoCache(Tag.ClassUrl, itemInfo: tagInfo)
            }
            for individualInfo in downloadIndividual.getResults() {
                manager.putIntoCache(Individual.ClassUrl, itemInfo: individualInfo)
            }
            for observationInfo in downloadObservation.getResults() {
                manager.putIntoCache(Observation.ClassUrl, itemInfo: observationInfo)
            }
            for sessionInfo in downloadSession.getResults() {
                manager.putIntoCache(Session.ClassUrl, itemInfo: sessionInfo)
            }
            for behaviourInfo in downloadBehaviourState.getResults() {
                manager.putIntoCache(BehaviourState.ClassUrl, itemInfo: behaviourInfo)
            }
            for ethogramInfo in downloadEthogram.getResults() {
                manager.putIntoCache(Ethogram.ClassUrl, itemInfo: ethogramInfo)
            }
            for projectInfo in downloadProject.getResults() {
                manager.putIntoCache(Project.ClassUrl, itemInfo: projectInfo)
            }
            
            // add users to UserManager
            UserManager.sharedInstance.clearUsers()
            for userInfo in downloadUser.getResults() {
                let user = User(dictionary: userInfo)
                UserManager.sharedInstance.addUser(user)
            }
            UserManager.sharedInstance.saveUsersToDisk()
            
            // add projects to ProjectManager
            for projectInfo in downloadProject.getResults() {
                let project = Project(dictionary: projectInfo)
                ProjectManager.sharedInstance.addProject(project)
            }
            
            // add ethograms to EthogramManager
            for ethogramInfo in downloadEthogram.getResults() {
                let ethogram = Ethogram(dictionary: ethogramInfo)
                EthogramManager.sharedInstance.addEthogram(ethogram)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.loadingAlert?.dismissViewControllerAnimated(true, completion: nil)
                self.showProjectsPage()
            })
        }
        worker.setOnProgressUpdate { percentage, message in
            dispatch_async(dispatch_get_main_queue(), {
                self.loadingAlert?.message = message
                
            })
        }
        worker.startExecution()
    }
}
