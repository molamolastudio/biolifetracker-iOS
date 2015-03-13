//
//  Ethogram.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//
import Foundation
import Parse

class Ethogram {
    var name: String
    var code: String
    var createdTime: NSDate
    var creator: User
    var behaviourStates: [BehaviourState] = []
    var id: String?
    
    init() {
        self.name = Constants.Default.ethogramName
        self.code = Constants.Default.ethogramCode
        self.createdTime = NSDate()
        self.creator = Data.currentUser
        self.id = generateEthogramId()
        self.code = self.id!
    }
    
    init(name: String, code: String) {
        self.name = name
        self.code = code
        self.createdTime = NSDate()
        self.creator = Data.currentUser
        self.id = generateEthogramId()
    }
    
    func generateEthogramId() -> String {
        return Constants.CodePrefixes.ethogram + String(Data.ethograms.count + 1)
    }
    
    func addBehaviourState(state: BehaviourState) {
        behaviourStates.append(state)
    }
}
