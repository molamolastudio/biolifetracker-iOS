//
//  IndividualTests.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 4/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import XCTest

class IndividualTests: XCTestCase {
    var individual = Individual(label: "M1")
    
    func testInitialization() {
        XCTAssert(individual.label == "M1", "Individual not initialised properly")
        XCTAssert(individual.tags.count == 0, "Individual not initialised properly")
        XCTAssert(individual.photo == nil, "Individual not initialised properly")
    }
    
    func testUpdates() {
        individual.updateLabel("M3")
        XCTAssert(individual.label == "M3", "Individual not initialised properly")
        
        individual.addTag(Tag(name: "Aggressive"))
        XCTAssert(individual.tags[0].name == "Aggressive", "Individual not initialised properly")
        
        individual.addTag(Tag(name: "Territorial"))
        XCTAssert(individual.tags[1].name == "Territorial", "Individual not initialised properly")
        
        individual.removeTagAtIndex(0)
        XCTAssert(individual.tags[0].name == "Territorial", "Individual not initialised properly")
    }
    
    func testEquality() {
        let individual1 = Individual(label: "M1")
        let individual2 = Individual(label: "F1")
        let individual3 = Individual(label: "M1")
        
        XCTAssert(individual1 == individual3, "Not equal")
        XCTAssert(individual1 != individual2, "Error in equality")
    }
}