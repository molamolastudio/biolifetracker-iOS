//
//  EthogramManager.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 5/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

///  This is a manager class to manage a user's Ethograms.
///  This class utilises the Singleton pattern to ensure that the same
///  manager instance is used throughout the application to ensure
///  consistency in the manager state.
class EthogramManager: NSObject, Storable {
    
    // Constants
    static let archivePrefix = "Existing ethograms of"
    static let ethogramsKey = "ethograms"
    
    // Private attributes
    private var _ethograms: [Ethogram] = []
    
    // Accessors
    var ethograms: [Ethogram] { get { return _ethograms } }
    
    /// This function is to initiate an instance of EthogramManager.
    override init() {
        _ethograms = []
        super.init()
    }
    
    /// Implementation of Singleton Pattern
    class var sharedInstance: EthogramManager {
        struct Singleton {
            static let instance = EthogramManager()
        }
        return Singleton.instance
    }
    
    /// This function bulk updates the Ethograms array by overriding
    /// the existing ethogram list with the new one.
    /// This function is meant to be used by the Cloud component to
    /// retrieve the user's existing projects in the cloud.
    func updateEthograms(ethograms: [Ethogram]) {
        self._ethograms = ethograms
        saveToArchives()
    }
    
    /// This function checks whether there is an existing ethogram with the
    /// specified id.
    /// Returns a boolean.
    func hasEthogramWithId(id: Int) -> Bool {
        for ethogram in ethograms {
            if ethogram.id == id {
                return true
            }
        }
        return false
    }
    
    /// This function adds an Ethogram instance to the Ethogram array.
    /// It detects whether an Ethogram has been updated in the cloud before
    /// and is safe to be used generically by the cloud component.
    func addEthogram(ethogram: Ethogram) {
        var isReplace = false
        if ethogram.id != nil {
            for (var i = 0; i < _ethograms.count; i++) {
                if _ethograms[i].id == ethogram.id {
                    _ethograms[i] = ethogram
                    isReplace = true
                    break
                }
            }
        }
        if !isReplace {
            _ethograms.append(ethogram)
        }
        saveToArchives()
    }
    
    /// This function updates the Ethogram instance in the Ethogram list
    /// and saves it to the disk.
    /// Returns true if the ethogram is updated.
    func updateEthogram(index: Int, ethogram: Ethogram) -> Bool {
        if index >= ethograms.count {
            return false
        }
        
        self._ethograms.removeAtIndex(index)
        self._ethograms.insert(ethogram, atIndex: index)
        saveToArchives()
        return true
    }
    
    /// This function bulk removes the Ethogram instances in the Ethogram
    /// list and saves the updated Ethogram array to disk.
    func removeEthograms(indexes: [Int]) {
        for index in indexes {
            self._ethograms.removeAtIndex(index)
        }
        saveToArchives()
    }
    
    /// This function clears the Ethograms array and saves the updated
    /// Ethograms array to disk.
    func clearEthograms() {
        self._ethograms = [Ethogram]()
        saveToArchives()
    }
    
    /// This function erases the saved user ethograms when the user logouts.
    func handleLogOut() {
        EthogramManager.deleteFromArchives(
                        String(UserAuthService.sharedInstance.user.id))
        EthogramManager.sharedInstance._ethograms = []
    }
    
    
    // MARK: IMPLEMENTATION OF STORABLE IMPLEMENTATION
    
    
    /// This function asynchronously saves Ethograms list into local storage
    func saveToArchives() {
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(
                    NSSearchPathDirectory.DocumentDirectory,
                    NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        
        if ((dirs) != nil) {
            let dir = dirs![0]; //documents directory
            let path = dir.stringByAppendingPathComponent(
                        EthogramManager.archivePrefix +
                        String(UserAuthService.sharedInstance.user.id))
            
            let data = NSMutableData();
            let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
            archiver.encodeObject(self, forKey: EthogramManager.ethogramsKey)
            archiver.finishEncoding()
            let success = data.writeToFile(path, atomically: true)
        }
    }
    
    /// This function loads existing Ethograms list from the local storage
    class func loadFromArchives(identifier: String) -> NSObject? {
        
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(
                    NSSearchPathDirectory.DocumentDirectory,
                    NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        
        if (dirs == nil) {
            return nil
        }
        
        // documents directory
        let dir = dirs![0]
        let path = dir.stringByAppendingPathComponent(
                                EthogramManager.archivePrefix + identifier)
        let data = NSMutableData(contentsOfFile: path)
        
        if data == nil {
            return nil
        }
        
        let archiver = NSKeyedUnarchiver(forReadingWithData: data!)
        var ethogramManager = archiver.decodeObjectForKey(
                                EthogramManager.ethogramsKey) as? EthogramManager

        return ethogramManager
    }
    
    /// This function deletes the existing Ethograms list directory in the disk
    class func deleteFromArchives(identifier: String) -> Bool {
        // Cannot delete user ethograms
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(
                    NSSearchPathDirectory.DocumentDirectory,
                    NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        
        if (dirs == nil) {
            return false
        }
        
        // documents directory
        let dir = dirs![0]
        let path = dir.stringByAppendingPathComponent(
                                EthogramManager.archivePrefix + identifier)
        
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
        
        let objectEthograms: AnyObject = aDecoder.decodeObjectForKey(EthogramManager.ethogramsKey)!
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
        aCoder.encodeObject(_ethograms, forKey: EthogramManager.ethogramsKey)
    }
}