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
        XCTAssert(individual.photoUrls.count == 0, "Individual not initialised properly")
    }
    
    func testUpdates() {
        individual.updateLabel("M3")
        XCTAssert(individual.label == "M3", "Individual not initialised properly")
        
        individual.addTag(Tag(tag: "Aggressive"))
        XCTAssert(individual.tags[0].tag == "Aggressive", "Individual not initialised properly")
        
        individual.addTag(Tag(tag: "Territorial"))
        XCTAssert(individual.tags[1].tag == "Territorial", "Individual not initialised properly")
        
        individual.removeTagAtIndex(0)
        XCTAssert(individual.tags[0].tag == "Territorial", "Individual not initialised properly")
        
        individual.addPhotoUrl("www.photo1.com")
        XCTAssert(individual.photoUrls[0] == "www.photo1.com", "Individual not initialised properly")
        
        individual.addPhotoUrl("www.photo2.com")
        XCTAssert(individual.photoUrls[1] == "www.photo2.com", "Individual not initialised properly")
        
        individual.removePhotoUrlAtIndex(0)
        XCTAssert(individual.photoUrls[0] == "www.photo2.com", "Individual not initialised properly")
    }
    
    func testEquality() {
        let individual1 = Individual(label: "M1")
        let individual2 = Individual(label: "F1")
        let individual3 = Individual(label: "M1")
        
        XCTAssert(individual1 == individual3, "Not equal")
        XCTAssert(individual1 != individual2, "Error in equality")
    }
}