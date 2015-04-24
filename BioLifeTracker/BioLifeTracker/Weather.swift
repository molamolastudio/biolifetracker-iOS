//
//  Weather.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 16/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Weather: BiolifeModel {
    static let ClassUrl = "weathers"
    
    private var _weather: String
    var weather: String { get { return _weather } }
    
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
        self._weather = aDecoder.decodeObjectForKey("weather") as! String
        super.init(coder: aDecoder)
    }
    
    override init(dictionary: NSDictionary, recursive: Bool) {
        _weather = dictionary["weather"] as! String
        super.init(dictionary: dictionary, recursive: recursive)
    }
    
    required convenience init(dictionary: NSDictionary) {
        self.init(dictionary: dictionary, recursive: false)
    }
    
}

func ==(lhs: Weather, rhs: Weather) -> Bool {
    if lhs.weather != rhs.weather { return false }
    return true
}

func !=(lhs: Weather, rhs: Weather) -> Bool {
    return !(lhs == rhs)
}

extension Weather: NSCoding {
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_weather, forKey: "weather")
    }
}

extension Weather: CloudStorable {
    var classUrl: String { return Weather.ClassUrl }
    
    func getDependencies() -> [CloudStorable] {
        return []
    }
    
    override func encodeWithDictionary(dictionary: NSMutableDictionary) {
        dictionary.setValue(weather, forKey: "weather")
        super.encodeWithDictionary(dictionary)
    }
}

extension Weather {
    override func encodeRecursivelyWithDictionary(dictionary: NSMutableDictionary) {
        dictionary.setValue(weather, forKey: "weather")
        super.encodeRecursivelyWithDictionary(dictionary)
    }
}