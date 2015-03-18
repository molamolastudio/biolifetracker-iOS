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
    @NSManaged var creator: User
    @NSManaged var behaviourStates: [BehaviourState]

    override init() {
        super.init()
    }
    
//    init() {
//        self.name = Constants.Default.ethogramName
//        self.code = Constants.Default.ethogramCode
//        self.createdTime = NSDate()
//        self.creator = Data.currentUser
//        self.id = generateEthogramId()
//        self.code = self.id!
//    }
    
    convenience init(name: String, code: String) {
        self.init()
        self.name = name
        self.creator = Data.currentUser
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
