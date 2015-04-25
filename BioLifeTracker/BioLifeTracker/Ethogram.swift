//
//  Ethogram.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Maintained by Li Jia'En, Nicholette.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

///  This is a data model class for Ethogram.
///  This class contains methods to initialise Ethogram instances,
///  get and set instance attributes.
///  This class also contains methods to store and retrieve saved
///  Ethogram instances to the disk.
class Ethogram: BiolifeModel {
    // Constants
    static let archivePrefix = "Ethogram"
    static let emptyString = ""
    static let nameKey = "name"
    static let informationKey = "information"
    static let behavioursKey = "behaviours"
    static let behaviourStatesKey = "behaviourStates"
    
    static let ClassUrl = "ethograms"
    
    // Private attributes
    private var _name: String
    private var _information: String
    private var _behaviourStates: [BehaviourState]
    
    // Accessors
    var name: String { get { return _name } }
    var information: String { get { return _information } }
    var behaviourStates: [BehaviourState] { get { return _behaviourStates } }
    
    // This is the default initialiser of an empty Ethogram.
    override init() {
        _name = Ethogram.emptyString
        _behaviourStates = []
        _information = Ethogram.emptyString
        super.init()
    }
    
    convenience init(name: String) {
        self.init()
        self._name = name
        self._behaviourStates = []
        self._information = Ethogram.emptyString
      //  self.saveToArchives()
    }
    
    convenience init(name: String, information: String) {
        self.init()
        self._name = name
        self._behaviourStates = []
        self._information = information
      //  self.saveToArchives()
    }
    
    required convenience init(dictionary: NSDictionary) {
        self.init(dictionary: dictionary, recursive: false)
    }
    
    override init(dictionary: NSDictionary, recursive: Bool) {
        _name = dictionary[Ethogram.nameKey] as! String
        _information = dictionary[Ethogram.informationKey] as! String
        if recursive {
            let behaviourInfos = dictionary[Ethogram.behavioursKey] as! [NSDictionary]
            self._behaviourStates = behaviourInfos.map {
                BehaviourState(dictionary: $0, recursive: true)
            }
        } else {
            let behaviourIds = dictionary[Ethogram.behavioursKey] as! [Int]
            self._behaviourStates = behaviourIds.map {
                BehaviourState.behaviourStateWithId($0)
            }
        }
        super.init(dictionary: dictionary, recursive: recursive)
    }
    
    
    // MARK: METHODS FOR ETHOGRAM
    
    
    /// This function updates the name of the ethogram.
    func updateName(name: String) {
        self._name = name
        updateEthogram()
    }
    
    /// This function updates the information of the ethogram.
    func updateInformation(information: String) {
        self._information = information
        updateEthogram()
    }
    
    
    // MARK: METHODS FOR BEHAVIOUR STATE
    
    
    /// This method is used to add a behaviour state.
    func addBehaviourState(state: BehaviourState) {
        self._behaviourStates.append(state)
        updateEthogram()
    }
    
    /// This method updates the name of a behaviour state.
    func updateBehaviourStateName(index: Int, bsName: String) {
        self._behaviourStates[index].updateName(bsName)
        updateEthogram()
    }
    
    /// This method updates the information of a behaviour state.
    func updateBehaviourStateInformation(index: Int, bsInformation: String) {
        self._behaviourStates[index].updateInformation(bsInformation)
        updateEthogram()
    }
    
    /// This method removes a behaviour state at the specified index.
    func removeBehaviourState(index: Int) {
        self._behaviourStates.removeAtIndex(index)
        updateEthogram()
    }

    /// This is a private function to update the instance's createdAt, createdBy
    /// updatedBy and updatedAt.
    private func updateEthogram() {
        updateInfo(updatedBy: UserAuthService.sharedInstance.user, updatedAt: NSDate())
    }
    
    /// This function returns a ethogram of the specified id.
    class func ethogramWithId(id: Int) -> Ethogram {
        let manager = CloudStorageManager.sharedInstance
        let dictionary = manager.getItemForClass(Ethogram.ClassUrl, itemId: id)
        return Ethogram(dictionary: dictionary)
    }
    
    
    // MARK: IMPLEMENTATION OF NSKEYEDARCHIVAL
    
    
    required init(coder aDecoder: NSCoder) {
        var enumerator: NSEnumerator
        self._name = aDecoder.decodeObjectForKey(Ethogram.nameKey) as! String
        
        let objectBehavStates: AnyObject = aDecoder.decodeObjectForKey(Ethogram.behaviourStatesKey)!

        enumerator = objectBehavStates.objectEnumerator()
        
        self._behaviourStates = Array<BehaviourState>()
        
        // Check whether BehaviourState can be stored
        while true {
            let behaviourState = enumerator.nextObject() as! BehaviourState?
            if behaviourState == nil {
                break
            }
            self._behaviourStates.append(behaviourState!)
        }

        self._information = aDecoder.decodeObjectForKey(Ethogram.informationKey) as! String
        super.init(coder: aDecoder)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_name, forKey: Ethogram.nameKey)
        aCoder.encodeObject(_information, forKey: Ethogram.informationKey)
        aCoder.encodeObject(_behaviourStates, forKey: Ethogram.behavioursKey)
    }
}

/// This function checks for ethogram equality.
func ==(lhs: Ethogram, rhs: Ethogram) -> Bool {
    if lhs.name != rhs.name { return false }
    if lhs.information != rhs.information { return false }
    if lhs.behaviourStates.count != rhs.behaviourStates.count { return false }
    return true
}

/// This function checks for ethogram inequality.
func !=(lhs: Ethogram, rhs: Ethogram) -> Bool {
    return !(lhs == rhs)
}

extension Ethogram: CloudStorable {
    var classUrl: String { return Ethogram.ClassUrl }
    
    func getDependencies() -> [CloudStorable] {
        var dependencies = [CloudStorable]()
        behaviourStates.map { dependencies.append($0) }
        return dependencies
    }
    
    override func encodeWithDictionary(dictionary: NSMutableDictionary) {
        dictionary.setValue(name, forKey: Ethogram.nameKey)
        dictionary.setValue(information, forKey: Ethogram.informationKey)
        dictionary.setValue(behaviourStates.map { $0.id! }, forKey: Ethogram.behavioursKey)
        dictionary.setValue([], forKey: Ethogram.behavioursKey)
        super.encodeWithDictionary(dictionary)
    }
}

extension Ethogram {
    override func encodeRecursivelyWithDictionary(dictionary: NSMutableDictionary) {
        // simple properties
        dictionary.setValue(name, forKey: Ethogram.nameKey)
        dictionary.setValue(information, forKey: Ethogram.informationKey)
        
        // complex properties
        var behavioursArray = [NSDictionary]()
        for behaviour in behaviourStates {
            var behaviourDictionary = NSMutableDictionary()
            behaviour.encodeRecursivelyWithDictionary(behaviourDictionary)
            behavioursArray.append(behaviourDictionary)
        }
        dictionary.setValue(behavioursArray, forKey: Ethogram.behavioursKey)
        
        super.encodeRecursivelyWithDictionary(dictionary)
    }
}
