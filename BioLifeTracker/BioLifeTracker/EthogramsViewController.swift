//
//  EthogramsViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 12/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class EthogramsViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    let segueToEthogramDetails = "EthogramsToEthogramDetails"
    
    let cellReuseIdentifier = "EthogramTableCell"
    
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
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell
        
        let title = cell.viewWithTag(Constants.ViewTags.ethogramsCellTitle) as UILabel
        let subtitle = cell.viewWithTag(Constants.ViewTags.ethogramsCellSubtitle) as UILabel
        let ethogram = Data.ethograms[indexPath.row]
        
        title.text = ethogram.name
        subtitle.text = messageCellSubtitle + String(ethogram.behaviourStates.count)
        
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

