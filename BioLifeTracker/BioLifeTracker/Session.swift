//
//  Session.swift
//  Mockups
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Session {
    enum SessionType: String {
        case Focal = "Focal Sampling"
        case Scan = "Scan Sampling"
    }
    
    var project: Project
    var type: SessionType
    var id: String?
    var observations: [Observation] = []
    
    init(project: Project, type: SessionType) {
        self.project = project
        self.type = type
        self.id = generateSessionId()
    }
    
    func generateSessionId() -> String {
        return Constants.CodePrefixes.session + String(project.sessions.count + 1)
    }
    
    func getDisplayName() -> String {
        if let index = project.getIndexOfSession(self) {
            return type.rawValue + " " + String()
        }
        return ""
    }
}

//  Returns true if `lhs` session is equal to `rhs` session.
func ==(lhs: Session, rhs: Session) -> Bool {
    return lhs.id == rhs.id
}