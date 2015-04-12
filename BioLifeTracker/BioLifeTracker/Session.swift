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
    static let ClassUrl = "sessions"
    
    // Stored properties
    private var _name: String
    private var _project: Project!
    private var _typeValue: String
    private var _observations: [Observation]
    private var _individuals: [Individual]
    
    var type: SessionType { return SessionType(rawValue: _typeValue)! }
    
    var project: Project { get { return _project } }
    var observations: [Observation] { get { return _observations } }
    var individuals: [Individual] { get { return _individuals } }
    
    init(project: Project, name: String, type: SessionType) {
        self._name = name
        self._project = project
        self._typeValue = type.rawValue
        self._observations = []
        self._individuals = []
        super.init()
    }
    
    required override init(dictionary: NSDictionary) {
        //read data from dictionary
        super.init(dictionary: dictionary)
    }
    
    func getDisplayName() -> String {
        return self._name
    }
    
    /******************Observation*******************/
    
    // To be called by Project instance during decoding
    func setProject(project: Project) {
        self._project = project
    }
    
    func updateName(name: String) {
        self._name = name
    }
    
    func addObservation(observations: [Observation]) {
        self._observations += observations
        updateSession()
    }

    func updateObservation(index: Int, updatedObservation: Observation) {
        self._observations.removeAtIndex(index)
        self._observations.insert(updatedObservation, atIndex: index)
        updateSession()
    }
    
    func removeObservations(observationIndexes: [Int]) {
        for index in observationIndexes {
            self._observations.removeAtIndex(index)
        }
        updateSession()
    }
    
    /******************Individual*******************/
    func addIndividuals(individuals: [Individual]) {
        self._individuals += individuals
        updateSession()
    }
    
    func updateIndividual(index: Int, updatedIndividual: Individual) {
        self._individuals.removeAtIndex(index)
        self._individuals.insert(updatedIndividual, atIndex: index)
        updateSession()
    }
    
    func removeIndividuals(individualIndexes: [Int]) {
        for index in individualIndexes {
            self._individuals.removeAtIndex(index)
        }
        updateSession()
    }
    
    private func updateSession() {
        updateInfo(updatedBy: UserAuthService.sharedInstance.user, updatedAt: NSDate())
    }

    required init(coder aDecoder: NSCoder) {
        var enumerator: NSEnumerator
        
        self._typeValue = aDecoder.decodeObjectForKey("typeValue") as! String
        self._name = aDecoder.decodeObjectForKey("name") as! String
        
        let objectObservations: AnyObject = aDecoder.decodeObjectForKey("observations")!
        enumerator = objectObservations.objectEnumerator()
        self._observations = Array<Observation>()
        while true {
            var observation = enumerator.nextObject() as! Observation?
            if observation == nil {
                break
            }
            self._observations.append(observation!)
        }
        
        let objectIndividuals: AnyObject = aDecoder.decodeObjectForKey("individuals")!
        enumerator = objectIndividuals.objectEnumerator()
        self._individuals = Array<Individual>()
        
        while true {
            let individual = enumerator.nextObject() as! Individual?
            if individual == nil {
                break
            }
            self._individuals.append(individual!)
        }
        super.init(coder: aDecoder)
        
        for observation in self._observations {
            observation.setSession(self)
        }
    }
}

func ==(lhs: Session, rhs: Session) -> Bool {
    return lhs.project == rhs.project &&  lhs.observations == rhs.observations
            && lhs.individuals == rhs.individuals
}


extension Session: NSCoding {
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        // project attribute is allocated when project is initialized
        aCoder.encodeObject(_typeValue, forKey: "typeValue")
        aCoder.encodeObject(_name, forKey: "name")
        aCoder.encodeObject(_observations, forKey: "observations")
        aCoder.encodeObject(_individuals, forKey: "individuals")
    }
}


extension Session: CloudStorable {
    var classUrl: String { return Session.ClassUrl }
    
    func getDependencies() -> [CloudStorable] {
        var dependencies = [CloudStorable]()
        // append dependencies here
        return dependencies
    }
    
    override func encodeWithDictionary(dictionary: NSMutableDictionary) {
        super.encodeWithDictionary(dictionary)
        // write data here
    }
}
