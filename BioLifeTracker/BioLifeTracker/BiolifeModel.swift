//
//  BiolifeModel.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 29/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class BiolifeModel: NSObject, NSCoding {
    var createdAt: NSDate
    var updatedAt: NSDate
    var createdBy: User
    var updatedBy: User
    
    override init() {
        createdBy = Data.currentUser
        updatedBy = Data.currentUser
        createdAt = NSDate()
        updatedAt = NSDate()
        super.init()
    }
    
    required init(coder decoder: NSCoder) {
        createdAt = decoder.decodeObjectForKey("createdAt") as NSDate
        updatedAt = decoder.decodeObjectForKey("updatedAt") as NSDate
        createdBy = decoder.decodeObjectForKey("createdBy") as User
        updatedBy = decoder.decodeObjectForKey("updatedBy") as User
        super.init()
    }
}


extension BiolifeModel: NSCoding {    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(createdAt, forKey: "createdAt")
        coder.encodeObject(updatedAt, forKey: "updatedAt")
        coder.encodeObject(createdBy, forKey: "createdBy")
        coder.encodeObject(updatedBy, forKey: "updatedBy")
    }
}
