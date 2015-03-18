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
    //@NSManaged var ethogram: Ethogram
    @NSManaged var photoUrls: [String]
    
    @availability(iOS, deprecated=0.1, message="use the given convenience init() instead")
    convenience init(name: String, id: Int) {
        self.init()
        self.id = id
        self.name = name
        self.information = ""
        self.photoUrls = []
    }
    
    convenience init(id: Int, name: String, information: String) {
        self.init()
        self.id = id
        self.name = name
        self.information = information
        self.photoUrls = []
    }
    
    private override init() {
        super.init()
        // do not initialize @NSManaged vars here,
        // or the program will crash.
    }
    
    // static maker method
    class func makeDefault() -> BehaviourState {
        var behaviourState = BehaviourState()
        behaviourState.id = 0
        behaviourState.name = ""
        behaviourState.information = ""
        behaviourState.photoUrls = []
        return behaviourState
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