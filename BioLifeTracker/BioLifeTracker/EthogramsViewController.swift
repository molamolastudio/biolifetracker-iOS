//
//  EthogramsViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 12/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//
//  Shows a list of ethograms to the user.

import UIKit

class EthogramsViewController: UIViewController, UITableViewDataSource,
                               UITableViewDelegate {
    
    var delegate: EthogramsViewControllerDelegate? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellReuseIdentifier = "SubtitleTableCell"
    let cellHeight: CGFloat = 50
    let messageCellSubtitle = "States: "
    let numSections = 1
    
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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.editing = false
    }
    
    // MARK: UITableViewDataSource AND UITableViewDelegate METHODS
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! SubtitleTableCell
        
        let ethogram = EthogramManager.sharedInstance.ethograms[indexPath.row]
        
        cell.title.text = ethogram.name
        cell.subtitle.text = messageCellSubtitle + String(ethogram.behaviourStates.count)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if delegate != nil {
            delegate!.userDidSelectEthogram(indexPath.row)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EthogramManager.sharedInstance.ethograms.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numSections
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    // Deletes the related ethogram if the cell is deleted.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let ethogramManager = EthogramManager.sharedInstance
            let projectManager = ProjectManager.sharedInstance
            let ethogram = ethogramManager.ethograms[indexPath.row]
            
            // If the ethogram is being used in any project
            if projectManager.hasProjectUsingEthogram(ethogram) {
                
                // Present an alert to say the ethogram cannot be deleted
                let failAlert = UIAlertController(title: "Unable to Delete Ethogram",
                    message: "Some projects in this device depend on this ethogram",
                    preferredStyle: .Alert)
                let actionOK = UIAlertAction(title: "OK", style: .Default, handler: nil)
                failAlert.addAction(actionOK)
                
                presentViewController(failAlert, animated: true, completion: nil)
                self.tableView.reloadData()
                
            } else {
                
                // Remove the ethogram from the EthogramManager
                if ethogram.id == nil {
                    ethogramManager.removeEthograms([indexPath.row])
                    self.tableView.reloadData()
                } else {
                    
                    // Present an alert to the user
                    let alert = UIAlertController(title: "Checking Dependency",
                        message: "Checking for projects using this ethogram",
                        preferredStyle: .Alert)
                    presentViewController(alert, animated: true, completion: nil)
                    
                    // Start downloading
                    let worker = CloudStorageWorker()
                    let downloadTask = DownloadTask(classUrl: Ethogram.ClassUrl, itemId: ethogram.id!)
                    worker.enqueueTask(downloadTask)
                    
                    // When the worker is done
                    worker.setOnFinished {
                        
                        if downloadTask.completedSuccessfully == true {
                            
                            let ethogramInfo = downloadTask.getResults()[0]
                            let dependants = ethogramInfo["project_set"] as! [Int]
                            
                            if dependants.count > 0 {
                                dispatch_async(dispatch_get_main_queue(), {
                                    
                                    // Present an alert indicating failure
                                    let failAlert = UIAlertController(title: "Cannot Delete",
                                        message: "Some projects in server depend on this ethogram",
                                        preferredStyle: .Alert)
                                    let actionOK = UIAlertAction(title: "OK", style: .Default, handler: nil)
                                    failAlert.addAction(actionOK)
                                    
                                    alert.dismissViewControllerAnimated(true, completion: {
                                        self.presentViewController(failAlert, animated: true, completion: nil)
                                    })
                                })
                            } else {
                                // Issue an ethogram delete request
                                dispatch_async(dispatch_get_main_queue(), {
                                    ethogramManager.removeEthograms([indexPath.row])
                                    self.tableView.reloadData()
                                    self.issueEthogramDeleteRequest(ethogram)
                                })
                            }
                        } else {
                            // The worker was unable to download successfully
                            dispatch_async(dispatch_get_main_queue(), {
                                self.tableView.reloadData()
                                let failAlert = UIAlertController(title: "Cannot Delete",
                                    message: "The server cannot be contacted at the moment",
                                    preferredStyle: .Alert)
                                let actionOK = UIAlertAction(title: "OK", style: .Default, handler: nil)
                                failAlert.addAction(actionOK)
                                
                                alert.dismissViewControllerAnimated(true, completion: {
                                    self.presentViewController(failAlert, animated: true, completion: nil)
                                })
                                
                            })
                        }
                    }
                    worker.startExecution()
                }
            }
        }
    }
    
    private func issueEthogramDeleteRequest(ethogram: Ethogram) {
        let deleteTask = DeleteTask(item: ethogram)
        let worker = CloudStorageWorker()
        worker.enqueueTask(deleteTask)
        worker.startExecution()
    }
}

