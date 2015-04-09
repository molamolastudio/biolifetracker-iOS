//
//  UploadTaskTests.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 9/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import XCTest

class UploadTaskTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /// Tests uploading one item without any dependency
    func testUploadSimpleItem() {
        var dummyItem = DummyModel()
        var uploadTask = UploadTask(item: dummyItem)
        uploadTask.execute()
        XCTAssertNotNil(dummyItem.id, "Item ID must not be nil after uploading")
    }
    
    /// Test for this scenario: A relies on B and C.
    /// B relies on D.
    /// C relies on E.
    func testUploadItemWithSimpleDependencies() {
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
        
        XCTAssertNotNil(A.id)
        XCTAssertNotNil(B.id)
        XCTAssertNotNil(C.id)
        XCTAssertNotNil(D.id)
        XCTAssertNotNil(E.id)
    }

}