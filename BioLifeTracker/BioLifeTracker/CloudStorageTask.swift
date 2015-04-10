//
//  CloudStorageTask.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 5/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

/// CloudStorageTask represents a single unit of execution of cloud storage 
/// operation. A CloudStorageTask may automatically instantiate another
/// CloudStorageTask that it depends on. In this case, they will be executed
/// in a serial order. Since network operations can take arbitrarily long
/// time to finish, a CloudStorageTask should not be executed in the main thread.
/// You can enqueue a CloudStorageTask in a CloudStorageWorker to achieve
/// asynchronous execution.
protocol CloudStorageTask {
    
    func execute()
    var description: String { get }
    
}
