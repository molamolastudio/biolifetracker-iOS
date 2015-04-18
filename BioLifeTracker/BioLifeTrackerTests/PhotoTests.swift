//
//  PhotoTests.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 13/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import UIKit
import XCTest

class PhotoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testUploadingPhoto() {
        let image = UIImage(named: "dummy_image")
        let photo = Photo(image: image!)
        let uploadTask = UploadTask(item: photo)
        uploadTask.execute()
        XCTAssertNotNil(photo.id)
    }
    
    func testRetrievingPhoto() {
        let image = UIImage(named: "dummy_image")
        let photo = Photo(image: image!)
        let uploadTask = UploadTask(item: photo)
        uploadTask.execute()
        XCTAssertTrue(photo.id != nil, "Uploading photo does not work correctly")
        if photo.id == nil { return }
        
        let photoId = photo.id!
        let downloadTask = DownloadTask(classUrl: Photo.ClassUrl, itemId: photoId)
        downloadTask.execute()
        let results = downloadTask.getResults()
        assert(results.count == 1)
        let resultPhoto = Photo(dictionary: results[0])
        XCTAssertNotEqual(0, UIImageJPEGRepresentation(resultPhoto.image, 1.0).length, "Image shouldn't be empty")
        
    }
    
    
}