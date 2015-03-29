//
//  Observation.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Observation: NSObject, NSCoding {
    var session: Session!
    var state: BehaviourState!
    var timestamp: NSDate!
    var location: Location?
    var weather: Weather?
    var creator: User!
    var photoUrls: [String]!
    var notes: String!
    var individual: Individual!
    
    override init() {
        super.init()
    }
    
    convenience init(session: Session, state: BehaviourState, timestamp: NSDate, creator: User) {
        self.init()
        self.session = session
        self.state = state
        self.timestamp = timestamp
        self.creator = creator
        self.location = Location.makeDefault()
        self.weather = Weather.makeDefault()
        self.photoUrls = []
        self.notes = ""
        self.individual = Individual.makeDefault()
        
    }
    
    convenience init(session: Session, state: BehaviourState, timestamp: NSDate, creator: User, notes: String) {
        self.init()
        self.session = session
        self.state = state
        self.timestamp = timestamp
        self.creator = creator
        self.notes = notes
        self.location = Location.makeDefault()
        self.weather = Weather.makeDefault()
        self.photoUrls = []
        self.individual = Individual.makeDefault()
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
//        return "Session"
//    }
    
    required init(coder aDecoder: NSCoder) {
        
        var enumerator: NSEnumerator
        
        self.session = aDecoder.decodeObjectForKey("session") as Session
        self.state = aDecoder.decodeObjectForKey("state") as BehaviourState
        self.timestamp = aDecoder.decodeObjectForKey("timestamp") as NSDate
        self.location = aDecoder.decodeObjectForKey("location") as? Location
        self.weather = aDecoder.decodeObjectForKey("weather") as? Weather
        self.creator = aDecoder.decodeObjectForKey("creator") as User
        
        let objectPhotoUrls: AnyObject = aDecoder.decodeObjectForKey("photoUrls")!
        enumerator = objectPhotoUrls.objectEnumerator()
        self.photoUrls = Array<String>()
        while true {
            let url = enumerator.nextObject() as String?
            if url == nil {
                break
            }
            
            self.photoUrls.append(url!)
        }
        
        self.notes = aDecoder.decodeObjectForKey("notes") as String
        self.individual = aDecoder.decodeObjectForKey("individual") as Individual
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(session, forKey: "session")
        aCoder.encodeObject(state, forKey: "state")
        aCoder.encodeObject(timestamp, forKey: "timestamp")
        aCoder.encodeObject(location, forKey: "location")
        aCoder.encodeObject(weather, forKey: "weather")
        aCoder.encodeObject(creator, forKey: "creator")
        aCoder.encodeObject(photoUrls, forKey: "photoUrls")
        aCoder.encodeObject(notes, forKey: "notes")
        aCoder.encodeObject(individual, forKey: "individual")
    }
}