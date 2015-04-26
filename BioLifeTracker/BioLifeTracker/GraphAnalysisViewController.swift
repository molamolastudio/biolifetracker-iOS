//
//  GraphAnalysisViewController.swift
//  BioLifeTracker
//
//  Created by Haritha on 16/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import UIKit

/// View Controller for the main Analysis Page.
/// Displays graph view and buttons for users to choose which graph they want to see.
/// Select between from which Users, Sessions or Behaviour States, do you want to see
/// number of observation.

class GraphAnalysisViewController:  UIViewController, UIPopoverPresentationControllerDelegate, GraphsViewControllerDelegate {
    
    @IBOutlet weak var graphsView: UIView!
    @IBOutlet weak var graphSwitch: UISegmentedControl!

    @IBOutlet weak var sessionLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var sessionButton: UIButton!
    @IBOutlet weak var statesButton: UIButton!
    var graphsVC: GraphsViewController!
    
    private var currentProject: Project!
    
    var AliceBlue = UIColor(red: 228.0/255.0, green: 241.0/255.0, blue: 254.0/255.0, alpha: 1)
    var HummingBird = UIColor(red: 197.0/255.0, green: 239.0/255.0, blue: 247.0/255.0, alpha: 1)
    
    override func loadView() {
        self.view = NSBundle.mainBundle().loadNibNamed("GraphAnalysisView", owner: self, options: nil).first as! UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if currentProject == nil {
            showSelectProjectView()
        } else {
            showGraphsView();
        }
    }
    
    
    func setProject(project: Project) {
        currentProject = project
    }
    
    /// Set up graph with selected project to display
    func showGraphsView() {
        graphsVC = GraphsViewController()
        graphsVC.setProject(currentProject)
        graphsVC.toggleGraph(.HourPlot)
        graphsVC.view.frame = CGRectMake(0, 0, graphsView.frame.width, graphsView.frame.height)
        graphsView.addSubview(graphsVC.view)
    }
    
    /// If project is not selected, show a table of current projects for user to choose
    func showSelectProjectView() {
        var projectVC = AnalysisProjectViewController()
        projectVC.delegate = self
        projectVC.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        self.presentViewController(projectVC, animated: false, completion: nil)
    }
    
    func hideSelectProjectView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// Toggle between different types of graphs
    @IBAction func graphIndexChanged(sender: AnyObject) {
        switch graphSwitch.selectedSegmentIndex {
        case 0:
            graphsVC.toggleGraph(.HourPlot)
            showUsersAndSessions()
        case 1:
            graphsVC.toggleGraph(.DayPlot)
            showUsersAndSessions()
        case 2:
            graphsVC.toggleGraph(.StateChart)
            hideUsersAndSessions()
        default:
            break
        }
        
        graphsVC.updateGraph()
    }
    
    /// Show user and session buttons
    func showUsersAndSessions() {
        userButton.hidden = false
        sessionButton.hidden = false
        userLabel.hidden = false
        sessionLabel.hidden = false
    }
    
    /// Hide user and session buttons
    func hideUsersAndSessions() {
        userButton.hidden = true
        sessionButton.hidden = true
        userLabel.hidden = true
        sessionLabel.hidden = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Show popup table of users/sessions/behaviour states to choose to
    /// be added to the graph analysis. Automatic update of graph when selection
    /// is made.
    @IBAction func buttonIsPressed(sender: UIButton) {
        
        var popoverContent = AnalysisTableViewController()
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.Popover
        var popover = popoverContent.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(300,500)
        popover!.delegate = self
        
        var anchorPoint  = sender.frame.origin
        
        var popoverAnchor = CGRectMake(anchorPoint.x, anchorPoint.y, 0, 0)
        popover!.sourceView = self.view
        popover!.sourceRect = popoverAnchor
        popover!.permittedArrowDirections = UIPopoverArrowDirection.Down
        
        switch sender {
            
        case userButton:
            popoverContent.setHeaderTitle("Users")
            popoverContent.toggleTable(.Users)
            popoverContent.initUsers(graphsVC.getAllUsers(), chosen: graphsVC.getChosenUsers())
        case sessionButton:
            popoverContent.setHeaderTitle("Sessions")
            popoverContent.toggleTable(.Sessions)
            
            if graphsVC.getAllSessions().count == 0 {
                popoverContent.initEmpty()
            } else {
                popoverContent.initSessions(graphsVC.getAllSessions(), chosen: graphsVC.getChosenSessions())
            }
        case statesButton:
            popoverContent.setHeaderTitle("Behaviour States")
            popoverContent.toggleTable(.States)
            popoverContent.initStates(graphsVC.getAllBehaviourStates(), chosen: graphsVC.getChosenBehaviourStates())
        default:
            break
        }
        popoverContent.delegate = self
        
        self.presentViewController(popoverContent, animated: true, completion: nil)
            
    }

    // DELEGATE METHODS
    
    func didAddUser(user: User) {
        var chosen = graphsVC.getChosenUsers()
        chosen.append(user)
        graphsVC.updateUsers(chosen)
        graphsVC.updateGraph()
    }
    
    func didRemoveUser(user: User) {
        var chosen = graphsVC.getChosenUsers()
        var i = find(chosen, user)
        chosen.removeAtIndex(i!)
        graphsVC.updateUsers(chosen)
        graphsVC.updateGraph()
    }
    
    func didAddSession(session: Session) {
        var chosen = graphsVC.getChosenSessions()
        chosen.append(session)
        graphsVC.updateSessions(chosen)
        graphsVC.updateGraph()
    }
    
    func didRemoveSession(session: Session) {
        var chosen = graphsVC.getChosenSessions()
        var i = find(chosen, session)
        chosen.removeAtIndex(i!)
        graphsVC.updateSessions(chosen)
        graphsVC.updateGraph()
    }
    
    func didAddState(state: BehaviourState) {
        var chosen = graphsVC.getChosenBehaviourStates()
        chosen.append(state)
        graphsVC.updateBehaviourStates(chosen)
        graphsVC.updateGraph()
    }
    
    func didRemoveState(state: BehaviourState) {
        var chosen = graphsVC.getChosenBehaviourStates()
        var i = find(chosen, state)
        chosen.removeAtIndex(i!)
        graphsVC.updateBehaviourStates(chosen)
        graphsVC.updateGraph()
    }
    
    func userDidSelectProject(project: Project) {
        setProject(project)
        hideSelectProjectView()
        showGraphsView()
    }
    
}



