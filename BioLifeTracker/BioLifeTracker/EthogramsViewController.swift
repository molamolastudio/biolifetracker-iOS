//
//  EthogramsViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 12/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class EthogramsViewController: UITableViewController {
    
    let cellReuseIdentifier = "SubtitleTableCell"
    
    let messageCellSubtitle = "States: "
    
    let numSections = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Data.ethograms.count == 0 {
            Data.ethograms.append(Ethogram()) // For testing
        }
    }
    
    // UITableViewDataSource and UITableViewDelegate METHODS
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as SubtitleTableCell

        let ethogram = Data.ethograms[indexPath.row]
        
        cell.title.text = ethogram.name
        cell.subtitle.text = messageCellSubtitle + String(ethogram.behaviourStates.count)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        Data.selectedEthogram = Data.ethograms[indexPath.row]
        self.performSegueWithIdentifier(segueToEthogramDetails, sender: self)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.ethograms.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numSections
    }
}

