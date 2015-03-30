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
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
     required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObjectForKey("name") as String
        super.init(coder: decoder)
    }
    
}

extension Tag: NSCoding {
    override func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(name, forKey: "name")
        super.encodeWithCoder(coder)
    }
}