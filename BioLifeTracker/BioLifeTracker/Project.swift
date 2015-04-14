//
//  Project.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Project: BiolifeModel, Storable {
    static let ClassUrl = "projects"
    
    private var _name: String
    private var _ethogram: Ethogram
    private var _admins: [User]
    private var _members: [User]
    private var _sessions: [Session]
    private var _individuals: [Individual]
    
    var name: String { get { return _name } }
    var ethogram: Ethogram { get { return _ethogram } }
    var admins: [User] { get { return _admins } }
    var members: [User] { get { return _members } }
    var sessions: [Session] { get { return _sessions } }
    var individuals: [Individual] { get { return _individuals } }
    
    // Default initializer
    override init() {
        _name = ""
        _admins = [UserAuthService.sharedInstance.user]
        _members = [UserAuthService.sharedInstance.user]
        _ethogram = Ethogram()
        _sessions = []
        _individuals = []
        super.init()
    }
    
    convenience init(name: String, ethogram: Ethogram) {
        self.init()
        self._name = name
        self._ethogram = ethogram
        self._admins = [UserAuthService.sharedInstance.user]
        self._members = [UserAuthService.sharedInstance.user]
  //      self.saveToArchives()
    }
    
    required override init(dictionary: NSDictionary) {
        
        let manager = CloudStorageManager.sharedInstance
        _name = dictionary["name"] as! String
        _members = User.usersWithIds(dictionary["members"] as! [Int])
        _admins = User.usersWithIds(dictionary["admins"] as! [Int])
        _ethogram = Ethogram.ethogramWithId(dictionary["ethogram"] as! Int)
        let sessionIds = dictionary["session_set"] as! [Int]
        _sessions = sessionIds.map { Session.sessionWithId($0) }
        let individualIds = dictionary["individuals"] as! [Int]
        _individuals = individualIds.map { Individual.individualWithId($0) }
        super.init(dictionary: dictionary)
        
        sessions.map { $0.setProject(self) }
    }
    
    func getIndexOfSession(session: Session) -> Int? {
        for var i = 0; i < _sessions.count; i++ {
            if _sessions[i] == session {
                return i
            }
        }
        return nil
    }
    
    func getDisplayName() -> String {
        return _name
    }
    
    /******************Project*********************/
    func updateName(name: String) {
        // Project.deleteFromArchives(self._name)
        self._name = name
        updateProject()
    }
    
    func updateEthogram(ethogram: Ethogram) {
        self._ethogram = ethogram
        updateProject()
    }
    
    /********************Admins*******************/

    func addAdmins(admins: [User]) {
        self._admins += admins
        // Admins are naturally members of a project
        self._members += admins
        updateProject()
    }
    
    func removeAdmins(adminIndexes: [Int]) {
        for index in adminIndexes {
            self._admins.removeAtIndex(index)
        }
        updateProject()
    }
    
    /********************Members*******************/
    func addMembers(members: [User]) {
        self._members += members
        updateProject()
    }
    
    func removeMembers(memberIndexes: [Int]) {
        for index in memberIndexes {
            self._members.removeAtIndex(index)
        }
        updateProject()
    }
    
    /******************Session*******************/
    func addSessions(sessions: [Session]) {
        self._sessions += sessions
        updateProject()
    }
    
    func updateSession(index: Int, updatedSession: Session) {
        self._sessions.removeAtIndex(index)
        self._sessions.insert(updatedSession, atIndex: index)
        updateProject()
    }
    
    func removeSessions(sessionIndexes: [Int]) {
        for index in sessionIndexes {
            self._sessions.removeAtIndex(index)
        }
        updateProject()
    }
    
    /******************Individual*******************/
    func addIndividuals(individuals: [Individual]) {
        self._individuals += individuals
        updateProject()
    }
    
    func updateIndividual(index: Int, updatedIndividual: Individual) {
        self._individuals.removeAtIndex(index)
        self._individuals.insert(updatedIndividual, atIndex: index)
        updateProject()
    }
    
    func removeIndividuals(individualIndexes: [Int]) {
        for index in individualIndexes {
            self._individuals.removeAtIndex(index)
        }
        updateProject()
    }
    
    private func updateProject() {
        updateInfo(updatedBy: UserAuthService.sharedInstance.user, updatedAt: NSDate())
   //     self.saveToArchives()
    }
    
    /**************Methods for data analysis**************/
    func getObservationsPerBS() -> [String: Int] {
        var countBS = [String: Int]()
        let observations = getObservations(_sessions)
        
        // Initialise all behaviourStates
        for bs in _ethogram.behaviourStates {
            countBS[bs.name] = 0
        }
        
        // Count the occurrences of behaviourStates
        for obs in observations {
            countBS[obs.state.name] = countBS[obs.state.name]! + 1
        }
        
        return countBS
    }
    
    func getObservations(#sessions: [Session], users: [User], behaviourStates: [BehaviourState]) -> [Observation] {
        
        // Create dictionaries of queries for easier searching
        var userDict: [String: Bool] = toDictionary(users) { ($0.name, true) }
        var bsDict: [String: Bool] = toDictionary(behaviourStates) { ($0.name, true) }
        
        let observations = getObservations(sessions)
        var newObservations = [Observation]()
        for obs in observations {
            let userIsInside = userDict[obs.createdBy.name]
            let bsIsInside = bsDict[obs.state.name]
            if userIsInside != nil && bsIsInside != nil && userIsInside! &&
                bsIsInside! {
                    newObservations.append(obs)
            }
        }
        
        return newObservations
    }
    
    private func getObservations(selectedSessions: [Session]) -> [Observation] {
        var observations = [Observation]()
        for session in selectedSessions {
            observations += session.observations
        }
        
        return observations
    }
    
