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
    var name: String { get { return _name } }
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
    
    required convenience init(dictionary: NSDictionary) {
        self.init(dictionary: dictionary, recursive: false)
    }
    
    override init(dictionary: NSDictionary, recursive: Bool) {
        _name = dictionary["name"] as! String
        
        let sessionType = dictionary["session_type"] as! String
        assert(sessionType == "SCN" || sessionType == "FCL")
        _typeValue = sessionType
        
        if recursive {
            let observationInfos = dictionary["observation_set"] as! [NSDictionary]
            _observations = observationInfos.map { Observation(dictionary: $0, recursive: true) }
            let individualInfos = dictionary["individuals"] as! [NSDictionary]
            _individuals = individualInfos.map { Individual(dictionary: $0, recursive: true) }
        } else {
            let manager = CloudStorageManager.sharedInstance
            let observationIds = dictionary["observation_set"] as! [Int]
            _observations = observationIds.map { Observation.observationWithId($0) }
            let individualIds = dictionary["individuals"] as! [Int]
            _individuals = individualIds.map { manager.getIndividualWithId($0) }
        }
        super.init(dictionary: dictionary, recursive: recursive)
        _observations.map { $0.setSession(self) }
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
    
    func getTimestamps() -> [NSDate] {
        var timestamps: [NSDate] = []
        var duplicate: Bool
        
        for observation in observations {
            duplicate = false
            for timestamp in timestamps {
                if observation.timestamp == timestamp {
                    duplicate = true
                    break
                }
            }
            if !duplicate {
                timestamps.append(observation.timestamp)
            }
        }
        
        var sortedTimestamps = sorted(timestamps, { (left: NSDate, right: NSDate) -> Bool in left.compare(right) == NSComparisonResult.OrderedAscending })
        
        return sortedTimestamps
    }
    
    func getObservationsByTimestamp(timestamp: NSDate) -> [Observation] {
        var selectedObs = [Observation]()
        
        for observation in observations {
            if observation.timestamp == timestamp {
                selectedObs.append(observation)
            }
        }
        return selectedObs
    }
    
    private func sortDates(date1: String, date2: String) -> Bool {
        return date1 > date2
    }
    
    func getAllObservationsForIndividual(individual: Individual) -> [Observation] {
        var selectedObs = [Observation]()
        
        for observation in observations {
            if observation.individual == individual {
                selectedObs.append(observation)
            }
        }
        return selectedObs
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
    
    class func sessionWithId(id: Int) -> Session {
        let manager = CloudStorageManager.sharedInstance
        let sessionDictionary = manager.getItemForClass(ClassUrl, itemId: id)
        return Session(dictionary: sessionDictionary)
    }
}

func ==(lhs: Session, rhs: Session) -> Bool {
    if lhs.project != rhs.project { return false }
    if lhs.observations.count != rhs.observations.count { return false }
    if lhs.individuals.count != rhs.individuals.count { return false }
    return true
}

func !=(lhs: Session, rhs: Session) -> Bool {
    return !(lhs == rhs)
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
        observations.map { dependencies.append($0) }
        individuals.map { dependencies.append($0) }
        return dependencies
    }
    
    override func encodeWithDictionary(dictionary: NSMutableDictionary) {
        dictionary.setValue(project.id, forKey: "project")
        dictionary.setValue(observations.map { $0.id! }, forKey: "observation_set")
        dictionary.setValue(_typeValue, forKey: "session_type")
        dictionary.setValue(individuals.map { $0.id! }, forKey: "individuals")
        dictionary.setValue(name, forKey: "name")
        super.encodeWithDictionary(dictionary)
    }
}

extension Session {
    override func encodeRecursivelyWithDictionary(dictionary: NSMutableDictionary) {
        // simple properties
        dictionary.setValue(_typeValue, forKey: "session_type")
        dictionary.setValue(name, forKey: "name")
        
        // complex properties
        var observationsArray = [NSDictionary]()
        for observation in observations {
            var observationDictionary = NSMutableDictionary()
            observation.encodeRecursivelyWithDictionary(observationDictionary)
            observationsArray.append(observationDictionary)
        }
        dictionary.setValue(observationsArray, forKey: "observation_set")

        var individualsArray = [NSDictionary]()
        for individual in individuals {
            var individualDictionary = NSMutableDictionary()
            individual.encodeRecursivelyWithDictionary(individualDictionary)
            individualsArray.append(individualDictionary)
        }
        dictionary.setValue(individualsArray, forKey: "individuals")
        
        super.encodeRecursivelyWithDictionary(dictionary)
    }
}
