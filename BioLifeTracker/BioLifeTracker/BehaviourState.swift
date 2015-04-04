//
//  BehaviourState.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Edited by Andhieka Putra.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class BehaviourState: BiolifeModel {
    var name: String
    var information: String
    var photo: UIImage?
    
    @availability(iOS, deprecated=0.1, message="Use photo: NSImage instead")
    var photoUrls: [String]
    
    override init() {
        name = ""
        information = ""
        self.photoUrls = []
        super.init()
    }
    
    convenience init(name: String, information: String) {
        self.init()
        self.name = name
        self.information = information
        self.photoUrls = []
    }
    
    required init(coder aDecoder: NSCoder) {

        self.name = aDecoder.decodeObjectForKey("name") as String
        self.information = aDecoder.decodeObjectForKey("information") as String
        
        let objectPhotoUrls: AnyObject = aDecoder.decodeObjectForKey("photoUrls")!
        let enumerator = objectPhotoUrls.objectEnumerator()
        self.photoUrls = Array<String>()
        while true {
            let url = enumerator.nextObject() as String?
            if url == nil {
                break
            }
            self.photoUrls.append(url!)
        }
        
        super.init(coder: aDecoder)
    }
}


extension BehaviourState: NSCoding {
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(information, forKey: "information")
        aCoder.encodeObject(photoUrls, forKey: "photoUrls")
    }
}

extension BehaviourState: CloudStorable {
    class var classUrl: String { return "behaviourState" }
    func upload() { }
    func getDependencies() -> [CloudStorable] { return [] }
}
