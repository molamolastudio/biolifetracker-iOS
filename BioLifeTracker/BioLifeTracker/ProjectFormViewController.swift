//
//  ProjectFormViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class ProjectFormViewController: UITableViewController {

    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var textFieldAnimal: UITextField!
    @IBOutlet weak var labelEthogram: UILabel!

    @IBOutlet weak var btnCreateEthogram: UIButton!
    @IBOutlet weak var btnSelectEthogram: UIButton!
    

    let framePicker = CGRectMake(10, 150, 355, 200)
    
    let rowHeight: CGFloat = 44
    
    let messageNoEthograms = "You have no ethograms"
    let messageNoEthogramsSelected = "Select an ethogram"
    
    let segueToNewEthogram = "NewProjectToNewEthogram"
    let segueFromNewEthogram = "NewEthogramToNewProject"
    
    var project: Project? = nil
    var selectedEthogram: Ethogram? = nil
    
    override func viewDidLoad() {
        self.tableView.rowHeight = rowHeight
        Data.ethograms.append(Ethogram()) // For testing
        
        refreshView()
        if project == nil {
            project = Project() // Create a blank project
        }
    }
    
    // Toggles visibility of views based on state data.
    func refreshView() {
        if Data.ethograms.isEmpty {
            btnCreateEthogram.hidden = false
            btnSelectEthogram.hidden = true
            labelEthogram.text = messageNoEthograms
        } else {
            btnCreateEthogram.hidden = true
            btnSelectEthogram.hidden = false
            
            if selectedEthogram == nil {
                labelEthogram.text = messageNoEthogramsSelected
            } else {
                labelEthogram.text = selectedEthogram!.name
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueFromNewEthogram {
            if let vc = segue.sourceViewController as? EthogramFormViewController {
                
                // Get the ethogram created from the controller
                if let ethogram = vc.ethogram {
                    project?.ethogram = ethogram
                    // Update display
                } else {
                    // No ethogram was created
                }
            }
        }
    }
    
    @IBAction func btnCreateEthogramPressed(sender: UIButton) {
        // Segue to create ethogram with reference to this view controller.
        self.performSegueWithIdentifier(segueToNewEthogram, sender: self)
    }
    
    @IBAction func btnSelectEthogramPressed(sender: UIButton) {
        
    }
}
