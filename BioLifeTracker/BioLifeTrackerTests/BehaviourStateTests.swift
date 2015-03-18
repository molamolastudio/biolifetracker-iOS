//
//  BehaviorStateTests.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 12/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit
import XCTest

class BehaviourStateTests: XCTestCase {
    var bs1: BehaviourState!
    var bs2: BehaviourState!
    
    override func setUp() {
        super.setUp()
        bs1 = BehaviourState(id: 1, name: "Feeding", information: "The animal is eating")
        bs2 = BehaviourState(id: 2, name: "Sleeping", information: "In deep slumber")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        bs1.delete()
        bs2.delete()
    }

    func testInit() {
        XCTAssert(bs1 != nil, "Behavior state 1 is not initialized")
        XCTAssert(bs2 != nil, "Behavior state 2 is not initialized")
    }
    
    func testDefaultMaker() {
        var behaviourState = BehaviourState.makeDefault()
        XCTAssertNotNil(behaviourState.id)
        XCTAssertNotNil(behaviourState.name)
        XCTAssertNotNil(behaviourState.information)
        XCTAssertNotNil(behaviourState.photoUrls)
    }
    
    func testSaveToParse() {
        // synchronously save to Parse
        var success1 = bs1.save()
        var success2 = bs2.save()
        XCTAssertEqual(success1, true, "BehaviourState not saved properly")
        XCTAssertEqual(success2, true, "BehaviourState not saved properly")
        
        // test saved data integrity
        var query = BehaviourState.query()
        query.whereKey("name", equalTo: "Sleeping")
        var result = query.findObjects()
        XCTAssertFalse(result.isEmpty, "Query result must not be empty")
    }

    func testPerformanceSaveToParse() {
        self.measureBlock {
            self.bs1.save()
            self.bs2.save()
        }
    }

}
