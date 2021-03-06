//
//  BehaviourStateTests.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 4/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import XCTest

class BehaviourStateTests: XCTestCase {
    var state = BehaviourState(name: "Feeding", information: "Small claws bringing food to mouth")
    
    func testInitialization() {
        XCTAssert(state.name == "Feeding", "BehaviourState not initialised properly")
        XCTAssert(state.information == "Small claws bringing food to mouth", "BehaviourState not initialised properly")
    }
    
    func testUpdates() {
        XCTAssert(state.name == "Feeding", "BehaviourState not updated properly")
        state.updateName("Fighting")
        XCTAssert(state.name == "Fighting", "BehaviourState not updated properly")
        
        XCTAssert(state.information == "Small claws bringing food to mouth", "BehaviourState not updated properly")
        state.updateInformation("Engagement of large clawa with another crab")
        XCTAssert(state.information == "Engagement of large clawa with another crab", "BehaviourState not updated properly")
        
        // Test update photo
    }
    
    func testEquality() {
        let state1 = BehaviourState(name: "Feeding", information: "Small claws bringing food to mouth")
        let state2 = BehaviourState(name: "Fighting", information: "Engagement of large clawa with another crab")
        let state3 = BehaviourState(name: "Feeding", information: "Small claws bringing food to mouth")
        
        XCTAssert(state1 == state3, "Not equal")
        XCTAssert(state1 != state2, "Error in equality")
        
    }

}