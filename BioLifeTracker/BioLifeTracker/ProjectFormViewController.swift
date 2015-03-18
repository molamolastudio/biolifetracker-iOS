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
    
    var picker: EthogramPicker? = nil
    
    let rowHeight: CGFloat = 44
    
    let messageNoEthograms = "You have no ethograms"
    let messageNoEthogramsSelected = "Tap here to choose one"
    
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
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("showPicker"))
        if Data.ethograms.isEmpty {
            labelEthogram.text = messageNoEthograms
            labelEthogram.userInteractionEnabled = false
            labelEthogram.removeGestureRecognizer(tapGesture)
        } else {
            if selectedEthogram == nil {
                labelEthogram.text = messageNoEthogramsSelected
            } else {
                labelEthogram.text = selectedEthogram!.name
            }
            labelEthogram.userInteractionEnabled = true
            labelEthogram.addGestureRecognizer(tapGesture)
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
                //animal: textFieldAnimal.text,
                ethogram: selectedEthogram!)
            Data.selectedProject = p
            Data.projects.append(p)
            self.performSegueWithIdentifier(segueToProjectHome, sender: self)
        }
    }
    
    func showPicker() {
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
