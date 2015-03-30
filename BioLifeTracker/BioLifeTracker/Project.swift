//
//  Project.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Project: BiolifeModel {
    var name: String
    var ethogram: Ethogram
    var admins: [User]
    var members: [User]
    var sessions: [Session]
    var individuals: [Individual]
    
    // Default initializer
    override init() {
        name = ""
        admins = [Data.currentUser]
        members = [Data.currentUser]
        ethogram = Ethogram()
        sessions = []
        individuals = []
        super.init()
    }
    
    convenience init(name: String, ethogram: Ethogram) {
        self.init()
        self.name = name
        self.ethogram = ethogram
        self.admins = [Data.currentUser]
        self.members = [Data.currentUser]
        self.sessions = []
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
        let path = dir.stringByAppendingPathComponent("Project")
        let data = NSMutableData(contentsOfFile: path)?
        
        if data == nil {
            return nil
        }
        
        let archiver = NSKeyedUnarchiver(forReadingWithData: data!)
        let ethogram = archiver.decodeObjectForKey(identifier)! as Project
    
        return ethogram
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
