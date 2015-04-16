//
//  GraphAnalysisViewController.swift
//  BioLifeTracker
//
//  Created by Haritha on 16/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import UIKit

class GraphAnalysisViewController:  UIViewController {
    
    //var graphsview
    
    @IBOutlet weak var graphsView: UIView!
    @IBOutlet weak var graphSwitch: UISegmentedControl!
    
    //@IBOutlet weak var hostingView: CPTGraphHostingView!
    
    var projectInstance: Project!
    
    var graph: CPTXYGraph!
    var graphLineWidth: CGFloat = 2.5
    
    var plotByDay = false
    var plotByHour = false // default setting
    var chartByState = true
    
    var yMaxHours = 0
    var yMaxDays = 0
    var yMaxStates = 0
    
    var allBehaviourStates: [BehaviourState]!
    var chosenBehaviourStates: [BehaviourState]!
    
    var chosenUsers: [User]!
    var allUsers: [User]!
    
    var chosenSessions: [Session]!
    var allSessions: [Session]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        showGraphsView();
        var stub = ProjectStub()
        projectInstance = stub.project
        initConditions()
        

    }
    
    func showGraphsView() {
        let graphs = GraphsViewController(nibName: "GraphsView", bundle: nil)
        self.addChildViewController(graphs)
        graphs.view.frame = self.graphsView.frame
        graphsView.addSubview(graphs.view)
    }
    
    /********************* SET INITIAL DATA **********************/
    //Gets the data that conform to what the user provided and
    //sets them as conditions for the the graph
    func initConditions() {
        getAllUsers()
        getAllSessions()
        getAllBehaviourStates()
        
    }
    
    func updateUsers(chosen: [User]) {
        chosenUsers = chosen
    }
    
    func updateSessions(chosen: [Session]) {
        chosenSessions = chosen
    }
    
    func updateBehaviourStates(chosen: [BehaviourState]) {
        chosenBehaviourStates = chosen
        
    }
    
    func getAllUsers() {
        allUsers = projectInstance.members
        chosenUsers = allUsers
    }
    
    func getAllSessions() {
        allSessions = projectInstance.sessions
        chosenSessions = allSessions
    }
    
    func getAllBehaviourStates() {
        allBehaviourStates = projectInstance.ethogram.behaviourStates
        chosenBehaviourStates = allBehaviourStates
    }
    
    
    @IBAction func graphIndexChanged(sender: AnyObject) {
        switch graphSwitch.selectedSegmentIndex {
        case 0:
            println("hour")
        case 1:
            println("day")
        case 2:
            println("states")
            // only view behaviourstate tables
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



