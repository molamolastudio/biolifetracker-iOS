//
//  Ethogram.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//
import Foundation

class Ethogram: NSObject, Storable {
    var name: String!
    var creator: User!
    var behaviourStates: [BehaviourState]!

    private override init() {
        super.init()
    }
    
    convenience init(name: String) {
        self.init()
        self.name = name
        self.creator = Data.currentUser
        self.behaviourStates = []
    }
    
    // static maker method
    class func makeDefault() -> Ethogram {
        var ethogram = Ethogram()
        ethogram.name = ""
        ethogram.creator = Data.currentUser
        ethogram.behaviourStates = []
        return ethogram
    }
    
    func addBehaviourState(state: BehaviourState) {
        behaviourStates.append(state)
    }
    
//    // Parse Object Subclassing Methods
//    override class func initialize() {
//        var onceToken: dispatch_once_t = 0
//        dispatch_once(&onceToken) {
//            self.registerSubclass()
//        }
//    }
//    
//    class func parseClassName() -> String {
//        return "Ethogram"
//    }
    
    func saveToArchives() {
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
    
        if ((dirs) != nil) {
            let dir = dirs![0]; //documents directory
            let path = dir.stringByAppendingPathComponent("Ethogram");
        
            let data = NSMutableData();
            let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
            
            archiver.encodeObject(self, forKey: name)
            //            archiver.encodeObject(self.creator, forKey: "EthogramCreator")
            //            archiver.encodeObject(self.behaviourStates, forKey: "EthogramBehaviourStates")
            //            archiver.finishEncoding()
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
        let ethogram = archiver.decodeObjectForKey(identifier)! as Ethogram
        //        let objectCreator = archiver.decodeObjectForKey("EthogramCreator")! as User // Check whether User can be stored
        //
        //        let objectBehavStates: AnyObject = archiver.decodeObjectForKey("EthogramBehaviourStates")!
        //        let enumerator = objectBehavStates.objectEnumerator()
        //
        //        var  loadBehaviourStates = Array<BehaviourState>()  // Check whether BehaviourState can be stored
        //        while true {
        //            let behaviourState = enumerator.nextObject() as BehaviourState?
        //            if behaviourState == nil {
        //                break
        //            }
        //
        //            loadBehaviourStates.append(behaviourState!)
        //        }
        return ethogram
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.name = aDecoder.decodeObjectForKey("name") as String
        self.creator = aDecoder.decodeObjectForKey("creator") as User
        
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
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(creator, forKey: "creator")
        aCoder.encodeObject(behaviourStates, forKey: "behaviourStates")

    }
}
