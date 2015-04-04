//
//  LocationTests.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 4/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import XCTest

class LocationTests: XCTestCase {
    var location = Location(location: "Simei")
    
    func testReadLocation() {
        XCTAssert(location.location == "Simei", "Location not initialised properly")
    }
    
    func testUpdateWeather() {
        location.updateLocation("Kent Ridge")
        XCTAssert(location.location == "Kent Ridge", "Location not updated properly")
    }
}