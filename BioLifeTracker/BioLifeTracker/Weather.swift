//
//  Weather.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 16/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Weather: BiolifeModel {
    private var _weather: String
    var weather: String {
        get { return _weather }
    }
    
    override init() {
        _weather = ""
        super.init()
    }
    
    convenience init(weather: String) {
        self.init()
        self._weather = weather
    }
    
    func updateWeather(weather: String) {
        self._weather = weather
        updateWeather()
    }
    
    private func updateWeather() {
        updateInfo(updatedBy: UserAuthService.sharedInstance.user, updatedAt: NSDate())
    }
    
    required init(coder aDecoder: NSCoder) {
        self._weather = aDecoder.decodeObjectForKey("weather") as String
        super.init(coder: aDecoder)
    }
    
}


extension Weather: NSCoding {
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_weather, forKey: "weather")
    }
}