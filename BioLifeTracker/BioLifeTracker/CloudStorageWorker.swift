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
    var totalNumOfTasks: Int = 0
    var onProgressUpdate: ((Double, String) -> ())?
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
        self.locked = true
        totalNumOfTasks = pendingTasks.count
        
        var networkThread: dispatch_queue_t = dispatch_queue_create(
            "com.cs3217.biolifetracker.network",
            DISPATCH_QUEUE_SERIAL)
        
        dispatch_async(networkThread, {
            while !self.pendingTasks.isEmpty {
                let task = self.pendingTasks.removeAtIndex(0)
                let message = "Executing \(task.description)"
                self.onProgressUpdate?(self.getPercentageCompletion(), message)
                task.execute()
            }
            self.onProgressUpdate?(self.getPercentageCompletion(), "Finished all tasks")
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
    
    /// Returns the percentage completion of task execution.
    /// Will simply calculate the number of task done divided by total number of tasks,
    /// and therefore is not representative of real time taken.
    private func getPercentageCompletion() -> Double {
        let completedItems = totalNumOfTasks - pendingTasks.count
        let percentage = 100.0 * Double(completedItems) / Double(totalNumOfTasks)
        return percentage
    }
}