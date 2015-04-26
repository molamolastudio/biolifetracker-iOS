//
//  Project.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Maintained by Li Jia'En, Nicholette.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

///  This is a data model class for Project.
///  This class contains methods to initialise Project instances,
///  get and set instance attributes.
///  This class also contains methods to store and retrieve saved
///  Project instances to the disk.
class Project: BiolifeModel {
    static let ClassUrl = "projects"
    
    // Constants
    static let archivePrefix = "Project"
    static let nameKey = "name"
    static let ethogramKey = "ethogram"
    static let adminsKey = "admins"
    static let membersKey = "members"
    static let sessionsKey = "sessions"
    static let individualsKey = "individuals"
    static let sessionSetKey = "session_set"
    
    // Private attributes
    private var _name: String
    private var _ethogram: Ethogram
    private var _admins: [User]
    private var _members: [User]
    private var _sessions: [Session]
    private var _individuals: [Individual]
    
    // Accessors
    var name: String { get { return _name } }
    var ethogram: Ethogram { get { return _ethogram } }
    var admins: [User] { get { return _admins } }
    var members: [User] { get { return _members } }
    var sessions: [Session] { get { return _sessions } }
    var individuals: [Individual] { get { return _individuals } }
    
    /// This is the default initialiser of an empty Project
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
    }
    
    override init(dictionary: NSDictionary, recursive: Bool) {
        _name = dictionary[Project.nameKey] as! String
        if recursive {
            _ethogram = Ethogram(dictionary: dictionary[Project.ethogramKey] as! NSDictionary, recursive: true)
            _name = dictionary[Project.nameKey] as! String
            let memberInfos =  dictionary[Project.membersKey] as! [NSDictionary]
            _members = memberInfos.map { return User(dictionary: $0, recursive: true) }
            let adminInfos = dictionary[Project.adminsKey] as! [NSDictionary]
            _admins = adminInfos.map { return User(dictionary: $0, recursive: true) }
            let sessionInfos = dictionary[Project.sessionsKey] as! [NSDictionary]
            _sessions = sessionInfos.map { return Session(dictionary: $0, recursive: true) }
            let individualInfos = dictionary[Project.individualsKey] as! [NSDictionary]
            _individuals = individualInfos.map { return Individual(dictionary: $0, recursive: true) }
        } else {
            let manager = CloudStorageManager.sharedInstance
            _members = User.usersWithIds(dictionary[Project.membersKey] as! [Int])
            _admins = User.usersWithIds(dictionary[Project.adminsKey] as! [Int])
            _ethogram = Ethogram.ethogramWithId(dictionary[Project.ethogramKey] as! Int)
            let sessionIds = dictionary[Project.sessionSetKey] as! [Int]
            _sessions = sessionIds.map { Session.sessionWithId($0) }
            let individualIds = dictionary[Project.individualsKey] as! [Int]
            _individuals = individualIds.map {
                let individualInfo = manager.getItemForClass(Individual.ClassUrl, itemId: $0)
                return Individual(dictionary: individualInfo)
            }
        }
        super.init(dictionary: dictionary, recursive: recursive)
        sessions.map { $0.setProject(self) }
    }
    
    required convenience init(dictionary: NSDictionary) {
        self.init(dictionary: dictionary, recursive: false)
    }
    
    /// This function returns the index of the session.
    func getIndexOfSession(session: Session) -> Int? {
        for var i = 0; i < _sessions.count; i++ {
            if _sessions[i] == session {
                return i
            }
        }
        return nil
    }
    
    /// This function returns the display name of the project.
    func getDisplayName() -> String {
        return _name
    }
    
    
    // MARK: FUNCTIONS RELATED TO PROJECT
    
    
    /// This function updates the project name.
    func updateName(name: String) {
        self._name = name
        updateProject()
    }
    
    /// This function changes the ethogram used.
    func updateEthogram(ethogram: Ethogram) {
        self._ethogram = ethogram
        updateProject()
    }
    
    
    // MARK: FUNCTIONS RELATED TO ADMINS


    /// This function adds admin to the project if the admin is not previously
    /// contained in the project. Otherwise, does nothing. Also adds admin as member
    /// if he is not yet a member.
    func addAdmin(admin: User) {
        if !contains(admins, admin) {
            _admins.append(admin)
            updateProject()
        }
        addMember(admin) // admin must also be a member
        assert(contains(members, admin), "Admin must first be the member of a project")
        assert(contains(admins, admin))
    }
    
    /// This function removes the admin specified.
    func removeAdmin(admin: User) {
        _admins = _admins.filter { $0 != admin }
        updateProject()
        assert(!contains(admins, admin))
    }
    
    /// This function checks whether an admin exists. Returns true if the admin exists.
    func containsAdmin(user: User) -> Bool {
        for admin in admins {
            if admin == user {
                return true
            }
        }
        return false
    }
    
    
    // MARK: FUNCTIONS RELATED TO MEMBERS
    
    
    /// Adds member to the project if the member is not previously contained
    /// in the project. Otherwise, does nothing.
    func addMember(member: User) {
        if !contains(_members, member) {
            _members.append(member)
            updateProject()
        }
        assert(contains(members, member))
    }
    
    /// This function removes the specified member.
    func removeMember(member: User) {
        removeAdmin(member) // non-member can't be admin
        _members = _members.filter { $0 != member }
        updateProject()
        assert(!contains(members, member))
        assert(!contains(admins, member))
    }
    
    // MARK: FUNCTIONS RELATED TO MEMBERS
    
    /// This function adds session to the project if the session is not previously
    /// contained in the project. Otherwise, does nothing.
    func addSession(session: Session) {
        _sessions.append(session)
        updateProject()
        assert(contains(sessions, session))
    }
    
    /// This function remove session from the project if the session is currently
    /// inside the project. Otherwise, does nothing.
    func removeSession(session: Session) {
        _sessions = _sessions.filter { $0 != session }
        updateProject()
    }
    
    /// This function is used to add sessions for testing.
    func addSessions(sessions: [Session]) {
        self._sessions += sessions
        updateProject()
    }
    
    /// This function updates the session at the specified index.
    func updateSession(index: Int, updatedSession: Session) {
        self._sessions.removeAtIndex(index)
        self._sessions.insert(updatedSession, atIndex: index)
        updateProject()
    }
    
    /// This function removes the specified sessions.
    func removeSessions(sessionIndexes: [Int]) {
        // sort indexes in non-increasing order
        var decreasingIndexes = sorted(sessionIndexes) { $0 > $1 }
        var prev = -1
        for (var i = 0; i < decreasingIndexes.count; i++) {
            let index = decreasingIndexes[i]
            if prev == index {
                continue;
            } else {
                prev = index
            }
            self._sessions.removeAtIndex(index)
        }
        updateProject()
    }
    
    
    // MARK: FUNCTIONS RELATED TO INDIVIDUALS
    
    
    /// This function add individuals to the project.
    func addIndividuals(individuals: [Individual]) {
        self._individuals += individuals
        updateProject()
    }
    
    /// This function updates the individuals in the project.
    func updateIndividual(index: Int, updatedIndividual: Individual) {
        self._individuals.removeAtIndex(index)
        self._individuals.insert(updatedIndividual, atIndex: index)
        updateProject()
    }
    
    /// This function removes individuals at the specified indexes.
    func removeIndividuals(individualIndexes: [Int]) {
        // sort indexes in non-increasing order
        var decreasingIndexes = sorted(individualIndexes) { $0 > $1 }
        var prev = -1
        for (var i = 0; i < decreasingIndexes.count; i++) {
            let index = decreasingIndexes[i]
            if prev == index {
                continue;
            } else {
                prev = index
            }
            self._individuals.removeAtIndex(index)
        }
        updateProject()
    }
    
    /// This is a private function to update the instance's createdAt, createdBy
    /// updatedBy and updatedAt.
    private func updateProject() {
        updateInfo(updatedBy: UserAuthService.sharedInstance.user, updatedAt: NSDate())
    }
    
    
    // MARK: FUNCTIONS RELATED TO DATA ANALYSIS
    
    
    /// This method gets the number of observations for each behaviour state
    /// and returns them in a dictionary.
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
    
    /// This function gets the observations with the specified sessions,
    /// users and behaviour states. It returns the observations in a dictionary.
    func getObservations(#sessions: [Session], users: [User],
                        behaviourStates: [BehaviourState]) -> [Observation] {
        
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
    
    /// This function gets the observations with the specified sessions.
    /// It returns the observations in a dictionary.
    func getObservations(selectedSessions: [Session]) -> [Observation] {
        var observations = [Observation]()
        for session in selectedSessions {
            observations += session.observations
        }
        
        return observations
    }
    
    
    // MARK: IMPLEMENTATION FOR NSKEYEDARCHIVER
    
    
    required init(coder aDecoder: NSCoder) {
        var enumerator: NSEnumerator

        self._name = aDecoder.decodeObjectForKey(
                                                Project.nameKey) as! String
        self._ethogram = aDecoder.decodeObjectForKey(
                                                Project.ethogramKey) as! Ethogram
        
        let objectAdmins: AnyObject = aDecoder.decodeObjectForKey(
                                                    Project.adminsKey)!
        enumerator = objectAdmins.objectEnumerator()
        self._admins = Array<User>()
        while true {
            let admin = enumerator.nextObject() as? User
            if admin == nil {
                break
            } else {
                self._admins.append(admin!)
            }
        }
        
        let objectMembers: AnyObject = aDecoder.decodeObjectForKey(
                                                    Project.membersKey)!
        enumerator = objectMembers.objectEnumerator()
        self._members = Array<User>()
        while true {
            let user = enumerator.nextObject() as? User
            if user == nil {
                break
            } else {
                self._members.append(user!)
            }
        }
        
        let objectSessions: AnyObject = aDecoder.decodeObjectForKey(
                                                    Project.sessionsKey)!
        enumerator = objectSessions.objectEnumerator()
        self._sessions = Array<Session>()
        var session: Session?
        while true {
            session = enumerator.nextObject() as? Session
            if session == nil {
                break
            }
            self._sessions.append(session!)
        }
        
        let objectIndividuals: AnyObject = aDecoder.decodeObjectForKey(
                                                    Project.individualsKey)!
        enumerator = objectIndividuals.objectEnumerator()
        self._individuals = Array<Individual>()
        var individual: Individual?
        while true {
            individual = enumerator.nextObject() as? Individual
            if individual == nil {
                break
            }
            self._individuals.append(individual!)
        }
        
        super.init(coder: aDecoder)
        
        for session in self._sessions {
            session.setProject(self)
        }
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_name, forKey: Project.nameKey)
        aCoder.encodeObject(_ethogram, forKey: Project.ethogramKey)
        aCoder.encodeObject(_admins, forKey: Project.adminsKey)
        aCoder.encodeObject(_members, forKey: Project.membersKey)
        aCoder.encodeObject(_sessions, forKey: Project.sessionsKey)
        aCoder.encodeObject(_individuals, forKey: Project.individualsKey)
    }
}

