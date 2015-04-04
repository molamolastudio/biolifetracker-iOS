//
//  Ethogram.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//
import Foundation

class Ethogram: BiolifeModel, Storable {
    var name: String
    var information: String
    var behaviourStates: [BehaviourState]
    
    @availability(iOS, deprecated=0.1, message="Use createdBy instead")
    var creator: User { return createdBy }
    
    override init() {
        name = ""
        behaviourStates = []
        information = ""
        super.init()
    }
    
    convenience init(name: String) {
        self.init()
        self.name = name
        self.behaviourStates = []
        information = ""
    }
    
    func addBehaviourState(state: BehaviourState) {
        behaviourStates.append(state)
    }
    
    func saveToArchives() {
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
    
        if ((dirs) != nil) {
            let dir = dirs![0]; //documents directory
            let path = dir.stringByAppendingPathComponent("Ethogram");
        
            let data = NSMutableData();
            let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
            
            archiver.encodeObject(self, forKey: name)
            archiver.finishEncoding()
            let success = data.writeToFile(path, atomically: true)
        }
    }
    
    class func loadFromArchives(identifier: String) -> NSObject? {
        
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        
        if (dirs == nil) {
            return nil
        }
        
        // documents directory
        
        let dir = dirs![0]
        let path = dir.stringByAppendingPathComponent("Ethogram")
        let data = NSMutableData(contentsOfFile: path)?
    
        if data == nil {
            return nil
        }
        
        let archiver = NSKeyedUnarchiver(forReadingWithData: data!)
        let ethogram = archiver.decodeObjectForKey(identifier) as Ethogram
        
        return ethogram
    }
    
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as String
        
        let objectBehavStates: AnyObject = aDecoder.decodeObjectForKey("behaviourStates")!
        let enumerator = objectBehavStates.objectEnumerator()
        
        self.behaviourStates = Array<BehaviourState>()  // Check whether BehaviourState can be stored
        
        while true {
            
            let behaviourState = enumerator.nextObject() as BehaviourState?
            if behaviourState == nil {
                break
            }
        
            self.behaviourStates.append(behaviourState!)
        }
        self.information = ""
        super.init(coder: aDecoder)
    }
}

extension Ethogram: NSCoding {
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(creator, forKey: "creator")
        aCoder.encodeObject(behaviourStates, forKey: "behaviourStates")
    }
}

extension Ethogram: CloudStorable {
    class var classUrl: String { return "ethogram" }
    func upload() { }
    func getDependencies() -> [CloudStorable] { return [] }
}
