//
//  Project.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Project: BiolifeModel, Storable {
    var name: String
    var ethogram: Ethogram
    var admins: [User]
    var members: [User]
    var sessions: [Session]
    var individuals: [Individual]
    
    // Default initializer
    override init() {
        name = ""
        admins = [UserAuthService.sharedInstance.user]
        members = [UserAuthService.sharedInstance.user]
        ethogram = Ethogram()
        sessions = []
        individuals = []
        super.init()
    }
    
    convenience init(name: String, ethogram: Ethogram) {
        self.init()
        self.name = name
        self.ethogram = ethogram
        self.admins = [UserAuthService.sharedInstance.user]
        self.members = [UserAuthService.sharedInstance.user]
        self.saveToArchives()
    }
    
    func getIndexOfSession(session: Session) -> Int? {
        for var i = 0; i < sessions.count; i++ {
            if sessions[i] == session {
                return i
            }
        }
        return nil
    }
    
    func getDisplayName() -> String {
        return name
    }
    
    /******************Project*********************/
    func updateName(name: String) {
        Project.deleteFromArchives(self.name)
        self.name = name
        updateProject()
    }
    
    func updateEthogram(ethogram: Ethogram) {
        self.ethogram = ethogram
        updateProject()
    }
    
    /********************Admins*******************/

    func addAdmins(admins: [User]) {
        self.admins += admins
        // Admins are naturally members of a project
        self.members += admins
        updateProject()
    }
    
    func deleteAdmins(adminIndexes: [Int]) {
        for index in adminIndexes {
            self.admins.removeAtIndex(index)
        }
        updateProject()
    }
    
    /********************Memberss*******************/
    func addMembers(members: [User]) {
        self.members += members
        updateProject()
    }
    
    func deleteMembers(memberIndexes: [Int]) {
        for index in memberIndexes {
            self.members.removeAtIndex(index)
        }
        updateProject()
    }
    
    /******************Session*******************/
    func addSessions(sessions: [Session]) {
        self.sessions += sessions
        updateProject()
    }
    
    func updateSession(index: Int, updatedSession: Session) {
        self.sessions.removeAtIndex(index)
        self.sessions.insert(updatedSession, atIndex: index)
        updateProject()
    }
    
    func deleteSessions(sessionIndexes: [Int]) {
        for index in sessionIndexes {
            self.sessions.removeAtIndex(index)
        }
        updateProject()
    }
    
    /******************Individual*******************/
    func addIndividuals(individuals: [Individual]) {
        self.individuals += individuals
        updateProject()
    }
    
    func updateIndividual(index: Int, updatedIndividual: Individual) {
        self.individuals.removeAtIndex(index)
        self.individuals.insert(updatedIndividual, atIndex: index)
        updateProject()
    }
    
    func deleteIndividuals(individualIndexes: [Int]) {
        for index in individualIndexes {
            self.individuals.removeAtIndex(index)
        }
        updateProject()
    }
    
    private func updateProject() {
        updatedBy = UserAuthService.sharedInstance.user
        updatedAt = NSDate()
        self.saveToArchives()
    }
    
    /**************Saving to Archives****************/
    func saveToArchives() {
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        
        if ((dirs) != nil) {
            let dir = dirs![0]; //documents directory
            let path = dir.stringByAppendingPathComponent("Project");
            
            let data = NSMutableData();
            let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
            archiver.encodeObject(self, forKey: name)
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
        let data = NSMutableData(contentsOfFile: path)?
        
        if data == nil {
            return nil
        }
        
        let archiver = NSKeyedUnarchiver(forReadingWithData: data!)
        let project = archiver.decodeObjectForKey(identifier) as Project?
    
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

        self.name = aDecoder.decodeObjectForKey("name") as String
        self.ethogram = aDecoder.decodeObjectForKey("ethogram") as Ethogram
        
        let objectAdmins: AnyObject = aDecoder.decodeObjectForKey("admins")!
        enumerator = objectAdmins.objectEnumerator()
        self.admins = Array<User>()
        while true {
            let admin = enumerator.nextObject() as User?
            if admin == nil {
                break
            } else {
                self.admins.append(admin!)
            }
        }
        
        let objectMembers: AnyObject = aDecoder.decodeObjectForKey("members")!
        enumerator = objectMembers.objectEnumerator()
        self.members = Array<User>()
        while true {
            let user = enumerator.nextObject() as User?
            if user == nil {
                break
            } else {
                self.members.append(user!)
            }
        }
        
        let objectSessions: AnyObject = aDecoder.decodeObjectForKey("sessions")!
        
        enumerator = objectSessions.objectEnumerator()
        
        self.sessions = Array<Session>()
        var session: Session?

        while true {
            session = enumerator.nextObject() as Session?
            
            if session == nil {
                break
            }

            self.sessions.append(session!)
        }
        
        let objectIndividuals: AnyObject = aDecoder.decodeObjectForKey("individuals")!
        
        enumerator = objectIndividuals.objectEnumerator()
        
        self.individuals = Array<Individual>()
        var individual: Individual?
        
        while true {
            individual = enumerator.nextObject() as Individual?
            
            if session == nil {
                break
            }
            
            self.individuals.append(individual!)
        }
        
        super.init(coder: aDecoder)
        
        for session in sessions {
            session.project = self
        }
    }
}

extension Project: NSCoding {
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(ethogram, forKey: "ethogram")
        aCoder.encodeObject(admins, forKey: "admins")
        aCoder.encodeObject(members, forKey: "members")
        aCoder.encodeObject(sessions, forKey: "sessions")
        aCoder.encodeObject(individuals, forKey: "individuals")
    }
}

extension Project: CloudStorable {
    class var classUrl: String { return "project" }
    func upload() { }
    func getDependencies() -> [CloudStorable] { return [] }
}

