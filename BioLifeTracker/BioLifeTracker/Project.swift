//
//  Project.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Project: PFObject, PFSubclassing {
    @NSManaged var name: String
    @NSManaged var ethogram: Ethogram
    @NSManaged var admins: [User]
    @NSManaged var members: [User]
    @NSManaged var sessions: [Session]
    
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
    
    // Parse Object Subclassing Methods
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    class func parseClassName() -> String {
        return "Project"
    }

}