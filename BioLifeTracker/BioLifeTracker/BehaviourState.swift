//
//  BehaviourState.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Edited by Andhieka Putra.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class BehaviourState: PFObject, PFSubclassing {
    @NSManaged var id: Int
    @NSManaged var name: String
    @NSManaged var information: String
    
    @availability(iOS, deprecated=0.1, message="use the given convenience init() instead")
    init(name: String, id: Int) {
        super.init()
        self.name = name
        self.id = id
        self.information = ""
    }
    
    convenience init(id: Int, name: String, information: String) {
        self.init()
        self.id = id
        self.name = name
        self.information = information
    }
    
    override init() {
        super.init()
    }
    
    // Parse Object Subclassing Methods
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    class func parseClassName() -> String {
        return "BehaviourState"
    }
    
}