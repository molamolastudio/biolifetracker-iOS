//
//  DeleteTaskTests.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 10/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import XCTest

class DeleteTaskTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDeleteItem() {
        var dummy = DummyModel()
        dummy.stringProperty = "Item to be deleted"
        dummy.optionalStringProperty = "Error if this item persists in server after test"
        let uploadTask = UploadTask(item: dummy)
        uploadTask.execute()
        assert(dummy.id != nil, "Upload task failed")
        let itemId = dummy.id!
        
        let deleteTask = DeleteTask(item: dummy)
        deleteTask.execute()
        XCTAssertNil(dummy.id, "Item id should be erased after deletion from server")
        
        let downloadTask = DownloadTask(classUrl: dummy.classUrl, itemId: itemId)
        downloadTask.execute()
        let responseDictionary = downloadTask.getResults()[0]
        XCTAssertNotNil(responseDictionary["detail"], "Check web server response for DELETE")
        XCTAssertEqual(responseDictionary["detail"]! as! String, "Not found.", "Item should not exist on server.")
        
    }
}
