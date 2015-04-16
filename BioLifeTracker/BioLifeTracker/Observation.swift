//
//  Observation.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Observation: BiolifeModel {
    static let ClassUrl = "observations"
    
    private var _session: Session!
    private var _state: BehaviourState
    private var _information: String
    private var _timestamp: NSDate
    private var _photo: Photo?
    private var _individual: Individual
    private var _location: Location?
    private var _weather: Weather?
    
    var session: Session! { get { return _session } }
    var state: BehaviourState { get { return _state } }
    var information: String { get { return _information } }
    var timestamp: NSDate { get { return _timestamp } }
    var photo: Photo? { get { return _photo } }
    var individual: Individual { get { return _individual } }
    var location: Location? { get { return _location } }
    var weather: Weather? { get { return _weather } }
    
    init(session: Session, individual: Individual, state: BehaviourState, timestamp: NSDate, information: String) {
        self._session = session
        self._state = state
        self._timestamp = timestamp
        self._location = Location()
        self._weather = Weather()
        self._information = information
        self._individual = individual
        super.init()
    }
    
    override init(dictionary: NSDictionary, recursive: Bool) {
        //read data from dictionary
        let dateFormatter = BiolifeDateFormatter()
        _information = dictionary["information"] as! String
        _timestamp = dateFormatter.getDate(dictionary["timestamp"] as! String)
        if recursive {
            let stateInfo = dictionary["recorded_behaviour"] as! NSDictionary
            _state = BehaviourState(dictionary: stateInfo, recursive: true)
            let individualInfo = dictionary["individual"] as! NSDictionary
            _individual = Individual(dictionary: individualInfo, recursive: true)
            let locationInfo = dictionary["location"] as! NSDictionary
            _location = Location(dictionary: locationInfo, recursive: true)
            let weatherInfo = dictionary["weather"] as! NSDictionary
            _weather = Weather(dictionary: weatherInfo, recursive: true)
        } else {
            _state = BehaviourState.behaviourStateWithId(dictionary["recorded_behaviour"] as! Int)
            _individual = Individual.individualWithId(dictionary["individual"] as! Int)
            if let locationId = dictionary["location"] as? Int {
                _location = Location.locationWithId(locationId)
            }
            if let weatherId = dictionary["weather"] as? Int {
                _weather = Weather.weatherWithId(weatherId)
            }
        }
        super.init(dictionary: dictionary, recursive: recursive)
    }
    
    required convenience init(dictionary: NSDictionary) {
        self.init(dictionary: dictionary, recursive: false)
    }
    
    /************Observation***************/
    
    // To be called by Session instance during decoding
    func setSession(session: Session) {
        self._session = session
    }
    
    func changeBehaviourState(state: BehaviourState) {
        self._state = state
        updateObservation()
    }
    
    func updateInformation(information: String) {
        self._information = information
        updateObservation()
    }
    
    func updatePhoto(photo: Photo?) {
        self._photo = photo
        updateObservation()
    }
    
    func changeIndividual(individual: Individual) {
        self._individual = individual
        updateObservation()
    }
    
    func changeLocation(location: Location) {
        self._location = location
        updateObservation()
    }
    
    func changeWeather(weather: Weather) {
        self._weather = weather
        updateObservation()
    }
    
    private func updateObservation() {
        updateInfo(updatedBy: UserAuthService.sharedInstance.user, updatedAt: NSDate())
    }
    
    required init(coder aDecoder: NSCoder) {
        var enumerator: NSEnumerator
        
        self._state = aDecoder.decodeObjectForKey("state") as! BehaviourState
        self._timestamp = aDecoder.decodeObjectForKey("timestamp") as! NSDate
        self._location = aDecoder.decodeObjectForKey("location") as? Location
        self._weather = aDecoder.decodeObjectForKey("weather") as? Weather
        self._individual = aDecoder.decodeObjectForKey("individual") as! Individual
        self._information = aDecoder.decodeObjectForKey("information") as! String
        super.init(coder: aDecoder)
    }
    
    class func observationWithId(id: Int) -> Observation {
        let manager = CloudStorageManager.sharedInstance
        let observationDictionary = manager.getItemForClass(ClassUrl, itemId: id)
        return Observation(dictionary: observationDictionary)
    }
}


func ==(lhs: Observation, rhs: Observation) -> Bool {
    return lhs.session == rhs.session &&
        lhs.state == rhs.state &&
        lhs.information == rhs.information &&
        lhs.timestamp == rhs.timestamp &&
        lhs.photo == rhs.photo &&
        lhs.individual == rhs.individual &&
        lhs.location == rhs.location &&
        lhs.weather == rhs.weather
}

func !=(lhs: Observation, rhs: Observation) -> Bool {
    return !(lhs == rhs)
}


extension Observation: NSCoding {
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_session, forKey: "session")
        aCoder.encodeObject(_state, forKey: "state")
        aCoder.encodeObject(_timestamp, forKey: "timestamp")
        aCoder.encodeObject(_location, forKey: "location")
        aCoder.encodeObject(_weather, forKey: "weather")
        aCoder.encodeObject(_individual, forKey: "individual")
        aCoder.encodeObject(_information, forKey: "information")
    }
}


extension Observation: CloudStorable {
    var classUrl: String { return Observation.ClassUrl }
    
    func getDependencies() -> [CloudStorable] {
        var dependencies = [CloudStorable]()
        dependencies.append(state)
        if photo != nil { dependencies.append(photo!) }
        dependencies.append(individual)
        if location != nil { dependencies.append(location!) }
        if weather != nil { dependencies.append(weather!) }
        return dependencies
    }
    
    override func encodeWithDictionary(dictionary: NSMutableDictionary) {
        dictionary.setValue(state.id, forKey: "recorded_behaviour")
        dictionary.setValue(information, forKey: "information")
        dictionary.setValue(photo?.id, forKey: "photo")
        dictionary.setValue(timestamp.toBiolifeDateFormat(), forKey: "timestamp")
        dictionary.setValue(individual.id, forKey: "individual")
        dictionary.setValue(location?.id, forKey: "location")
        dictionary.setValue(weather?.id, forKey: "weather")
        super.encodeWithDictionary(dictionary)
    }
}

extension Observation {
    override func encodeRecursivelyWithDictionary(dictionary: NSMutableDictionary) {
        // simple properties
        dictionary.setValue(information, forKey: "information")
        dictionary.setValue(timestamp.toBiolifeDateFormat(), forKey: "timestamp")
        timestamp.toBiolifeDateFormat()
        // complex properties
        var stateDictionary = NSMutableDictionary()
        state.encodeRecursivelyWithDictionary(stateDictionary)
        dictionary.setValue(stateDictionary, forKey: "recorded_behaviour")
        
        var photoDictionary = NSMutableDictionary()
        photo?.encodeRecursivelyWithDictionary(dictionary)
        dictionary.setValue(photoDictionary, forKey: "photo")
        
        var individualDictionary = NSMutableDictionary()
        individual.encodeRecursivelyWithDictionary(individualDictionary)
        dictionary.setValue(individualDictionary, forKey: "individual")
        
        var locationDictionary = NSMutableDictionary()
        location?.encodeRecursivelyWithDictionary(locationDictionary)
        dictionary.setValue(locationDictionary, forKey: "location")

        var weatherDictionary = NSMutableDictionary()
        weather?.encodeRecursivelyWithDictionary(weatherDictionary)
        dictionary.setValue(weatherDictionary, forKey: "weather")
        
        super.encodeRecursivelyWithDictionary(dictionary)
    }
}
