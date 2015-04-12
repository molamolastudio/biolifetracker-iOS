//
//  EthogramManager.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 5/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class EthogramManager: NSObject, Storable {
    private var _ethograms: [Ethogram] = []
    
    var ethograms: [Ethogram] { get { return _ethograms } }
    
    override init() {
        _ethograms = []
        super.init()
    }
    
    class var sharedInstance: EthogramManager {
        struct Singleton {
            static let instance = EthogramManager()
        }
        return Singleton.instance
    }
    
    func updateEthograms(ethograms: [Ethogram]) {
        self._ethograms = ethograms
    }
    
    func addEthogram(ethogram: Ethogram) {
        self._ethograms.append(ethogram)
    }
    
    func updateEthogram(index: Int, ethogram: Ethogram) {
        self._ethograms.removeAtIndex(index)
        self._ethograms.insert(ethogram, atIndex: index)
    }
    
    func removeEthograms(indexes: [Int]) {
        for index in indexes {
            self._ethograms.removeAtIndex(index)
        }
    }
    
    // For testing.
    func clearEthograms() {
        self._ethograms = [Ethogram]()
        saveToArchives()
    }
    
    /**************Saving to Archives****************/
    func saveToArchives() {
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        
        if ((dirs) != nil) {
            let dir = dirs![0]; //documents directory
            let path = dir.stringByAppendingPathComponent("Existing ethograms of" + UserAuthService.sharedInstance.user.toString())
            
            let data = NSMutableData();
            let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
            archiver.encodeObject(self, forKey: "ethograms")
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
        let path = dir.stringByAppendingPathComponent("Existing ethograms of" + identifier)
        let data = NSMutableData(contentsOfFile: path)
        
        if data == nil {
            return nil
        }
        
        let archiver = NSKeyedUnarchiver(forReadingWithData: data!)
        var ethogramManager = archiver.decodeObjectForKey("ethograms") as! EthogramManager?

        return ethogramManager
    }
    
    class func deleteFromArchives(identifier: String) -> Bool {
        // Cannot delete user ethograms
        return false
    }
    
    required init(coder aDecoder: NSCoder) {
        var enumerator: NSEnumerator
        
        let objectEthograms: AnyObject = aDecoder.decodeObjectForKey("ethograms")!
        enumerator = objectEthograms.objectEnumerator()
        self._ethograms = Array<Ethogram>()
        while true {
            let ethogram = enumerator.nextObject() as! Ethogram?
            if ethogram == nil {
                break
            } else {
                self._ethograms.append(ethogram!)
            }
        }
        super.init()
    }
}

extension EthogramManager: NSCoding {
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(_ethograms, forKey: "ethograms")
    }
}