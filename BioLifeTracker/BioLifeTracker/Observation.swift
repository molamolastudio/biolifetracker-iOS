//
//  Observation.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Observation: PFObject, PFSubclassing {
    @NSManaged var session: Session
    @NSManaged var state: BehaviourState
    @NSManaged var timestamp: NSDate
    @NSManaged var location: Location
    @NSManaged var weather: Weather
    @NSManaged var creator: User
    @NSManaged var photoUrls: [String]
    @NSManaged var notes: String
    @NSManaged var individual: Individual
    
    private override init() {
        super.init()
    }
    
    // static maker method
    class func makeDefault() -> Observation {
        var observation = Observation()
        observation.session = Session.makeDefault()
        observation.state = BehaviourState.makeDefault()
        observation.timestamp = NSDate()
        observation.location = Location.makeDefault()
        observation.weather = Weather.makeDefault()
        observation.creator = Data.currentUser
        observation.photoUrls = []
        observation.notes = ""
        observation.individual = Individual.makeDefault()
        return observation
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
    
    // Parse Object Subclassing Methods
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    class func parseClassName() -> String {
        return "Session"
    }
    
}