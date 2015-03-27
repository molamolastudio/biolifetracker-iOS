//
//  BehaviourState.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Edited by Andhieka Putra.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class BehaviourState: NSObject, NSCoding {
    var id: Int!
    var name: String!
    var information: String!
    //@NSManaged var ethogram: Ethogram
    var photoUrls: [String]!
    
    @availability(iOS, deprecated=0.1, message="use the given convenience init() instead")
    convenience init(name: String, id: Int) {
        self.init()
        self.id = id
        self.name = name
        self.information = ""
        self.photoUrls = []
    }
    
    convenience init(id: Int, name: String, information: String) {
        self.init()
        self.id = id
        self.name = name
        self.information = information
        self.photoUrls = []
    }
    
    private override init() {
        super.init()
        // do not initialize @NSManaged vars here,
        // or the program will crash.
    }
    
    // static maker method
    class func makeDefault() -> BehaviourState {
        var behaviourState = BehaviourState()
        behaviourState.id = 0
        behaviourState.name = ""
        behaviourState.information = ""
        behaviourState.photoUrls = []
        return behaviourState
    }
//    
//    // Parse Object Subclassing Methods
//    override class func initialize() {
//        var onceToken: dispatch_once_t = 0
//        dispatch_once(&onceToken) {
//            self.registerSubclass()
//        }
//    }
//    
//    class func parseClassName() -> String {
//        return "BehaviourState"
//    }
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObjectForKey("id") as Int
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
        
        super.init()
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(information, forKey: "information")
        aCoder.encodeObject(photoUrls, forKey: "photoUrls")
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
        let ethogram = archiver.decodeObjectForKey(identifier)! as BehaviourState

        return ethogram
    }
    
}