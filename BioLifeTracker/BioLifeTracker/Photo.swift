//
//  Photo.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 16/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Photo: NSObject, NSCoding {
    var url: String
    
    init(url: String) {
        self.url = url
    }
    
    required init(coder aDecoder: NSCoder) {
        self.url = aDecoder.decodeObjectForKey("url") as String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(url, forKey: "url")
    }
    
}