//
//  Ethogram.swift
//  Mockups
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Ethogram {
    var name: String
    var createdTime: NSDate
    var creator: String
    var behaviourStates: [BehaviourState] = []
    var id: String?
    
    init(name: String, createdTime: NSDate, creator: String) {
        self.name = name
        self.createdTime = createdTime
        self.creator = creator
        self.id = generateEthogramId()
    }
    
    func generateEthogramId() -> String {
        return Constants.CodePrefixes.ethogram + String(Data.ethograms.count + 1)
    }
}