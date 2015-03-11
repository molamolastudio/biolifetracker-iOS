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
    @IBOutlet weak var textFieldEthogram: UITextField!

    @IBOutlet weak var btnCreateEthogram: UIButton!
    @IBOutlet weak var btnSelectEthogram: UIButton!
    
    let rowHeight: CGFloat = 44
    
    let messageNoEthograms = "You have no ethograms"
    let messageNoEthogramsSelected = "Select an ethogram"
    
    let segueToNewEthogram = "NewProjectToNewEthogram"
    let segueFromNewEthogram = "NewEthogramToNewProject"
    
    var project: Project? = nil
    var selectedEthogram: Ethogram? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = rowHeight
        toggleVisibilityOfViews()
        
        if project == nil {
            project = Project() // Create a blank project
        }
    }
    
    func toggleVisibilityOfViews() {
        if Data.ethograms.isEmpty {
            btnCreateEthogram.hidden = false
            btnSelectEthogram.hidden = true
            textFieldEthogram.text = messageNoEthograms
        } else {
            btnCreateEthogram.hidden = true
            btnSelectEthogram.hidden = false
            
            if selectedEthogram == nil {
                textFieldEthogram.text = messageNoEthogramsSelected
            } else {
                textFieldEthogram.text = selectedEthogram!.name
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
        // Pop up a table view picker (with xib?)
    }
}
