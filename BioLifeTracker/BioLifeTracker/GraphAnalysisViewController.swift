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
    
    @IBOutlet weak var graphsView: UIView!
    @IBOutlet weak var graphSwitch: UISegmentedControl!
    
    var graphsVC: GraphsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        showGraphsView();
        
        

    }
    
    func showGraphsView() {
        graphsVC = GraphsViewController(nibName: "GraphsView", bundle: nil)
        self.addChildViewController(graphsVC)
        var stub = ProjectStub()
        graphsVC.projectInstance = stub.project
        graphsVC.view.frame = self.graphsView.frame
        graphsView.addSubview(graphsVC.view)
    }
    
    @IBAction func graphIndexChanged(sender: AnyObject) {
        switch graphSwitch.selectedSegmentIndex {
        case 0:
            println("hour")
            graphsVC.toggleGraph(.HourPlot)
            graphsVC.prepareNumberOfOccurances()
            graphsVC.drawGraph()
        case 1:
            println("day")
            graphsVC.toggleGraph(.DayPlot)
            graphsVC.prepareNumberOfOccurances()
            graphsVC.drawGraph2()
        case 2:
            println("states")
            graphsVC.toggleGraph(.StateChart)
            graphsVC.prepareNumberOfOccurances()
            graphsVC.drawGraph()
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