//    private func convertArrayToDict(array: [AnyObject]) -> [AnyObject:Boolean] {
//        var dictionary = [AnyObject:Boolean]()
//        for element in array {
//            dictionary[element] = true
//        }
//        return dictionary
//    }
    
    /**************Saving to Archives****************/
    func saveToArchives() {
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        
        if ((dirs) != nil) {
            let dir = dirs![0]; //documents directory
            let path = dir.stringByAppendingPathComponent("Project" + self._name);
            
            let data = NSMutableData();
            let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
            archiver.encodeObject(self, forKey: _name)
            archiver.finishEncoding()
            let success = data.writeToFile(path, atomically: true)
        }
    }
    
    class func loadFromArchives(identifier: String) -> NSObject? {
        
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        
        if (dirs == nil) {
            return nil
        }
        
        // documents directory
        let dir = dirs![0]
        let path = dir.stringByAppendingPathComponent("Project" + identifier)
        let data = NSMutableData(contentsOfFile: path)
        
        if data == nil {
            return nil
        }
        
        let archiver = NSKeyedUnarchiver(forReadingWithData: data!)
        let project = archiver.decodeObjectForKey(identifier) as! Project?
    
        return project
    }
    
    class func deleteFromArchives(identifier: String) -> Bool {
        
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        
        if (dirs == nil) {
            return false
        }
        
        // documents directory
        let dir = dirs![0]
        let path = dir.stringByAppendingPathComponent("Project" + identifier)
        
        // Delete the file and see if it was successful
        var error: NSError?
        let success :Bool = NSFileManager.defaultManager().removeItemAtPath(path, error: &error)
        
        if error != nil {
            println(error)
        }

        return success;
    }
    
    required init(coder aDecoder: NSCoder) {
        var enumerator: NSEnumerator

        self._name = aDecoder.decodeObjectForKey("name") as! String
        self._ethogram = aDecoder.decodeObjectForKey("ethogram") as! Ethogram
        
        let objectAdmins: AnyObject = aDecoder.decodeObjectForKey("admins")!
        enumerator = objectAdmins.objectEnumerator()
        self._admins = Array<User>()
        while true {
            let admin = enumerator.nextObject() as! User?
            if admin == nil {
                break
            } else {
                self._admins.append(admin!)
            }
        }
        
        let objectMembers: AnyObject = aDecoder.decodeObjectForKey("members")!
        enumerator = objectMembers.objectEnumerator()
        self._members = Array<User>()
        while true {
            let user = enumerator.nextObject() as! User?
            if user == nil {
                break
            } else {
                self._members.append(user!)
            }
        }
        
        let objectSessions: AnyObject = aDecoder.decodeObjectForKey("sessions")!
        enumerator = objectSessions.objectEnumerator()
        self._sessions = Array<Session>()
        var session: Session?
        while true {
            session = enumerator.nextObject() as! Session?
            if session == nil {
                break
            }
            self._sessions.append(session!)
        }
        
        let objectIndividuals: AnyObject = aDecoder.decodeObjectForKey("individuals")!
        enumerator = objectIndividuals.objectEnumerator()
        self._individuals = Array<Individual>()
        var individual: Individual?
        while true {
            individual = enumerator.nextObject() as! Individual?
            if session == nil {
                break
            }
            self._individuals.append(individual!)
        }
        
        super.init(coder: aDecoder)
        
        for session in self._sessions {
            session.setProject(self)
        }
    }
}

func ==(lhs: Project, rhs: Project) -> Bool {
    return lhs.name == rhs.name &&  lhs.ethogram == rhs.ethogram
        && lhs.admins == rhs.admins && lhs.members == rhs.members
        && lhs.sessions == rhs.sessions && lhs.individuals == rhs.individuals
}

extension Project: NSCoding {
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_name, forKey: "name")
        aCoder.encodeObject(_ethogram, forKey: "ethogram")
        aCoder.encodeObject(_admins, forKey: "admins")
        aCoder.encodeObject(_members, forKey: "members")
        aCoder.encodeObject(_sessions, forKey: "sessions")
        aCoder.encodeObject(_individuals, forKey: "individuals")
    }
}

// Taken from ijohnsmith's GitHub Gist
// https://gist.github.com/ijoshsmith/0c966b1752b9a5722e23
/// Creates a dictionary from an array with an optional entry
func toDictionary<E, K, V>(
    array:       [E],
    transformer: (element: E) -> (key: K, value: V)?)
    -> Dictionary<K, V>
{
    return array.reduce([:]) {
        (var dict, e) in
        if let (key, value) = transformer(element: e)
        {
            dict[key] = value
        }
        return dict
    }
}

extension Project: CloudStorable {
    var classUrl: String { return Project.ClassUrl }
    
    func getDependencies() -> [CloudStorable] {
        var dependencies = [CloudStorable]()
        dependencies.append(ethogram)
        sessions.map { dependencies.append($0) }
        individuals.map { dependencies.append($0) }
        return dependencies
    }
    
    override func encodeWithDictionary(dictionary: NSMutableDictionary) {
        super.encodeWithDictionary(dictionary)
        dictionary.setValue(name, forKey: "name")
        dictionary.setValue(sessions.map { $0.id! }, forKey: "session_set")
        dictionary.setValue(ethogram.id!, forKey: "ethogram")
        dictionary.setValue(members.map { $0.id }, forKey: "members")
        dictionary.setValue(admins.map { $0.id }, forKey: "admins")
        dictionary.setValue(individuals.map { $0.id! }, forKey: "individuals")
    }
    
}
