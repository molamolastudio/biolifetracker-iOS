//
//  SuperController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 31/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//
//  This class controls all controllers of the application, and
//  performs the following functions:
//  - Controls the UISplitViewController of the app
//  - Controls the navigation stack of the detail view
//  - Handles touch events from the menu (master view) as a delegate
//  - Handles touch events from all other VCs as a delegate
//  - Handles touch events on the navigation bar of detail view
//  - Keeps track of the current opened project, session and ethogram
//  - Creates and saves edited model objects to the respective managers
//  - Presents alerts when required
//

import UIKit

class SuperController: UIViewController, UISplitViewControllerDelegate,
                       MenuViewControllerDelegate,ProjectsViewControllerDelegate,
                       EthogramsViewControllerDelegate, ProjectHomeViewControllerDelegate,
                       ScanSessionViewControllerDelegate {
    
    // Child view controllers
    let splitVC = UISplitViewController()
    let masterNav = UINavigationController()
    let detailNav = UINavigationController()
    
    let menu = MenuViewController(style: UITableViewStyle.Grouped)
    let popup = CustomPickerPopup()
    
    // Current model objects
    var currentProject: Project? = nil
    var currentProjectIndex: Int? = nil
    var currentSession: Session? = nil
    var currentSessionIndex: Int? = nil
    var selectedEthogram: Int? = nil
    
    var loadingAlert: UIAlertController?
    var freshLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSplitView()
    }
    
    /// Checks if the user has logged in when the view has appeared.
    /// Presents the projects page if the user is logged in.
    /// Else, presents the login page.
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let userAuth = UserAuthService.sharedInstance
        if userAuth.hasAccessToken() {
            // User has logged in
            menu.title = userAuth.user.name
            
            showProjectsPage()
            
            if freshLogin {
                freshLogin = false
            }
            startDownloadingProjectsFromServer()

        } else {
            showLoginPage()
        }
    }
    
    /// Closes the master view of the split view.
    func dismissMenuView() {
        let barButtonItem = splitVC.displayModeButtonItem()
        UIApplication.sharedApplication().sendAction(barButtonItem.action,
            to: barButtonItem.target, from: nil, forEvent: nil)
    }
    
    // MARK: VIEW SETUP METHODS
    
    func setupSplitView() {
        setupMenu()
        
        masterNav.setViewControllers([menu], animated: true)
        
        splitVC.maximumPrimaryColumnWidth = 200
        splitVC.viewControllers = [masterNav, detailNav]
        splitVC.delegate = self
        
        self.view.addSubview(splitVC.view)
        splitVC.view.frame = self.view.frame
    }
    
    func setupMenu() {
        menu.title = UserAuthService.sharedInstance.user.name
        menu.delegate = self
    }
    
    // MARK: METHODS TO SHOW/HIDE PAGES ON NAVIGATION STACK
    
    func dismissCurrentPage() {
        // Do not allow dismissal if only one view controller is left.
        if detailNav.viewControllers.count > 1 {
            detailNav.popViewControllerAnimated(true)
        }
    }
    
    func showLoginPage() {
        freshLogin = true
        let vc = FirstViewController()
        vc.modalPresentationStyle = .FullScreen
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func showNewProjectPage() {
        // If there are ethograms saved, present the new project page
        if !EthogramManager.sharedInstance.ethograms.isEmpty {
            let vc = ProjectFormViewController()
            
            vc.title = "New Project"
            
            // Sets the navigation bar button for this controller
            var btn = UIBarButtonItem(barButtonSystemItem: .Done, target: self,
                                      action: Selector("createNewProject"))
            vc.navigationItem.rightBarButtonItem = btn
            
            detailNav.pushViewController(vc, animated: true)
            
        } else {
            // If there are no ethograms saved, display an alert
            displayAlert("No Ethograms Saved",
                message: "Please create an ethogram before creating a project.")
        }
    }
    
    func showProjectsPage() {
        let vc = ProjectsViewController()
        
        vc.delegate = self
        vc.title = "Projects"
        
        // Sets the navigation bar button for this controller
        var btn = UIBarButtonItem(barButtonSystemItem: .Add, target: self,
                                  action: Selector("showNewProjectPage"))
        vc.navigationItem.rightBarButtonItem = btn
        
        detailNav.setViewControllers([vc], animated: false)
    }
    
    func showProjectHomePage() {
        let vc = ProjectHomeViewController()
        
        vc.delegate = self
        vc.title = currentProject!.name
        vc.currentProjectIndex = currentProjectIndex
        vc.currentProject = currentProject
        
        // Sets the navigation bar buttons for this controller
        var exportBtn = UIBarButtonItem(barButtonSystemItem: .Action, target: self,
                                        action: Selector("exportToExcel:"))
        var syncBtn = UIBarButtonItem(title: "Sync", style: .Plain, target: self,
                                      action: Selector("syncProject"))
        vc.navigationItem.rightBarButtonItems = [exportBtn, syncBtn]
        
        detailNav.pushViewController(vc, animated: true)
    }
    
    func showEthogramsPage() {
        let vc = EthogramsViewController()
        
        vc.delegate = self
        vc.title = "Ethograms"
        
        // Sets the navigation bar button for this controller
        var btn = UIBarButtonItem(barButtonSystemItem: .Add, target: self,
                                  action: Selector("showNewEthogramPage"))
        vc.navigationItem.rightBarButtonItem = btn
        
        detailNav.setViewControllers([vc], animated: false)
    }
    
    func showNewEthogramPage() {
        let vc = EthogramFormViewController()
        
        vc.title = "Create New Ethogram"
        
        // Sets the navigation bar button for this controller
        var btn = UIBarButtonItem(barButtonSystemItem: .Done, target: self,
                                  action: Selector("createNewEthogram"))
        vc.navigationItem.rightBarButtonItem = btn
        
        detailNav.pushViewController(vc, animated: true)
    }
    
    func showEthogramDetailsPage() {
        let vc = EthogramDetailsViewController()
        
        let ethogram = EthogramManager.sharedInstance.ethograms[selectedEthogram!]
        
        vc.title = ethogram.name
        vc.originalEthogram = ethogram
        
        vc.editable = false
        
        // If user created the object
        if ethogram.createdBy.name == UserAuthService.sharedInstance.user.name {
            // Sets the navigation bar button for this controller
            var btn = UIBarButtonItem(barButtonSystemItem: .Edit, target: self,
                                      action: Selector("updateEditButtonForEthogram"))
            vc.navigationItem.rightBarButtonItem = btn
        }
        
        detailNav.pushViewController(vc, animated: true)
    }
    
    // Shows the session page based on the type of the current session.
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
        let vc = FocalSessionViewController()
        
        vc.title = session.name
        vc.currentSession = session
        vc.editable = false
        
        // If user created the object
        if session.createdBy.name == UserAuthService.sharedInstance.user.name {
            // Sets the navigation bar button for this controller
            var btn = UIBarButtonItem(barButtonSystemItem: .Edit, target: self,
                                      action: Selector("updateEditButtonForFocalSession"))
            vc.navigationItem.rightBarButtonItem = btn
        }
        
        detailNav.pushViewController(vc, animated: true)
    }
    
    func showScanSessionPage(session: Session) {
        let vc = ScanSessionViewController()
        
        vc.delegate = self
        vc.title = session.name
        vc.currentSession = session
        
        // If user created the object
        if session.createdBy == UserAuthService.sharedInstance.user {
            // Sets the navigation bar button for this controller
            var btn = UIBarButtonItem(barButtonSystemItem: .Add, target: self,
                                      action: Selector("showCreateScanPage"))
            vc.navigationItem.rightBarButtonItem = btn
        }
        
        detailNav.pushViewController(vc, animated: true)
    }
    
    func showCreateScanPage() {
        let vc = ScanViewController()
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        
        vc.title = "New Scan"
        vc.editable = true
        vc.currentSession = currentSession!
        vc.selectedTimestamp = NSDate()
        
        // Sets the navigation bar button for this controller
        var btn = UIBarButtonItem(barButtonSystemItem: .Done, target: self,
                                  action: Selector("createNewScan"))
        vc.navigationItem.rightBarButtonItem = btn
        
        detailNav.pushViewController(vc, animated: true)
    }
    
    func showScanPage(session: Session, timestamp: NSDate) {
        let vc = ScanViewController()
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        
        vc.title = formatter.stringFromDate(timestamp)
        vc.setData(session, timestamp: timestamp)
        vc.editable = false
        
        // If user created the object
        if session.createdBy == UserAuthService.sharedInstance.user {
            // Sets the navigation bar button for this controller
            var btn = UIBarButtonItem(barButtonSystemItem: .Edit, target: self,
                                      action: Selector("updateEditButtonForScan"))
            vc.navigationItem.rightBarButtonItem = btn
        }
        
        detailNav.pushViewController(vc, animated: true)
    }
    
    func showAnalysisPage() {
        if !ProjectManager.sharedInstance.projects.isEmpty {
            let vc = GraphAnalysisViewController()
            
            vc.title = "Analyse"
            
            detailNav.setViewControllers([vc], animated: false)
        } else {
            // If there are no projects saved, display alert
            displayAlert("No Projects To Analyse", message: "")
        }
    }
    
    func showAnalysisPageWithProject(project: Project) {
        let vc = GraphAnalysisViewController()
        
        vc.title = "Analyse"
        vc.setProject(project)
        
        // Allow user to return to the selected project
        detailNav.pushViewController(vc, animated: true)
    }
    
    func clearNavigationStack() {
        detailNav.popToRootViewControllerAnimated(false)
    }
    
    // MARK: SELECTORS FOR NAVIGATION BAR BUTTONS
    
    func createNewProject() {
        if let vc = detailNav.visibleViewController as? ProjectFormViewController {
            let project = vc.getProject()
            if project != nil {
                ProjectManager.sharedInstance.addProject(project!)
                showProjectsPage()
            } else {
                // Show an alert to user
                displayAlert("Incomplete Project",
                    message: "Please enter a project name and select an ethogram.")
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
    
    func createNewScan() {
        if let vc = detailNav.visibleViewController as? ScanViewController {
            
            // If observations were taken, add them to the current session.
            if vc.observations.count > 0 {
                currentSession!.addObservation(vc.observations)
            }
            
            currentProject!.updateSession(currentSessionIndex!,
                                          updatedSession: currentSession!)
            ProjectManager.sharedInstance.updateProject(currentProjectIndex!,
                                                        project: currentProject!)
            
            dismissCurrentPage()
        }
    }
    
    // MARK: METHODS TO TOGGLE BETWEEN SAVE AND EDIT STATES
    
    func updateEditButtonForEthogram() {
        if let vc = detailNav.visibleViewController as? EthogramDetailsViewController {
            vc.makeEditable(true)
            var btn = UIBarButtonItem(barButtonSystemItem: .Save, target: self,
                                      action: Selector("saveEthogramData"))
            vc.navigationItem.rightBarButtonItem = btn
        }
    }
    
    func updateEditButtonForScan() {
        if let vc = detailNav.visibleViewController as? ScanViewController {
            vc.makeEditable(true)
            var btn = UIBarButtonItem(barButtonSystemItem: .Save, target: self,
                                      action: Selector("saveScanData"))
            vc.navigationItem.rightBarButtonItem = btn
        }
    }
    
    func updateEditButtonForFocalSession() {
        if let vc = detailNav.visibleViewController as? FocalSessionViewController {
            vc.makeEditable(true)
            var btn = UIBarButtonItem(barButtonSystemItem: .Save, target: self,
                                      action: Selector("saveFocalSessionData"))
            vc.navigationItem.rightBarButtonItem = btn
        }
    }
    
    func saveEthogramData() {
        if let vc = detailNav.visibleViewController as? EthogramDetailsViewController {
            if vc.saveData() {
                dismissCurrentPage()
                vc.makeEditable(false)
                
                EthogramManager.sharedInstance.updateEthogram(selectedEthogram!,
                                                              ethogram: vc.ethogram)
                
                var btn = UIBarButtonItem(barButtonSystemItem: .Edit, target: self,
                                          action: Selector("updateEditButtonForEthogram"))
                vc.navigationItem.rightBarButtonItem = btn
            }
        }
    }
    
    func saveScanData() {
        if let vc = detailNav.visibleViewController as? ScanViewController {
            
            vc.saveData()
            currentProject!.updateSession(currentSessionIndex!,
                                          updatedSession: vc.currentSession!)
            ProjectManager.sharedInstance.updateProject(currentProjectIndex!,
                                                        project: currentProject!)
            
            vc.makeEditable(false)
            
            var btn = UIBarButtonItem(barButtonSystemItem: .Edit, target: self,
                                      action: Selector("updateEditButtonForScan"))
            vc.navigationItem.rightBarButtonItem = btn
        }
    }
    
    func saveFocalSessionData() {
        if let vc = detailNav.visibleViewController as? FocalSessionViewController {
            
            vc.saveData()
            currentProject!.updateSession(currentSessionIndex!,
                                          updatedSession: vc.currentSession!)
            ProjectManager.sharedInstance.updateProject(currentProjectIndex!,
                                                        project: currentProject!)
            
            vc.makeEditable(false)
            
            var btn = UIBarButtonItem(barButtonSystemItem: .Edit, target: self,
                                      action: Selector("updateEditButtonForFocalSession"))
            vc.navigationItem.rightBarButtonItem = btn
        }
    }
    
    func syncProject() {
        let project = currentProject!
        
        // Set up alert controller
        let alertTitle = "Sync In Progress"
        let alertMessage = "Uploading your project..."
        let alert = UIAlertController(title: alertTitle, message: alertMessage,
                                      preferredStyle: .Alert)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        // Sets up a task to upload the given project
        let uploadTask = UploadTask(item: project)
        
        dispatch_async(CloudStorage.networkThread, {
            uploadTask.execute()
            dispatch_async(dispatch_get_main_queue(), {
                alert.dismissViewControllerAnimated(true, completion: {
                    if (uploadTask.completedSuccessfully != true) {
                        self.displayAlert("Fail to Upload",
                                          message: "Cannot connect to server")
                    } else {
                        self.startDownloadingProjectsFromServer()
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
    
    // MARK: MenuViewDelegate METHODS
    
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
    
    func userDidSelectLogout() {
        // Dismiss views first so that they can save edited data
        dismissMenuView()
        showLoginPage()
        
        // Log out ProjectManager and EthogramManager first before logging user out
        // Requires the user info to clear directories
        ProjectManager.sharedInstance.handleLogOut()
        EthogramManager.sharedInstance.handleLogOut()
        
        // Erase authentication info
        GPPSignIn.sharedInstance().signOut()
        FBSession.activeSession().closeAndClearTokenInformation()
        UserAuthService.sharedInstance.handleLogOut()
        
        // Erase cached cloud storage data
        CloudStorageManager.sharedInstance.clearCache()
        
        assert(ProjectManager.sharedInstance.projects.count == 0)
    }
    
    func userDidSelectSessions(project: Project) {
        dismissMenuView()
    }
    
    func userDidSelectIndividuals(project: Project) {
        dismissMenuView()
    }
    
    // MARK: ProjectsViewControllerDelegate METHODS
    
    func userDidSelectProject(selectedProject: Int) {
        currentProjectIndex = selectedProject
        currentProject = ProjectManager.sharedInstance.projects[selectedProject]
        showProjectHomePage()
    }
    
    // MARK: EthogramsViewControllerDelegate METHODS
    
    func userDidSelectEthogram(selectedEthogram: Int) {
        self.selectedEthogram = selectedEthogram
        showEthogramDetailsPage()
    }
    
    // MARK: ProjectHomeViewControllerDelegate METHODS
    
    func userDidSelectSession(project: Project, session: Int) {
        currentSessionIndex = session
        currentSession = project.sessions[session]
        showSession()
    }
    
    func userDidSelectGraph(project: Project) {
        showAnalysisPageWithProject(project)
    }
    
    func userDidLeaveProject() {
        if let vc = detailNav.visibleViewController as? ProjectHomeViewController {
            vc.dismissViewControllerAnimated(false, completion: nil)
        }
        showProjectsPage()
    }
    
    // MARK: ScanSessionViewControllerDelegate METHODS
    
    func userDidSelectScan(session: Session, timestamp: NSDate) {
        showScanPage(session, timestamp: timestamp)
    }
    
    // MARK: UIPopoverPresentationControllerDelegate METHODS
    
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle{
        return .None
    }
    
    // MARK: HELPER METHODS
    
    func showCorruptFileAlert() {
        displayAlert("Save File Corrupt", message: "Unable to load save file.")
    }
    
    /// Displays an alert controller with given title and message, with an OK button.
    /// Dismisses upon pressing the OK button.
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
        self.loadingAlert = UIAlertController(title: "Loading Data", message: "Downloading your projects from server", preferredStyle: .Alert)
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(self.loadingAlert!, animated: true, completion: nil)
        })
        
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
            dispatch_async(dispatch_get_main_queue(), {
                self.loadingAlert?.message = "Downloading photos..."
            })
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
                if let id = projectInfo["id"] as? Int {
                    if (id == self.currentProject?.id) ||
                        (!ProjectManager.sharedInstance.hasProjectWithId(id)) {
                            let project = Project(dictionary: projectInfo)
                            ProjectManager.sharedInstance.addProject(project)
                    }
                }
            }
            
            // add ethograms to EthogramManager
            for ethogramInfo in downloadEthogram.getResults() {
                let ethogram = Ethogram(dictionary: ethogramInfo)
                let ethogramManager = EthogramManager.sharedInstance
                if !ethogramManager.hasEthogramWithId(ethogram.id!) {
                    ethogramManager.addEthogram(ethogram)
                }
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
