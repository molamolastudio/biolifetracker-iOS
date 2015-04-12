//
//  DownloadTaskTests.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 9/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import XCTest

class DownloadTaskTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /// Assumes there is at least one dummy item on the server (can be using upload task)
    func testDownloadingSimpleFile() {
        var task = DownloadTask(classUrl: "dummy", itemId: 1)
        task.execute()
        var results = task.getResults()
        var item = DummyModel(dictionary: results[0])
        
        XCTAssertEqual(1, item.id!)
        XCTAssertNotNil(item.stringProperty)
        XCTAssertNotNil(item.intProperty)
        XCTAssertNotNil(item.dateProperty)
    }
    
    func testBatchDownload() {
        var task = DownloadTask(classUrl: "dummy")
        task.execute()
        var results = task.getResults()
        for dictionary in results {
            var item = DummyModel(dictionary: dictionary)
            XCTAssertNotNil(item.id)
        }
    }
    
    func testDownloadingItemWithDependency() {
        var A = DummyModel()
        var B = DummyModel()
        var C = DummyModel()
        var D = DummyModel()
        var E = DummyModel()
        
        A.stringProperty = "A"
        B.stringProperty = "B"
        C.stringProperty = "C"
        D.stringProperty = "D"
        E.stringProperty = "E"
        A.friends = [B, C]
        B.friends = [D]
        C.friends = [E]
        let uploadTask = UploadTask(item: A)
        uploadTask.execute()
        
        assert(A.id != nil)
        assert(B.id != nil)
        assert(C.id != nil)
        assert(D.id != nil)
        assert(E.id != nil)
        
        let manager = CloudStorageManager.sharedInstance
        manager.clearCache()
        var downloadTask = DownloadTask(classUrl: DummyModel.ClassUrl, itemId: A.id!)
        downloadTask.execute()
        
        var resA = DummyModel(dictionary: downloadTask.getResults()[0])
        let friendIds = resA.friends.map { $0.id! }
        XCTAssert(contains(friendIds, B.id!))
        XCTAssert(contains(friendIds, C.id!))
        
        
    }
    
}
