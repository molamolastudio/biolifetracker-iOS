//
//  Ethogram.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//
import Foundation

class Ethogram: PFObject, PFSubclassing {
    @NSManaged var name: String
    @NSManaged var creator: PFUser
    @NSManaged var behaviourStates: [BehaviourState]

    private override init() {
        super.init()
    }
    
    convenience init(name: String, code: String) {
        self.init()
        self.name = name
        self.creator = PFUser.currentUser()
        self.behaviourStates = []
    }
    
    // static maker method
    class func makeDefault() -> Ethogram {
        var ethogram = Ethogram()
        ethogram.name = ""
        ethogram.creator = PFUser.currentUser()
        ethogram.behaviourStates = []
        return ethogram
    }
    
    func addBehaviourState(state: BehaviourState) {
        behaviourStates.append(state)
    }
    
    // Parse Object Subclassing Methods
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    class func parseClassName() -> String {
        return "Ethogram"
    }
}
