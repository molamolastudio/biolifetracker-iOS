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
        saveToArchives()
    }
    
    func addEthogram(ethogram: Ethogram) {
        self._ethograms.append(ethogram)
        saveToArchives()
    }
    
    func updateEthogram(index: Int, ethogram: Ethogram) {
        self._ethograms.removeAtIndex(index)
        self._ethograms.insert(ethogram, atIndex: index)
        saveToArchives()
    }
    
    func removeEthograms(indexes: [Int]) {
        for index in indexes {
            self._ethograms.removeAtIndex(index)
        }
        saveToArchives()
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
            let path = dir.stringByAppendingPathComponent("Existing ethograms of" + String(UserAuthService.sharedInstance.user.id))
            
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
        var ethogramManager = archiver.decodeObjectForKey("ethograms") as? EthogramManager

        return ethogramManager
    }
    
    class func deleteFromArchives(identifier: String) -> Bool {
        // Cannot delete user ethograms
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        
        if (dirs == nil) {
            return false
        }
        
        // documents directory
        let dir = dirs![0]
        let path = dir.stringByAppendingPathComponent("Existing ethograms of" + identifier)
        
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(path) {
            // Delete the file and see if it was successful
            var error: NSError?
            let success = fileManager.removeItemAtPath(path, error: &error)
            if error != nil {
                println(error)
            }
            return success;
        } else {
            return true // nothing to clear
        }
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
    
    func handleLogOut() {
        // Please do anything to manage user data here
        EthogramManager.deleteFromArchives(String(UserAuthService.sharedInstance.user.toString()))
        EthogramManager.sharedInstance._ethograms = []
    }
}

extension EthogramManager: NSCoding {
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(_ethograms, forKey: "ethograms")
    }
}