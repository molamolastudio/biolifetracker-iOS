//
//  Session.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

enum SessionType: String {
    case Focal = "FCL"
    case Scan = "SCN"
}

class Session: BiolifeModel {
    // Stored properties
    var project: Project
    var typeValue: String
    var observations: [Observation]
    var individuals: [Individual]
    
    var type: SessionType { return SessionType(rawValue: typeValue)! }
    
    init(project: Project, type: SessionType) {
        self.project = project
        self.typeValue = type.rawValue
        self.observations = []
        self.individuals = []
        super.init()
    }
    
    func getDisplayName() -> String {
        if let index = project.getIndexOfSession(self) {
            return type.rawValue + " " + String()
        }
        return ""
    }

    required init(coder aDecoder: NSCoder) {
        var enumerator: NSEnumerator
        
        self.project = aDecoder.decodeObjectForKey("project") as Project
        self.typeValue = aDecoder.decodeObjectForKey("typeValue") as String
    
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
        super.init(coder: aDecoder)
    }
}


extension Session: NSCoding {
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        // project attribute is allocated when project is initialized
        aCoder.encodeObject(typeValue, forKey: "typeValue")
        aCoder.encodeObject(observations, forKey: "observations")
        aCoder.encodeObject(individuals, forKey: "individuals")
    }
}

extension Session: CloudStorable {
    class var classUrl: String { return "session" }
    func upload() { }
    func getDependencies() -> [CloudStorable] { return [] }
}
