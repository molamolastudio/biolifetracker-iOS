//
//  AnalysisTableViewController.swift
//  BioLifeTracker
//
//  Created by Haritha on 20/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import UIKit

class AnalysisTableViewController: UITableViewController {
    
    enum TableType {
        case Users, Sessions, States
    }
    
    var delegate: GraphsViewControllerDelegate?
    
    private var totalUsers: [User]!
    private var totalSessions: [Session]!
    private var totalStates: [BehaviourState]!
    
    var tableType = TableType.Users
    
    private var selectedIndices = [Int]()
    
    let cellReuseIdentifierHead = "AnalysisTableHeader"
    let cellReuseIdentifier = "AnalysisTableViewCell"
    
    let cellHeight: CGFloat = 50
    
    let numSections = 1
    
    private var headerTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.allowsMultipleSelection = true
        
        self.tableView.registerNib(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        self.tableView.registerNib(UINib(nibName: cellReuseIdentifierHead, bundle: nil), forHeaderFooterViewReuseIdentifier: cellReuseIdentifierHead)
    }
    
    func toggleTable(type: TableType) {
        tableType =  type
    }
    
    func setHeaderTitle(newTitle: String) {
        headerTitle = newTitle
    }
    
    func initUsers(array: [User], chosen: [User]) {
        
        totalUsers = array
        var ttl = array.count - 1
        
        for i in 0...ttl {
            var item = totalUsers[i]
            if contains(chosen, item) {
                selectedIndices.append(i)
                var idx = NSIndexPath(forRow: i, inSection: 0)
                tableView.selectRowAtIndexPath(idx, animated: true, scrollPosition: .None)
            }
        }
    }
    
    func initSessions(array: [Session], chosen: [Session]) {
        totalSessions = array
        var ttl = array.count - 1
        
        for i in 0...ttl {
            var item = totalSessions[i]
            if contains(chosen, item) {
                selectedIndices.append(i)
                var idx = NSIndexPath(forRow: i, inSection: 0)
                tableView.selectRowAtIndexPath(idx, animated: true, scrollPosition: .None)
            }
        }
    }
    
    func initStates(array: [BehaviourState], chosen: [BehaviourState]) {
        totalStates = array
        var ttl = array.count - 1
        
        for i in 0...ttl {
            var item = totalStates[i]
            if contains(chosen, item) {
                selectedIndices.append(i)
                var idx = NSIndexPath(forRow: i, inSection: 0)
                tableView.selectRowAtIndexPath(idx, animated: true, scrollPosition: .None)
            }
        }
    }
    func initEmpty() {
        totalSessions = [Session]()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! AnalysisTableViewCell
        
        var title: String!
        
        switch tableType {
        case .Users:
            title = totalUsers[indexPath.row].name
        case .Sessions:
            title = totalSessions[indexPath.row].name
        case .States:
            title = totalStates[indexPath.row].name
        }
        cell.cellLabel.text = title
        return cell
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableType {
        case .Users:
            return totalUsers.count
        case .Sessions:
            return totalSessions.count
        case .States:
            return totalStates.count
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(cellReuseIdentifierHead) as! AnalysisTableHeader
        header.headerTitle.text = headerTitle
        header.selectButton.addTarget(self, action: "selectAllPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        return header
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        var header = view as! UITableViewHeaderFooterView
        
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numSections
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return cellHeight - 20
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var i = indexPath.row
        var ind = find(selectedIndices, i)
        selectedIndices.removeAtIndex(ind!)
        switch tableType {
        case .Users:
            var user = totalUsers[indexPath.row]
            delegate!.didRemoveUser(user)
        case .Sessions:
            var session = totalSessions[indexPath.row]
            delegate!.didRemoveSession(session)
        case .States:
            var state = totalStates[indexPath.row]
            delegate!.didRemoveState(state)
        }


    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        updateChosen(indexPath.row)
    }
    
    func selectAllPressed(sender: UIButton!) {
        var ttl: Int
        switch tableType {
        case .Users:
            ttl = totalUsers.count - 1
        case .Sessions:
            if totalSessions.count != 0 {
                ttl = totalSessions.count - 1
            } else {
                ttl = 0
            }
        case .States:
            ttl = totalStates.count - 1
        }
        
        for i in 0...ttl {
            var idx = NSIndexPath(forRow: i, inSection: 0)
            tableView.selectRowAtIndexPath(idx, animated: true, scrollPosition: .None)
            updateChosen(i)
        }
    }
    
    func updateChosen(index: Int) {
        var ind = find(selectedIndices, index)
        if ind == nil {
            selectedIndices.append(index)
            switch tableType {
            case .Users:
                var user = totalUsers[index]
                delegate!.didAddUser(user)
            case .Sessions:
                var session = totalSessions[index]
                delegate!.didAddSession(session)
            case .States:
                var state = totalStates[index]
                delegate!.didAddState(state)
            }
        }
    }
    
}