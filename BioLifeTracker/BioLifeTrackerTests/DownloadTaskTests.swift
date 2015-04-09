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
        var task = DownloadTask(className: "dummy", itemId: 1)
        task.execute()
        var results = task.getResults()
        var item = DummyModel(dictionary: results[0])
        
        XCTAssertEqual(1, item.id!)
        XCTAssertNotNil(item.stringProperty)
        XCTAssertNotNil(item.intProperty)
        XCTAssertNotNil(item.dateProperty)
    }
    
    func testBatchDownload() {
        var task = DownloadTask(className: "dummy")
        task.execute()
        var results = task.getResults()
        for dictionary in results {
            var item = DummyModel(dictionary: dictionary)
            XCTAssertNotNil(item.id)
        }
    }
    
}