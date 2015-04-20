//
//  CloudStorageWorker.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 5/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class CloudStorageWorker {
    var pendingTasks: [CloudStorageTask] = [CloudStorageTask]()
    var locked: Bool = false
    var executing: Bool = false
    var finished: Bool = false
    var totalNumOfTasks: Int = 0
    var onProgressUpdate: ((Double, String) -> ())?
    var onFinished: (()-> ())?
    var hasCompleted: Bool {
        return pendingTasks.isEmpty
    }
    
    init() { }
    
    /// Enqueues a CloudStorageTask for execution.
    /// Execution will be in First-In-First-Out (FIFO) order.
    func enqueueTask(task: CloudStorageTask) {
        pendingTasks.append(task)
    }
    
    /// This function asynchronously starts the execution of the added tasks.
    /// After this function is called, you should not call enqueueTask(task:) anymore.
    /// If you wish to monitor the execution progress, please call
    /// setOnProgressUpdate(onProgressUpdate:) before calling this function.
    func startExecution() {
        if self.locked || self.finished {
            NSLog("Do not call startExecution() on a processing or completed CloudStorageWorker instance.")
            return
        }
        self.locked = true
        totalNumOfTasks = pendingTasks.count
        
        dispatch_async(CloudStorage.networkThread, {
            self.executing = true
            CloudStorageManager.sharedInstance.clearCache()
            while !self.pendingTasks.isEmpty {
                let percentage = self.getPercentageCompletion()
                let task = self.pendingTasks.removeAtIndex(0)
                let message = task.description
                self.onProgressUpdate?(percentage, message)
                task.execute()
            }
            self.onProgressUpdate?(self.getPercentageCompletion(), "Finished all tasks")
            self.executing = false
            self.finished = true
            self.onFinished?()
        })
        dispatch_async(CloudStorage.networkThread, {
            self.locked = false
        })
    }
    
    /// Sets a closure that will be called every time one task is about to be executed.
    /// The closure should receive two arguments: percentage (Double), which is
    /// 100.0 * the number of task done divided by total number of tasks, and
    /// message (String), which is additional information that can be displayed to the user.
    func setOnProgressUpdate(
        onProgressUpdate: (percentage: Double, message: String) -> ()) {
        self.onProgressUpdate = onProgressUpdate
    }
    
    func setOnFinished(onFinished: () -> ()) {
        self.onFinished = onFinished
    }
    
    
    
    /// Returns the percentage completion of task execution.
    /// Will simply calculate the number of task done divided by total number of tasks,
    /// and therefore is not representative of real time taken.
    private func getPercentageCompletion() -> Double {
        let completedItems = totalNumOfTasks - pendingTasks.count
        let percentage = 100.0 * Double(completedItems) / Double(totalNumOfTasks)
        return percentage
    }
}