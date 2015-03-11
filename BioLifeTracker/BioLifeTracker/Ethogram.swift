//
//  Ethogram.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Ethogram {
    var name: String
    var createdTime: NSDate
    var creator: User
    var behaviourStates: [BehaviourState] = []
    var id: String?
    
    init() {
        self.name = Constants.Default.ethogramName
        self.createdTime = NSDate()
        self.creator = Data.currentUser
        self.id = generateEthogramId()
    }
    
    init(name: String) {
        self.name = name
        self.createdTime = NSDate()
        self.creator = Data.currentUser
        self.id = generateEthogramId()
    }
    
    func generateEthogramId() -> String {
        return Constants.CodePrefixes.ethogram + String(Data.ethograms.count + 1)
    }
}