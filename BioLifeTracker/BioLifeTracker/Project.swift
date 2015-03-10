//
//  Project.swift
//  Mockups
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Project {
    let stringWith = " with "
    
    var name: String
    var animal: String
    var ethogram: String
    var createdTime: NSDate
    var creator: User
    var id: String?
    var members: [User] = []
    var sessions: [Session] = []
    
    init(name: String, animal: String, ethogram: String, createdTime: NSDate, creator: User) {
        self.name = name
        self.animal = animal
        self.ethogram = ethogram
        self.createdTime = createdTime
        self.creator = creator
        self.id = generateProjectId()
        self.members.append(creator)
    }
    
    func generateProjectId() -> String {
        return Constants.CodePrefixes.project + String(Data.projects.count + 1)
    }
    
    func getDisplayName() -> String {
        return name + stringWith + animal
    }
    
    func getIndexOfSession(session: Session) -> Int? {
        for var i = 0; i < sessions.count; i++ {
            if sessions[i] == session {
                return i
            }
        }
        return nil
    }
}