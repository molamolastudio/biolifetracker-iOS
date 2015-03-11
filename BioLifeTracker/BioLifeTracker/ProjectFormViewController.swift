//
//  ProjectFormViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class ProjectFormViewController: UITableViewController, EthogramPickerDelegate {
    
    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var textFieldAnimal: UITextField!
    @IBOutlet weak var labelEthogram: UILabel!
    
    @IBOutlet weak var btnCreateEthogram: UIButton!
    @IBOutlet weak var btnSelectEthogram: UIButton!
    
    var picker: EthogramPicker? = nil
    
    let rowHeight: CGFloat = 44
    
    let messageNoEthograms = "You have no ethograms"
    let messageNoEthogramsSelected = "Select an ethogram"
    
    let segueToProjectHome = "NewProjectToProjectHome"
    let segueToNewEthogram = "NewProjectToNewEthogram"
    let segueFromNewEthogram = "NewEthogramToNewProject"
    
    var project: Project? = nil
    var selectedEthogram: Ethogram? = nil
    
    var alert = UIAlertController()
    let alertTitle = "Incomplete Project"
    let alertMessage = "All fields must be filled."
    
    override func viewDidLoad() {
        self.tableView.rowHeight = rowHeight
        if Data.ethograms.count == 0 {
            Data.ethograms.append(Ethogram()) // For testing
        }
        setupAlertController()
        
        refreshView()
    }
    
    func setupAlertController() {
        alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let actionOk = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(actionOk)
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
    
    // Checks if all input is filled before creating project and moving to next page.
    @IBAction func btnDonePressed(sender: UIBarButtonItem) {
        if textFieldTitle.text == "" || textFieldAnimal.text == "" || selectedEthogram == nil {
            self.presentViewController(alert, animated: true, completion: {})
        } else {
            let p = Project(name: textFieldTitle.text,
                animal: textFieldAnimal.text,
                ethogram: selectedEthogram!)
            Data.selectedProject = p
            Data.projects.append(p)
            self.performSegueWithIdentifier(segueToProjectHome, sender: self)
        }
    }
    
    @IBAction func btnCreateEthogramPressed(sender: UIButton) {
        // Segue to create ethogram with reference to this view controller.
        self.performSegueWithIdentifier(segueToNewEthogram, sender: self)
    }
    
    @IBAction func btnSelectEthogramPressed(sender: UIButton) {
        picker = EthogramPicker()
        picker!.delegate = self
        
        for e in Data.ethograms {
            picker!.data.append(e.name)
        }
        
        self.view.addSubview(picker!.view)
        picker!.view.frame = self.view.frame
    }
    
    // EthogramPickerDelegate METHOD
    func pickerDidDismiss(selectedRow: Int?) {
        picker!.view.removeFromSuperview()
        
        if selectedRow != nil {
            selectedEthogram = Data.ethograms[selectedRow!]
            refreshView()
        }
    }
}
