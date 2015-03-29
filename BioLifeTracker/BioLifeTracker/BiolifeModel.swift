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
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        // read data from decoder
    }
}


extension BiolifeModel: NSCoding {    
    func encodeWithCoder(coder: NSCoder) {
        // write data to coder
    }
}