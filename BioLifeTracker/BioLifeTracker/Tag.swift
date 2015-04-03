//
//  Tag.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 30/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Tag: BiolifeModel {
    var name: String
    
    override init() {
        name = ""
        super.init()
    }
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
     required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as String
        super.init(coder: aDecoder)
    }
    
}

extension Tag: NSCoding {
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(name, forKey: "name")
    }
}