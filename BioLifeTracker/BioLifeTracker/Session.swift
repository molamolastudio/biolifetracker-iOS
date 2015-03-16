//
//  Session.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

enum SessionType: String {
    case Focal = "Focal Sampling"
    case Scan = "Scan Sampling"
}

class Session: PFObject, PFSubclassing {
    // Stored properties
    @NSManaged var project: Project
    @NSManaged var type_value: String
    @NSManaged var id: String?
    @NSManaged var observations: [Observation]
    @NSManaged var individuals: [Individual]
    
    // Calculated properties
    var type: SessionType {
        return SessionType(rawValue: type_value)!
    }
    
    // Initializers
    override init() {
        super.init()
    }
    
    convenience init(project: Project, type: SessionType) {
        self.init()
        self.project = project
        self.type_value = type.rawValue
        self.id = generateSessionId()
    }
    
    func generateSessionId() -> String {
        return Constants.CodePrefixes.session + String(project.sessions.count + 1)
    }
    
    func getDisplayName() -> String {
        if let index = project.getIndexOfSession(self) {
            return type.rawValue + " " + String()
        }
        return ""
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

//  Returns true if `lhs` session is equal to `rhs` session.
func ==(lhs: Session, rhs: Session) -> Bool {
    return lhs.id == rhs.id
}