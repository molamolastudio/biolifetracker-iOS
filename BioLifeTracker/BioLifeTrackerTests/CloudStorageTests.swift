//
//  CloudStorageTests.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 5/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import XCTest

class CloudStorageTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testUploadSimpleItem() {
        var dummyItem = DummyModel()
        var uploadTask = UploadTask(item: dummyItem)
        uploadTask.execute()
        
    }
}