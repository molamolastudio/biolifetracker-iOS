//
//  Individual.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 16/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Individual: NSObject, NSCoding {
    var label: String
    var photoUrls = [String]()
    var tags = [String]()
    
    override init() {
        self.label = ""
        super.init()
    }
    
    // static maker method
    class func makeDefault() -> Individual {
        var individual = Individual()
        individual.label = ""
        individual.photoUrls = []
        individual.tags = []
        return individual
    }
    
    required init(coder aDecoder: NSCoder) {
        
        var enumerator: NSEnumerator
        self.label = aDecoder.decodeObjectForKey("label") as String
        
        let objectPhotoUrls: AnyObject = aDecoder.decodeObjectForKey("photoUrls")!
        enumerator = objectPhotoUrls.objectEnumerator()
        self.photoUrls = Array<String>()
        while true {
            let url = enumerator.nextObject() as String?
            if url == nil {
                break
            }
            
            self.photoUrls.append(url!)
        }
        
        let objectTags: AnyObject = aDecoder.decodeObjectForKey("tags")!
        enumerator = objectTags.objectEnumerator()
        self.tags = Array<String>()
        while true {
            let url = enumerator.nextObject() as String?
            if url == nil {
                break
            }
            
            self.tags.append(url!)
        }
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(label, forKey: "label")
        aCoder.encodeObject(photoUrls, forKey: "photoUrls")
        aCoder.encodeObject(tags, forKey: "tags")
    }
}