//
//  ScanSessionViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 14/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class ScanSessionViewController: UITableViewController {
    var delegate: ScanSessionViewControllerDelegate? = nil
    
    let cellReuseIdentifier = "SubtitleTableCell"
    let cellHeight: CGFloat = 50
    let messageCellSubtitle = "Observations: "
    
    let numSections = 1
    
    var currentSession: Session? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    // UITableViewDataSource and UITableViewDelegate METHODS
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! SubtitleTableCell
        
        let ethogram = EthogramManager.sharedInstance.ethograms[indexPath.row]
        
        cell.title.text = ethogram.name
        cell.subtitle.text = messageCellSubtitle + String(ethogram.behaviourStates.count)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if delegate != nil {
            delegate!.userDidSelectScan(currentSession!, index: indexPath.row)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EthogramManager.sharedInstance.ethograms.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numSections
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
}

