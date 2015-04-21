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
        
        doneBtn.hidden = true
    }
    
    // Hides interval field if the focal session type is chosen.
    @IBAction func booleanSwitchChanged(sender: UISwitch) {
        intervalLabel.hidden = sender.on
        intervalField.hidden = sender.on
    }
    
    @IBAction func doneBtnPressed(sender: UIButton) {
        let name = nameField.text
        
        if currentProject != nil && delegate != nil && name != "" {
            
            if booleanSwitch.on {
                delegate!.userDidFinishCreatingSession(Session(project: currentProject!, name: name, type: .Focal))
            } else {
                let interval = intervalField.text
                if let int = interval.toInt() {
                    let session = Session(project: currentProject!, name: name, type: .Scan)
                    session.setInterval(int)
                    delegate!.userDidFinishCreatingSession(session)
                    
                }
            }
        }
    }
}
