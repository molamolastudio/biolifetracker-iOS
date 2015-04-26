//
//  Weather.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 16/3/15.
//  Maintained by Li Jia'En, Nicholette.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

//  This is a data model class for Weather.
//  This class contains methods to initialise Weather instances,
//  get and set instance attributes.
//  This class also contains methods to store and retrieve saved
//  Weather instances to the disk.
class Weather: BiolifeModel {
    // Constants
    static let weatherKey = "weather"
    
    static let ClassUrl = "weathers"
    
    // Private Attributes
    private var _weather: String
    
    // Accessor
    var weather: String { get { return _weather } }
    
    override init() {
        _weather = ""
        super.init()
    }
    
    convenience init(weather: String) {
        self.init()
        self._weather = weather
    }
    
    override init(dictionary: NSDictionary, recursive: Bool) {
        _weather = dictionary[Weather.weatherKey] as! String
        super.init(dictionary: dictionary, recursive: recursive)
    }
    
    required convenience init(dictionary: NSDictionary) {
        self.init(dictionary: dictionary, recursive: false)
    }
    
    /// This function updates the weather.
    func updateWeather(weather: String) {
        self._weather = weather
        updateWeather()
    }
    
    /// This is a private function to update the instance's createdAt, createdBy
    /// updatedBy and updatedAt.
    private func updateWeather() {
        updateInfo(updatedBy: UserAuthService.sharedInstance.user, updatedAt: NSDate())
    }
    
    
    // MARK: IMPLEMENTATION OF NSKEYEDARCHIVAL
    
    
    required init(coder aDecoder: NSCoder) {
        self._weather = aDecoder.decodeObjectForKey(Weather.weatherKey) as! String
        super.init(coder: aDecoder)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_weather, forKey: Weather.weatherKey)
    }
}

/// This function checks for weather equality.
func ==(lhs: Weather, rhs: Weather) -> Bool {
    if lhs.weather != rhs.weather { return false }
    return true
}

/// This function checks for weather inequality.
func !=(lhs: Weather, rhs: Weather) -> Bool {
    return !(lhs == rhs)
}

extension Weather: CloudStorable {
    var classUrl: String { return Weather.ClassUrl }
    
    func getDependencies() -> [CloudStorable] {
        return []
    }
    
    override func encodeWithDictionary(dictionary: NSMutableDictionary) {
        dictionary.setValue(weather, forKey: Weather.weatherKey)
        super.encodeWithDictionary(dictionary)
    }
}

extension Weather {
    override func encodeRecursivelyWithDictionary(dictionary: NSMutableDictionary) {
        dictionary.setValue(weather, forKey: Weather.weatherKey)
        super.encodeRecursivelyWithDictionary(dictionary)
    }
}