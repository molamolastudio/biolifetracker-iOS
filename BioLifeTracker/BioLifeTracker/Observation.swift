//
//  Observation.swift
//  Mockups
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Observation {
    var session: Session
    var state: BehaviourState
    var timestamp: NSDate
    var creator: User
    var notes: String?
    
    init(session: Session, state: BehaviourState, timestamp: NSDate, creator: User) {
        self.session = session
        self.state = state
        self.timestamp = timestamp
        self.creator = creator
    }
    
    init(session: Session, state: BehaviourState, timestamp: NSDate, creator: User, notes: String) {
        self.session = session
        self.state = state
        self.timestamp = timestamp
        self.creator = creator
        self.notes = notes
    }
}