//
//  Location.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 16/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Location: BiolifeModel {
    var location: String // to change when we determine what maps to use
    
    override init() {
        location = ""
        super.init()
    }
    
    // static maker method
    class func makeDefault() -> Location {
        var location = Location()
        // assign @NSManaged variables here
        return location
    }
    
    required init(coder aDecoder: NSCoder) {
        self.location = aDecoder.decodeObjectForKey("location") as String
        super.init(coder: aDecoder)
    }
}

extension Location: NSCoding {
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(location, forKey: "location")
    }
}