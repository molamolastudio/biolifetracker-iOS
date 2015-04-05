//
//  BehaviourState.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Edited by Andhieka Putra.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class BehaviourState: BiolifeModel, Storable {
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
    
    @availability(iOS, deprecated=0.1, message="use the given convenience init() instead")
    convenience init(name: String, id: Int) {
        self.init()
        self.name = name
        self.information = ""
        self.photoUrls = []
    }
    
    convenience init(id: Int, name: String, information: String) {
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
    
    func saveToArchives() {
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        
        if ((dirs) != nil) {
            let dir = dirs![0]; //documents directory
            let path = dir.stringByAppendingPathComponent("BehaviourState");
            
            let data = NSMutableData();
            let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
            
            archiver.encodeObject(self, forKey: name)
            archiver.finishEncoding()

            let success = data.writeToFile(path, atomically: true)
            println("success + \(success)")
        }
    }
    
    class func loadFromArchives(identifier: String) -> NSObject? {
        
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        
        if (dirs == nil) {
            return nil
        }
        
        // documents directory
        
        let dir = dirs![0]
        let path = dir.stringByAppendingPathComponent("BehaviourState")
        let data = NSMutableData(contentsOfFile: path)?
        
        if data == nil {
            return nil
        }
        
        let archiver = NSKeyedUnarchiver(forReadingWithData: data!)
        let behaviourState = archiver.decodeObjectForKey(identifier)! as BehaviourState

        return behaviourState
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
