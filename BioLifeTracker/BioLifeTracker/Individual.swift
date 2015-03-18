//
//  Individual.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 16/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Individual: PFObject, PFSubclassing {
    @NSManaged var label: String
    @NSManaged var photoUrls: [String]
    @NSManaged var tags: [String]
    
    private override init() {
        super.init()
    }
    
    // static maker method
    class func makeDefault() -> Individual {
        var individual = Individual()
        individual.label = ""
        individual.photoUrls = []
        individual.tags = []
        return individual
    }
    
    // Parse Object Subclassing Methods
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    class func parseClassName() -> String {
        return "Individual"
    }
    
}