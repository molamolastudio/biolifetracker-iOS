//
//  Individual.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 16/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Individual: BiolifeModel {
    var label: String
    var tags: [Tag]
    var photo: UIImage?
    var project: Project
    
    @availability(iOS, deprecated=0.1, message="Use photo: NSImage instead")
    var photoUrls = [String]()
    
    init(project: Project) {
        self.label = ""
        self.tags = []
        self.project = project
        super.init()
    }
    
    // static maker method
    class func makeDefault() -> Individual {
        var individual = Individual(project: Project())
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
        self.tags = []
        while true {
            let url = enumerator.nextObject() as Tag?
            if url == nil {
                break
            }
            
            self.tags.append(url!)
        }
        
        self.project = aDecoder.decodeObjectForKey("project") as Project
        super.init(coder: aDecoder)
    }
}


extension Individual: NSCoding {
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(label, forKey: "label")
        aCoder.encodeObject(photoUrls, forKey: "photoUrls")
        aCoder.encodeObject(tags, forKey: "tags")
        aCoder.encodeObject(project, forKey: "project")
    }
}
