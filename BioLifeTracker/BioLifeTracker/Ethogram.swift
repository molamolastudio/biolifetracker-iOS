//
//  Ethogram.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//
import Foundation

class Ethogram: BiolifeModel, Storable, BLTEthogramProtocol {
    static let ClassUrl = "ethograms"
    
    private var _name: String
    private var _information: String
    private var _behaviourStates: [BehaviourState]
    
    var name: String { get { return _name } }
    var information: String { get { return _information } }
    var behaviourStates: [BehaviourState] { get { return _behaviourStates } }
    
    override init() {
        _name = ""
        _behaviourStates = []
        _information = ""
        super.init()
    }
    
    convenience init(name: String) {
        self.init()
        self._name = name
        self._behaviourStates = []
        self._information = ""
      //  self.saveToArchives()
    }
    
    convenience init(name: String, information: String) {
        self.init()
        self._name = name
        self._behaviourStates = []
        self._information = information
      //  self.saveToArchives()
    }
    
    required override init(dictionary: NSDictionary) {
        _name = dictionary["name"] as! String
        _information = dictionary["information"] as! String
        let behaviourIds = dictionary["behaviours"] as! [Int]
        _behaviourStates = behaviourIds.map { BehaviourState.behaviourStateWithId($0) }
        super.init(dictionary: dictionary)
    }
    
    /************Ethogram********************/
    
    func updateName(name: String) {
        Ethogram.deleteFromArchives(self.name)
        self._name = name
        updateEthogram()
    }
    
    func updateInformation(information: String) {
        self._information = information
        updateEthogram()
    }
    
    /*********Behaviour State****************/
    
    func addBehaviourState(state: BehaviourState) {
        self._behaviourStates.append(state)
        updateEthogram()
    }
    
    func updateBehaviourStateName(index: Int, bsName: String) {
        self._behaviourStates[index].updateName(bsName)
        updateEthogram()
    }
    
    func updateBehaviourStateInformation(index: Int, bsInformation: String) {
        self._behaviourStates[index].updateInformation(bsInformation)
        updateEthogram()
    }
    
    func removeBehaviourState(index: Int) {
        self._behaviourStates.removeAtIndex(index)
        updateEthogram()
    }
    
    /*************Photo Url in BS***************/    
    private func updateEthogram() {
        updateInfo(updatedBy: UserAuthService.sharedInstance.user, updatedAt: NSDate())
      //  self.saveToArchives()
    }
    
    /**************Saving to Archives****************/
    func saveToArchives() {
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
    
        if ((dirs) != nil) {
            let dir = dirs![0]; //documents directory
            let path = dir.stringByAppendingPathComponent("Ethogram" + self._name);
        
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
        let path = dir.stringByAppendingPathComponent("Ethogram" + identifier)
        let data = NSMutableData(contentsOfFile: path)
    
        if data == nil {
            return nil
        }
        
        let archiver = NSKeyedUnarchiver(forReadingWithData: data!)
        let ethogram = archiver.decodeObjectForKey(identifier) as! Ethogram?
        
        return ethogram
    }
    
    required init(coder aDecoder: NSCoder) {
        var enumerator: NSEnumerator
        self._name = aDecoder.decodeObjectForKey("name") as! String
        
        let objectBehavStates: AnyObject = aDecoder.decodeObjectForKey("behaviourStates")!

        enumerator = objectBehavStates.objectEnumerator()
        
        self._behaviourStates = Array<BehaviourState>()  // Check whether BehaviourState can be stored
        
        while true {
            
            let behaviourState = enumerator.nextObject() as! BehaviourState?
            if behaviourState == nil {
                break
            }
        
            self._behaviourStates.append(behaviourState!)
        }

        self._information = aDecoder.decodeObjectForKey("information") as! String
        super.init(coder: aDecoder)
    }
    
    class func deleteFromArchives(identifier: String) -> Bool {
        
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        
        if (dirs == nil) {
            return false
        }
        
        // documents directory
        let dir = dirs![0]
        let path = dir.stringByAppendingPathComponent("Ethogram" + identifier)
        
        // Delete the file and see if it was successful
        var error: NSError?
        let success :Bool = NSFileManager.defaultManager().removeItemAtPath(path, error: &error)
        
        if error != nil {
            println(error)
        }
        
        return success;
    }
    
    class func ethogramWithId(id: Int) -> Ethogram {
        let manager = CloudStorageManager.sharedInstance
        let dictionary = manager.getItemForClass(Ethogram.ClassUrl, itemId: id)
        return Ethogram(dictionary: dictionary)
    }
}

func ==(lhs: Ethogram, rhs: Ethogram) -> Bool {
    if lhs.name != rhs.name { return false }
    if lhs.information != rhs.information { return false }
    if lhs.behaviourStates != rhs.behaviourStates { return false }
    return true
}


extension Ethogram: NSCoding {
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_name, forKey: "name")
        aCoder.encodeObject(_information, forKey: "information")
        aCoder.encodeObject(_behaviourStates, forKey: "behaviourStates")
    }
}


extension Ethogram: CloudStorable {
    var classUrl: String { return Ethogram.ClassUrl }
    
    func getDependencies() -> [CloudStorable] {
        var dependencies = [CloudStorable]()
        behaviourStates.map { dependencies.append($0) }
        return dependencies
    }
    
    override func encodeWithDictionary(dictionary: NSMutableDictionary) {
        dictionary.setValue(name, forKey: "name")
        dictionary.setValue(information, forKey: "information")
        dictionary.setValue(behaviourStates.map { $0.id! }, forKey: "behaviours")
        super.encodeWithDictionary(dictionary)
    }
}

extension Ethogram {
    func encodeRecursivelyWithDictionary(dictionary: NSMutableDictionary) {
        let dateFormatter = BiolifeDateFormatter()
        
        super.encodeWithDictionary(dictionary)
    }
}
