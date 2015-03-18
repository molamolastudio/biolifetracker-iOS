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
    @NSManaged var typeValue: String
    @NSManaged var id: String?
    @NSManaged var observations: [Observation]
    @NSManaged var individuals: [Individual]
    
    // Calculated properties
    var type: SessionType {
        get {
            return SessionType(rawValue: typeValue)!
        }
        set(newType) {
            typeValue = newType.rawValue
        }
    }
    
    // Initializers
    private override init() {
        super.init()
    }
    
    convenience init(project: Project, type: SessionType) {
        self.init()
        self.project = project
        self.typeValue = type.rawValue
        self.id = generateSessionId()
        self.observations = []
        self.individuals = []
    }
    
    // static maker method
    class func makeDefault() -> Session {
        var session = Session()
        session.project = Project.makeDefault()
        session.type = .Focal
        session.id = session.generateSessionId()
        session.observations = []
        session.individuals = []
        return session
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