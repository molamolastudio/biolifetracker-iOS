//
//  Location.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 16/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Location: NSObject, NSCoding {
    var location: String! // to change when we determine what maps to use
    
    private override init() {
        super.init()
    }
    
    // static maker method
    class func makeDefault() -> Location {
        var location = Location()
        // assign @NSManaged variables here
        return location
    }
    
//    // Parse Object Subclassing Methods
//    override class func initialize() {
//        var onceToken: dispatch_once_t = 0
//        dispatch_once(&onceToken) {
//            self.registerSubclass()
//        }
//    }
//    
//    class func parseClassName() -> String {
//        return "Location"
//    }
    
    required init(coder aDecoder: NSCoder) {
        self.location = aDecoder.decodeObjectForKey("location") as String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(location, forKey: "location")
    }

}