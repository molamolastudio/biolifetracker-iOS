//
//  Project.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Project: NSObject, NSCoding {
    var name: String!
    var ethogram: Ethogram!
    var admins: [User]!
    var members: [User]!
    var sessions: [Session]!
    
    // Default initializer
    private override init() {
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
    
    // static maker method
    class func makeDefault() -> Project {
        var project = Project()
        project.name = ""
        project.ethogram = Ethogram.makeDefault()
        project.admins = [Data.currentUser]
        project.members = [Data.currentUser]
        project.sessions = []
        return project
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
    
//    // Parse Object Subclassing Methods
//    override class func initialize() {
//        var onceToken: dispatch_once_t = 0
//        dispatch_once(&onceToken) {
//            self.registerSubclass()
//        }
//    }
//    
//    class func parseClassName() -> String {
//        return "Project"
//    }
    
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
        
        super.init()
        
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
        var session: Session

        while true {
            var session = enumerator.nextObject() as Session?
            
            if session == nil {
                break
            }
            session!.project = self
            
            self.sessions.append(session!)
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(ethogram, forKey: "ethogram")
        aCoder.encodeObject(admins, forKey: "admins")
        aCoder.encodeObject(members, forKey: "members")
        aCoder.encodeObject(sessions, forKey: "sessions")
    }

}