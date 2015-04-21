//
//  CreateSessionViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 21/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class CreateSessionViewController: UIViewController {
    var delegate: CreateSessionViewControllerDelegate? = nil
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var intervalField: UITextField!
    @IBOutlet weak var booleanSwitch: UISwitch!
    @IBOutlet weak var doneBtn: UIButton!
    
    var currentProject: Project? = nil
    
    override func loadView() {
        self.view = NSBundle.mainBundle().loadNibNamed("CreateSessionView", owner: self, options: nil).first as! UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toggleViews()
        
        nameField.addTarget(self, action: Selector("toggleViews"), forControlEvents: UIControlEvents.EditingChanged)
        intervalField.addTarget(self, action: Selector("toggleViews"), forControlEvents: UIControlEvents.EditingChanged)
    }
    
    // Hides interval field if the focal session type is chosen.
    @IBAction func booleanSwitchChanged(sender: UISwitch) {
        toggleViews()
    }
    
    @IBAction func doneBtnPressed(sender: UIButton) {
        let name = nameField.text
        
        if currentProject != nil && delegate != nil && name != "" {
            
            // If the scan session was chosen
            if booleanSwitch.on {
                
                // Create a scan session
                let interval = intervalField.text
                if let int = interval.toInt() {
                    let session = Session(project: currentProject!, name: name, type: .Scan)
                    session.setInterval(int)
                    delegate!.userDidFinishCreatingSession(session)
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            } else {
                // Create a focal session
                delegate!.userDidFinishCreatingSession(Session(project: currentProject!, name: name, type: .Focal))
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    // Toggles visibility of the done button. Hides the button if the required
    // fields are not filled.
    func toggleViews() {
        intervalLabel.hidden = !booleanSwitch.on
        intervalField.hidden = !booleanSwitch.on
        
        if booleanSwitch.on {
            doneBtn.hidden = (nameField.text == "")
        } else {
            doneBtn.hidden = (nameField.text == "" && intervalField.text == "")
        }
    }
}
