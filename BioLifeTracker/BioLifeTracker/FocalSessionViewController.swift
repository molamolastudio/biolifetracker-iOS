//
//  FocalSessionViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 14/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class FocalSessionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var delegate: FocalSessionViewControllerDelegate? = nil
    
    @IBOutlet weak var leftTableView: UITableView!
    @IBOutlet weak var rightTableView: UITableView!
    
    let cellReuseIdentifier = "SubtitleTableCell"
    let cellHeight: CGFloat = 50
    
    let numSections = 1
    
    let formatter = NSDateFormatter()
    
    var currentSession: Session? = nil
    var selectedIndividual = ""
    
    var individuals = [String]()
    // Maps the individual's label to a list of its observations in this session
    var individualObservations = [String: [Observation]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftTableView.registerNib(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        rightTableView.registerNib(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        
        // Setup the individuals array
        individuals.append("All")
        individualObservations["All"] = currentSession!.observations
        for i in currentSession!.project.individuals {
            individuals.append(i.label)
            individualObservations[i.label] = []//currentSession!.getObservationsByIndividual(i)
        }
    }
    
    // UITableViewDataSource and UITableViewDelegate METHODS
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! SubtitleTableCell
        if tableView == leftTableView {
            cell.title.text = individuals[indexPath.row]
            cell.subtitle.text = ""
        } else {
            let observation = individualObservations[selectedIndividual]![indexPath.row]
            
            cell.title.text = formatter.stringFromDate(observation.createdAt)
            cell.subtitle.text = observation.state.name
        }
        return cell
    }
    
    // Sets the selected row for the left table view, informs delegate of the selected observation 
    // for the left table view.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == leftTableView {
            selectedIndividual = individuals[indexPath.row]
            rightTableView.reloadData()
        } else {
            if delegate != nil {
                delegate!.userDidSelectObservation(currentSession!, observation: individualObservations[selectedIndividual]![indexPath.row])
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTableView {
            return individuals.count
        } else {
            if individualObservations[selectedIndividual] != nil {
                return individualObservations[selectedIndividual]!.count
            } else {
                return 0
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numSections
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
}

