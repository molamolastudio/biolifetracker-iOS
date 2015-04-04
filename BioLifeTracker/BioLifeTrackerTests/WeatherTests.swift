//
//  WeatherTests.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 4/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import XCTest

class WeatherTests: XCTestCase {
    var weather = Weather(weather: "Rainy")
    
    func testReadWeather() {
        XCTAssert(weather.weather == "Rainy", "Weather not initialised properly")
    }
    
    func testUpdateWeather() {
        weather.updateWeather("Cloudy")
        XCTAssert(weather.weather == "Cloudy", "Weather not updated properly")
    }
}