//
//  User.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    var id: String          // Use email or object id
    var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObjectForKey("id") as String
        self.name = aDecoder.decodeObjectForKey("name") as String
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(name, forKey: "name")
    }
    
    func toString() -> String {
        return name
    }
}