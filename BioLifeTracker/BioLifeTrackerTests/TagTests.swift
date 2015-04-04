//
//  TagTests.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 4/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import XCTest

class TagTests: XCTestCase {
    var tag = Tag(tag: "Female")
    
    func testReadTag() {
        XCTAssert(tag.tag == "Female", "Tag not initialised properly")
    }
    
    func testUpdateTag() {
        tag.updateTag("Male")
        XCTAssert(tag.tag == "Male", "Tag not updated properly")
    }
}