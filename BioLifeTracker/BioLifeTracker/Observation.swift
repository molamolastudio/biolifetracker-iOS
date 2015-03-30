//
//  Observation.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Observation: BiolifeModel {
    var session: Session
    var state: BehaviourState
    var information: String
    var timestamp: NSDate
    var photo: UIImage?
    var individual: Individual
    var location: Location?
    var weather: Weather?
    
    @availability(iOS, deprecated=0.1, message="Use photo: NSImage instead")
    var photoUrls = [String]()
    @availability(iOS, deprecated=0.1, message="Use information instead")
    var notes: String
    @availability(iOS, deprecated=0.1, message="Use createdBy instead")
    var creator: User
    
    init(session: Session, state: BehaviourState, timestamp: NSDate, creator: User) {
        self.session = session
        self.state = state
        self.timestamp = timestamp
        self.creator = creator
        self.location = Location.makeDefault()
        self.weather = Weather.makeDefault()
        self.photoUrls = []
        self.notes = ""
        self.information = ""
        self.individual = Individual.makeDefault()
        super.init()
    }
    
    init(session: Session, state: BehaviourState, timestamp: NSDate, creator: User, notes: String) {
        self.session = session
        self.state = state
        self.timestamp = timestamp
        self.creator = creator
        self.notes = notes
        self.location = Location.makeDefault()
        self.weather = Weather.makeDefault()
        self.photoUrls = []
        self.information = ""
        self.individual = Individual.makeDefault()
        super.init()
    }
    
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
        self.information = aDecoder.decodeObjectForKey("information") as String
        super.init(coder: aDecoder)
    }
}


extension Observation: NSCoding {
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(session, forKey: "session")
        aCoder.encodeObject(state, forKey: "state")
        aCoder.encodeObject(timestamp, forKey: "timestamp")
        aCoder.encodeObject(location, forKey: "location")
        aCoder.encodeObject(weather, forKey: "weather")
        aCoder.encodeObject(creator, forKey: "creator")
        aCoder.encodeObject(photoUrls, forKey: "photoUrls")
        aCoder.encodeObject(notes, forKey: "notes")
        aCoder.encodeObject(individual, forKey: "individual")
        aCoder.encodeObject(information, forKey: "information")
    }
}
