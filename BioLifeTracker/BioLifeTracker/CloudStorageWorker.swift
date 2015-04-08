//
//  CloudStorageWorker.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 5/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class CloudStorageWorker {
    // MARK: Stored properties
    var pendingTasks: [CloudStorageTask] = []
    var locked: Bool = false
    var numOfTasks: Int = 0
    
    // MARK: Computed properties
    var hasCompleted: Bool {
        return pendingTasks.isEmpty
    }
    
    // MARK: Functions
    func addTask(task: CloudStorageTask) {
        pendingTasks.append(task)
    }
    
    // REQUIRES: nothing
    // EFFECT:  - locks the worker instance (cannot add tasks anymore 
    //            after this function is called)
    //          - asynchronously starts execution of the enqueued tasks
    //          - progress can be monitored via getPercentageCompletion
    func startExecution() {
        self.locked = true
        numOfTasks = pendingTasks.count
        
    }
    
    func getPercentageCompletion() -> Double {
        let completedItems = numOfTasks - pendingTasks.count
        let percentage = 100.0 * Double(completedItems) / Double(numOfTasks)
        return percentage
    }
    
    func setOnProgressUpdate(
        onProgressUpdate: (percentage: Double, message: String) -> ()) {
        
    }
    
    
}