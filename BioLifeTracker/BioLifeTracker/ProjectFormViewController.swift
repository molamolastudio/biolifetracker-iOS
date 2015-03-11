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
    
    let messageNoEthograms = "You have no ethograms saved"
    let messageNoEthogramsSelected = "Select an ethogram"
    var selectedEthogram: Ethogram? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleVisibilityOfViews()
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
    
    @IBAction func btnCreateEthogramPressed(sender: UIButton) {
        // Segue to create ethogram with this project's id
    }
    
    @IBAction func btnSelectEthogramPressed(sender: UIButton) {
        // Pop up a table view picker (with xib?)
    }
}
