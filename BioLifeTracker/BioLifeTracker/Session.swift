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

class Session: NSObject, NSCoding {
    // Stored properties
    var project: Project!
    var typeValue: String!
    var id: String?
    var observations: [Observation]!
    var individuals: [Individual]!
    
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
        
        self.project = aDecoder.decodeObjectForKey("project") as Project
        self.typeValue = aDecoder.decodeObjectForKey("typeValue") as String
        self.id = aDecoder.decodeObjectForKey("id") as String?
    
        let objectObservations: AnyObject = aDecoder.decodeObjectForKey("observations")!
        enumerator = objectObservations.objectEnumerator()
        self.observations = Array<Observation>()
        while true {
            let observation = enumerator.nextObject() as Observation?
            if observation == nil {
                break
            }
            self.observations.append(observation!)
        }
        
        let objectIndividuals: AnyObject = aDecoder.decodeObjectForKey("individuals")!
        enumerator = objectIndividuals.objectEnumerator()
        self.individuals = Array<Individual>()
        
        while true {
            let individual = enumerator.nextObject() as Individual?
            if individual == nil {
                break
            }
            self.individuals.append(individual!)
        }
        super.init()
    }

    func encodeWithCoder(aCoder: NSCoder) {
        // project attribute is allocated when project is initialized
        aCoder.encodeObject(typeValue, forKey: "typeValue")
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(observations, forKey: "observations")
        aCoder.encodeObject(individuals, forKey: "individuals")
    }

}

//  Returns true if `lhs` session is equal to `rhs` session.
func ==(lhs: Session, rhs: Session) -> Bool {
    return lhs.id == rhs.id
}