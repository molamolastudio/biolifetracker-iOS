//
//  Weather.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 16/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Weather: NSObject, NSCoding {
    var weather: String!
    
    private override init() {
        super.init()
    }
    
    // static maker method
    class func makeDefault() -> Weather {
        var weather = Weather()
        return weather
    }
    
//    // Parse Object Subclassing Methods
//    override class func initialize() {
//        var onceToken: dispatch_once_t = 0
//        dispatch_once(&onceToken) {
//            self.registerSubclass()
//        }
//    }
//    
//    class func parseClassName() -> String {
//        return "Weather"
//    }
    
    required init(coder aDecoder: NSCoder) {
        self.weather = aDecoder.decodeObjectForKey("weather") as String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(weather, forKey: "weather")
    }
}