//
//  EthogramStorageTests.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 3/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import XCTest

class EthogramTests: XCTestCase {
    let state1 = BehaviourState(name: "Feeding", information: "Small claws bringing food to mouth")
    let state2 = BehaviourState(name: "Fighting", information: "Engagement of large clawa with another crab")
    let state3 = BehaviourState(name: "Hiding", information: "Withdrawal of fiddler crab into its burrow")
    var ethogram = Ethogram(name: "Fiddler Crabs")
    
    func testInitialization() {
        XCTAssert(ethogram.name == "Fiddler Crabs", "Ethogram not initialized properly")
        XCTAssert(ethogram.information == "", "Ethogram not initialized properly")
        XCTAssert(ethogram.behaviourStates.count == 0, "Ethogram not initialized properly")
    }
    
    func testUpdating() {
        XCTAssert(ethogram.name == "Fiddler Crabs", "Ethogram not updated properly")
        ethogram.updateName("Porcelain Fiddler Crabs")
        XCTAssert(ethogram.name == "Porcelain Fiddler Crabs", "Ethogram not updated properly")
        
        XCTAssert(ethogram.information == "", "Ethogram not updated properly")
        ethogram.updateInformation("Thumb sized crabs with black stripes across the shell")
        XCTAssert(ethogram.information == "Thumb sized crabs with black stripes across the shell", "Ethogram not updated properly")
        
        ethogram.addBehaviourState(state1)
        XCTAssert(ethogram.behaviourStates[0].name == "Feeding", "Ethogram not updated properly")
        
        ethogram.updateBehaviourStateName(0, bsName: "Snacking")
        XCTAssert(ethogram.behaviourStates[0].name == "Snacking", "Ethogram not updated properly")

        ethogram.updateBehaviourStateInformation(0, bsInformation: "Tiny inputs of sand to the mouth")
        XCTAssert(ethogram.behaviourStates[0].information == "Tiny inputs of sand to the mouth", "Ethogram not updated properly")

        ethogram.removeBehaviourState(0)
        XCTAssert(ethogram.behaviourStates.count == 0, "Ethogram not updated properly")
        
        ethogram.addBehaviourState(state3)
    }
    
    func testEquality() {
        ethogram.addBehaviourState(state1)
        ethogram.addBehaviourState(state2)
        ethogram.addBehaviourState(state3)
        
        var ethogram2 = Ethogram(name: "Blue Crabs")
        
        XCTAssert(ethogram == ethogram, "Not equal")
        XCTAssert(ethogram != ethogram2, "Error with equality")
    }
}