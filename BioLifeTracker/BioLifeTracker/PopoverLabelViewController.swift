//
//  GraphDetailsViewController.swift
//  BioLifeTracker
//
//  Created by Haritha on 19/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import UIKit

/// For display of popover on the graph.
class PopoverLabelViewController: UIViewController {

    @IBOutlet weak var popoverLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setLabelMessage(message: String) {
        popoverLabel.text = message
    }
    
    
}