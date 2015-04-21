//
//  ScanSessionViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 14/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class ScanSessionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var delegate: ScanSessionViewControllerDelegate? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellReuseIdentifier = "SubtitleTableCell"
    let cellHeight: CGFloat = 50
    let messageCellSubtitle = "Observations: "
    
    let numSections = 1
    
    let formatter = NSDateFormatter()
    
    var currentSession: Session? = nil
    
    var timestamps: [NSDate] = []
    
    override func loadView() {
        self.view = NSBundle.mainBundle().loadNibNamed("PaddedTableView", owner: self, options: nil).first as! UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.registerNib(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        
        // Sets the subviews to display under the navigation bar
        self.edgesForExtendedLayout = UIRectEdge.None
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Sets rounded corners
        self.tableView.layer.cornerRadius = 8
        self.tableView.layer.masksToBounds = true
        
        // Sets up the date formatter for converting dates to strings
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        
        timestamps = currentSession!.getTimestamps()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.editing = false
    }
    
    // UITableViewDataSource and UITableViewDelegate METHODS
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! SubtitleTableCell
        
        cell.title.text = formatter.stringFromDate(timestamps[indexPath.row])
        cell.subtitle.text = messageCellSubtitle + "\(currentSession!.getObservationsByTimestamp(timestamps[indexPath.row]).count)"
        
        return cell
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if delegate != nil {
            delegate!.userDidSelectScan(currentSession!, timestamp: timestamps[indexPath.row])
        }
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timestamps.count
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numSections
    }
    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
}

