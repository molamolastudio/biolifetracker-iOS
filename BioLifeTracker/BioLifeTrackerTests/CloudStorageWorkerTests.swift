//
//  CloudStorageWorkerTests.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 10/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import XCTest

class CloudStorageWorkerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testOneItemExecution() {
        var task = DownloadTask(classUrl: "dummy")
        var worker = CloudStorageWorker()
        worker.enqueueTask(task)
        
        var queryResultExpectation = self.expectationWithDescription("Check that the query produces result")
        
        worker.setOnFinished({
            XCTAssert(task.completedSuccessfully == true)
            if task.completedSuccessfully != true { return }
            XCTAssertNotEqual(0, task.getResults().count, "We assume there are some dummy objects on server")
            queryResultExpectation.fulfill()
            XCTAssertNotNil(task.getResults()[0]["id"], "Object ID must be present")
        })
        worker.startExecution()
        
        self.waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testMultipleItemExecution() {
        var worker = CloudStorageWorker()
        var downloadTask = DownloadTask(classUrl: "dummy", itemId: 1)
        var dummyItem = DummyModel()
        var uploadTask = UploadTask(item: dummyItem)
        worker.enqueueTask(downloadTask)
        worker.enqueueTask(uploadTask)
        let downloadExpectation = self.expectationWithDescription("Check that requested item is downloaded")
        let uploadExpectation = self.expectationWithDescription("Check that item has been uploaded")
        worker.setOnFinished({
            XCTAssert(downloadTask.completedSuccessfully == true)
            if downloadTask.completedSuccessfully != true { return }
            XCTAssertNotEqual(0, downloadTask.getResults().count, "Check download task has result")
            XCTAssertEqual(1, downloadTask.getResults()[0]["id"] as! Int, "Check for correct downloaded id")
            downloadExpectation.fulfill()
            
            XCTAssertNotNil(dummyItem.id, "Test that item has been uploaded")
            uploadExpectation.fulfill()
        })
        worker.startExecution()
        worker.startExecution() // test starting multiple times to stress test
        worker.startExecution() // test one more time
        self.waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    
    /// This function tests that the workers must run in a shared serial queue.
    /// It is expected that one worker will only start execution after the 
    /// previously started worker has ended. This is to prevent interfering use
    /// CloudStorageManager.sharedInstance accross multiple worker instances.
    func testMultipleInstancesOfWorker() {
        var workerA = CloudStorageWorker()
        var workerB = CloudStorageWorker()
        
        var workerACompleted = self.expectationWithDescription("Worker A has completed")
        var workerBCompleted = self.expectationWithDescription("Worker B has completed")
        
        var downloadTask = DownloadTask(classUrl: "dummy") // download all tasks, takes quite a long time
        workerA.enqueueTask(downloadTask)
        workerA.enqueueTask(downloadTask) // queue again to make worker A take longer time
        workerA.enqueueTask(downloadTask) // queue the third time!
        workerA.setOnFinished({
            XCTAssertNotEqual(downloadTask.getResults().count, 0, "Task downloaded")
            workerACompleted.fulfill()
        })
        workerA.setOnProgressUpdate({ percentage, message in
            XCTAssertEqual(workerB.locked, true, "Worker B should be locked")
            XCTAssertEqual(workerB.executing, false, "Assert that B has not started while A is progressing")
            XCTAssertEqual(workerB.finished, false, "Assert that B has not started while A is progressing")
        })
        
        workerB.enqueueTask(downloadTask)
        workerB.setOnFinished({
            workerBCompleted.fulfill()
        })
        
        workerA.startExecution()
        workerB.startExecution()
        
        self.waitForExpectationsWithTimeout(5, handler: nil)
    }
    
}