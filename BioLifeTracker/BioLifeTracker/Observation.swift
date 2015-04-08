//
//  Observation.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Observation: BiolifeModel {
    private var _session: Session!
    private var _state: BehaviourState
    private var _information: String
    private var _timestamp: NSDate
    private var _photo: UIImage?
    private var _individual: Individual
    private var _location: Location?
    private var _weather: Weather?

    private var _photoUrls = [String]()
    private var _notes: String
    var _creator: User { return createdBy }
    
    var session: Session! { get { return _session } }
    var state: BehaviourState { get { return _state } }
    var information: String { get { return _information } }
    var timestamp: NSDate { get { return _timestamp } }
    var photo: UIImage? { get { return _photo } }
    var individual: Individual { get { return _individual } }
    var location: Location? { get { return _location } }
    var weather: Weather? { get { return _weather } }
    var photoUrls: [String] { get { return _photoUrls } }
    var notes: String { get { return _notes } }
    
    init(session: Session, individual: Individual, state: BehaviourState, timestamp: NSDate, information: String) {
        self._session = session
        self._state = state
        self._timestamp = timestamp
        self._location = Location()
        self._weather = Weather()
        self._photoUrls = []
        self._notes = ""
        self._information = information
        self._individual = individual
        super.init()
    }
    
    init(session: Session, individual: Individual, state: BehaviourState, timestamp: NSDate, information: String, notes: String) {
        self._session = session
        self._state = state
        self._timestamp = timestamp
        self._notes = notes
        self._location = Location()
        self._weather = Weather()
        self._photoUrls = []
        self._information = information
        self._individual = individual
        super.init()
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
    
    func updatePhoto(photo: UIImage) {
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
    
    func addPhotoUrl(url: String) {
        self._photoUrls.append(url)
        updateObservation()
    }
    
    func removePhotoUrlAtIndex(index: Int) {
        self._photoUrls.removeAtIndex(index)
        updateObservation()
    }
    
    func updateNotes(notes: String) {
        self._notes = notes
        updateObservation()
    }
    
    private func updateObservation() {
        updatedBy = UserAuthService.sharedInstance.user
        updatedAt = NSDate()
    }
    
    
    required init(coder aDecoder: NSCoder) {
        var enumerator: NSEnumerator
        
        self._state = aDecoder.decodeObjectForKey("state") as BehaviourState
        self._timestamp = aDecoder.decodeObjectForKey("timestamp") as NSDate
        self._location = aDecoder.decodeObjectForKey("location") as? Location
        self._weather = aDecoder.decodeObjectForKey("weather") as? Weather
        
        let objectPhotoUrls: AnyObject = aDecoder.decodeObjectForKey("photoUrls")!
        enumerator = objectPhotoUrls.objectEnumerator()
        self._photoUrls = Array<String>()
        while true {
            let url = enumerator.nextObject() as String?
            if url == nil {
                break
            }
            
            self._photoUrls.append(url!)
        }
        
        self._notes = aDecoder.decodeObjectForKey("notes") as String
        self._individual = aDecoder.decodeObjectForKey("individual") as Individual
        self._information = aDecoder.decodeObjectForKey("information") as String
        super.init(coder: aDecoder)
    }
}


extension Observation: NSCoding {
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_session, forKey: "session")
        aCoder.encodeObject(_state, forKey: "state")
        aCoder.encodeObject(_timestamp, forKey: "timestamp")
        aCoder.encodeObject(_location, forKey: "location")
        aCoder.encodeObject(_weather, forKey: "weather")
        aCoder.encodeObject(_photoUrls, forKey: "photoUrls")
        aCoder.encodeObject(_notes, forKey: "notes")
        aCoder.encodeObject(_individual, forKey: "individual")
        aCoder.encodeObject(_information, forKey: "information")
    }
}

//extension Observation: CloudStorable {
//    class var classUrl: String { return "observation" }
//    func upload() { }
//    func getDependencies() -> [CloudStorable] { return [] }
//}