/// This function checks for Project equality.
func ==(lhs: Project, rhs: Project) -> Bool {
    if lhs.name != rhs.name { return false }
    if lhs.ethogram != rhs.ethogram { return false }
    if lhs.admins.count != rhs.admins.count { return false }
    if lhs.members.count != rhs.members.count { return false }
    if lhs.sessions.count != rhs.sessions.count { return false }
    if lhs.individuals.count != rhs.individuals.count { return false }
    return true
}

/// This function checks for Project inequality.
func !=(lhs: Project, rhs: Project) -> Bool {
    return !(lhs == rhs)
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
        dictionary.setValue(name, forKey: Project.nameKey)
        dictionary.setValue(sessions.map { $0.id! }, forKey: Project.sessionSetKey)
        dictionary.setValue(ethogram.id!, forKey: Project.ethogramKey)
        dictionary.setValue(members.map { $0.id }, forKey: Project.membersKey)
        dictionary.setValue(admins.map { $0.id }, forKey: Project.adminsKey)
        dictionary.setValue(individuals.map { $0.id! }, forKey: Project.individualsKey)
    }
}

extension Project {
    override func encodeRecursivelyWithDictionary(dictionary: NSMutableDictionary) {
        // simple properties 
        dictionary.setValue(name, forKey: Project.nameKey)
        
        // complex properties
        var membersArray = [NSDictionary]()
        for member in members {
            var memberDictionary = NSMutableDictionary()
            member.encodeRecursivelyWithDictionary(memberDictionary)
            membersArray.append(memberDictionary)
        }
        dictionary.setValue(membersArray, forKey: Project.membersKey)
        
        var adminsArray = [NSDictionary]()
        for admin in admins {
            var adminDictionary = NSMutableDictionary()
            admin.encodeRecursivelyWithDictionary(adminDictionary)
            adminsArray.append(adminDictionary)
        }
        dictionary.setValue(adminsArray, forKey: Project.adminsKey)
        
        var sessionsArray = [NSDictionary]()
        for session in sessions {
            var sessionDictionary = NSMutableDictionary()
            session.encodeRecursivelyWithDictionary(sessionDictionary)
            sessionsArray.append(sessionDictionary)
        }
        dictionary.setValue(sessionsArray, forKey: Project.sessionsKey)

        var ethogramDictionary = NSMutableDictionary()
        ethogram.encodeRecursivelyWithDictionary(ethogramDictionary)
        dictionary.setValue(ethogramDictionary, forKey: Project.ethogramKey)

        var individualsArray = [NSDictionary]()
        for individual in individuals {
            var individualDictionary = NSMutableDictionary()
            individual.encodeRecursivelyWithDictionary(individualDictionary)
            individualsArray.append(individualDictionary)
        }
        dictionary.setValue(individualsArray, forKey: Project.individualsKey)
        
        super.encodeRecursivelyWithDictionary(dictionary)
    }
}
