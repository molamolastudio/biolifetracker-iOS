//
//  User.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    var email: String
    var name: String
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.email = aDecoder.decodeObjectForKey("email") as String
        self.name = aDecoder.decodeObjectForKey("name") as String
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(email, forKey: "email")
        aCoder.encodeObject(name, forKey: "name")
    }
    
    func toString() -> String {
        return name
    }
}