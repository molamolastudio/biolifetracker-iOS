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
    
    @IBOutlet weak var background: UIView!
    var graphsVC: GraphsViewController!
    
    var AliceBlue = UIColor(red: 228.0/255.0, green: 241.0/255.0, blue: 254.0/255.0, alpha: 1)
    var HummingBird = UIColor(red: 197.0/255.0, green: 239.0/255.0, blue: 247.0/255.0, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.background.backgroundColor = AliceBlue
        self.view.backgroundColor = AliceBlue
        self.view.sendSubviewToBack(self.background)
        
        showGraphsView();
        
        

    }
    
    func showGraphsView() {
        graphsVC = GraphsViewController(nibName: "GraphsView", bundle: nil)
        //self.addChildViewController(graphsVC)
        var stub = ProjectStub()
        // set graph for now it's stub
        graphsVC.setProject(stub.project)
        graphsVC.toggleGraph(.HourPlot)
        graphsVC.view.frame = CGRectMake(0, 0, graphsView.frame.width, graphsView.frame.height)
        graphsView.addSubview(graphsVC.view)
    }
    
    @IBAction func graphIndexChanged(sender: AnyObject) {
        switch graphSwitch.selectedSegmentIndex {
        case 0:
            println("hour")
            graphsVC.toggleGraph(.HourPlot)
        case 1:
            println("day")
            graphsVC.toggleGraph(.DayPlot)
        case 2:
            println("states")
            graphsVC.toggleGraph(.StateChart)
        default:
            break
        }
        
        graphsVC.updateGraph()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



