//
//  Weather.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 16/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Weather: BiolifeModel {
    var weather: String
    
    override init() {
        weather = ""
        super.init()
    }
    
    // static maker method
    class func makeDefault() -> Weather {
        var weather = Weather()
        return weather
    }
    
    required init(coder aDecoder: NSCoder) {
        self.weather = aDecoder.decodeObjectForKey("weather") as String
        super.init(coder: aDecoder)
    }
    
}


extension Weather: NSCoding {
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(weather, forKey: "weather")
    }
}