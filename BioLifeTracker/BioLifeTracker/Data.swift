//
//  Data.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

struct Data {
    static var isLoggedIn = false
    
    static var currentUser: User = User(id: "000", name: Constants.Default.userName)
    
    static var selectedProject: Project? = nil
    static var selectedEthogram: Ethogram? = nil
    static var selectedSession: Session? = nil
    
    static var projects: [Project] = []
    static var ethograms: [Ethogram] = []
}