//
//  ProjectStub.swift
//  BioLifeTracker
//
//  Created by Haritha on 13/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation


class ProjectStub: Project {

    
    override init() {
        super.init()
        
    }

    var BS = ["Eating", "Sleeping", "Bathing", "Mating", "Yawning", "Playing", "Stalking"]
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getObservationsPerBS() -> [String : Int] {
        var BSDict = [ "Eating" : 32, "Sleeping": 15 , "Bathing": 9, "Mating": 24, "Yawning": 45, "Playing": 23, "Stalking": 37]
        return BSDict
    }
    
    override func getObservations(#sessions: [Session], users: [User], behaviourStates: [BehaviourState]) -> [Observation] {
        
    }
    
    
}