//
//  GraphAnalysisViewController.swift
//  BioLifeTracker
//
//  Created by Haritha on 16/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import UIKit

class GraphAnalysisViewController:  UIViewController, UIPopoverPresentationControllerDelegate, GraphsViewControllerDelegate {
    
    @IBOutlet weak var graphsView: UIView!
    @IBOutlet weak var graphSwitch: UISegmentedControl!

    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var sessionButton: UIButton!
    @IBOutlet weak var statesButton: UIButton!
    @IBOutlet weak var background: UIView!
    var graphsVC: GraphsViewController!
    
    private var currentProject: Project!
    
    var AliceBlue = UIColor(red: 228.0/255.0, green: 241.0/255.0, blue: 254.0/255.0, alpha: 1)
    var HummingBird = UIColor(red: 197.0/255.0, green: 239.0/255.0, blue: 247.0/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.background.backgroundColor = UIColor.whiteColor()
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.sendSubviewToBack(self.background)
        
        //DEVELOPER TEST PROJECT
        var stub = ProjectStub()
        setProject(stub.project)
//        setProjectIstub.empty)

        if currentProject == nil {
            showSelectProjectView()
        } else {
            showGraphsView();
        }
    
    }
    func setProject(project: Project) {
        currentProject = project
    }
    
    func showGraphsView() {
        graphsVC = GraphsViewController(nibName: "GraphsView", bundle: nil)
        graphsVC.setProject(currentProject)
        graphsVC.toggleGraph(.HourPlot)
        graphsVC.view.frame = CGRectMake(0, 0, graphsView.frame.width, graphsView.frame.height)
        graphsView.addSubview(graphsVC.view)
    }
    
    func showSelectProjectView() {
        var projectVC = AnalysisProjectViewController()
        projectVC.delegate = self
        projectVC.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        self.presentViewController(projectVC, animated: false, completion: nil)
    }
    
    func hideSelectProjectView() {
        
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    @IBAction func graphIndexChanged(sender: AnyObject) {
        switch graphSwitch.selectedSegmentIndex {
        case 0:
            println("hour")
            graphsVC.toggleGraph(.HourPlot)
            userButton.hidden = false
            sessionButton.hidden = false
        case 1:
            println("day")
            graphsVC.toggleGraph(.DayPlot)
            userButton.hidden = false
            sessionButton.hidden = false
        case 2:
            println("states")
            graphsVC.toggleGraph(.StateChart)
            userButton.hidden = true
            sessionButton.hidden = true
            
        default:
            break
        }
        
        graphsVC.updateGraph()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonIsPressed(sender: UIButton) {

        var name = sender.titleLabel?.text
        
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
        
        if name == "Users" {
            popoverContent.setHeaderTitle(name!)
            popoverContent.toggleTable(.Users)
            popoverContent.initUsers(graphsVC.getAllUsers(), chosen: graphsVC.getChosenUsers())
        } else if name == "Sessions" {
            popoverContent.setHeaderTitle(name!)
            popoverContent.toggleTable(.Sessions)
            if graphsVC.getAllSessions().count == 0 {
                popoverContent.initEmpty()
            } else {
                popoverContent.initSessions(graphsVC.getAllSessions(), chosen: graphsVC.getChosenSessions())
            }
        } else if name == "Behaviour States" {
            popoverContent.setHeaderTitle(name!)
            popoverContent.toggleTable(.States)
            popoverContent.initStates(graphsVC.getAllBehaviourStates(), chosen: graphsVC.getChosenBehaviourStates())
        }
        popoverContent.delegate = self
        
        self.presentViewController(popoverContent, animated: true, completion: nil)
            
    }
    
    
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



