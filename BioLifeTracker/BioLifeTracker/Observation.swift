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
    
    required override init(dictionary: NSDictionary) {
        //read data from dictionary
        let dateFormatter = BiolifeDateFormatter()
        _state = BehaviourState.behaviourStateWithId(dictionary["recorded_behaviour"] as! Int)
        _information = dictionary["information"] as! String
        _timestamp = dateFormatter.getDate(dictionary["timestamp"] as! String)
        _individual = Individual.individualWithId(dictionary["individual"] as! Int)
        if let locationId = dictionary["location"] as! Int? {
            _location = Location.locationWithId(locationId)
        }
        if let weatherId = dictionary["weather"] as! Int? {
            _weather = Weather.weatherWithId(weatherId)
        }
        super.init(dictionary: dictionary)
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
        let dateFormatter = BiolifeDateFormatter()
        dictionary.setValue(session.id, forKey: "session")
        dictionary.setValue(state.id, forKey: "recorded_behaviour")
        dictionary.setValue(information, forKey: "information")
        dictionary.setValue(photo?.id, forKey: "photo")
        dictionary.setValue(dateFormatter.formatDate(timestamp), forKey: "timestamp")
        dictionary.setValue(individual.id, forKey: "individual")
        dictionary.setValue(location?.id, forKey: "location")
        dictionary.setValue(weather?.id, forKey: "weather")
        super.encodeWithDictionary(dictionary)
    }
}
