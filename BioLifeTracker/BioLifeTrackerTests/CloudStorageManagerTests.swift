//
//  CloudStorageManager.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 11/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import XCTest

class CloudStorageManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCachingBehaviour() {
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
        
        XCTAssertTrue(A.id != nil)
        XCTAssertTrue(B.id != nil)
        XCTAssertTrue(C.id != nil)
        XCTAssertTrue(D.id != nil)
        XCTAssertTrue(E.id != nil)
        if (A.id == nil ||
            B.id == nil ||
            C.id == nil ||
            D.id == nil ||
            E.id == nil) {
            return
        }
        
        let manager = CloudStorageManager.sharedInstance
        manager.clearCache()
        var downloadTask = DownloadTask(classUrl: DummyModel.ClassUrl, itemId: A.id!)
        downloadTask.execute()
        
        XCTAssertNil(manager.globalCache[DummyModel.ClassUrl]?[B.id!], "Lazy downloading")
        XCTAssertNil(manager.globalCache[DummyModel.ClassUrl]?[C.id!], "Lazy downloading")
        XCTAssertNil(manager.globalCache[DummyModel.ClassUrl]?[D.id!], "Lazy downloading")
        XCTAssertNil(manager.globalCache[DummyModel.ClassUrl]?[E.id!], "Lazy downloading")
        
        var resA = DummyModel(dictionary: downloadTask.getResults()[0])
        XCTAssertNotNil(manager.globalCache[DummyModel.ClassUrl]?[B.id!], "Result must be cached")
        XCTAssertNotNil(manager.globalCache[DummyModel.ClassUrl]?[C.id!], "Result must be cached")
        XCTAssertNotNil(manager.globalCache[DummyModel.ClassUrl]?[D.id!], "Result must be cached")
        XCTAssertNotNil(manager.globalCache[DummyModel.ClassUrl]?[E.id!], "Result must be cached")
    }
}
