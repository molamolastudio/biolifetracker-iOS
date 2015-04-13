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
    static let ClassUrl = "behaviours"
    
    private var _name: String
    private var _information: String
    private var _photo: Photo?
    
    var name: String { get { return _name } }
    var information: String { get { return _information } }
    var photo: Photo? { get { return _photo } }
    
    override init() {
        self._name = ""
        self._information = ""
        super.init()
    }
    
    convenience init(name: String, information: String) {
        self.init()
        self._name = name
        self._information = information
    }
    
    required override init(dictionary: NSDictionary) {
        //read data from dictionary
        super.init(dictionary: dictionary)
    }
    
    func updateName(name: String) {
        self._name = name
        updateBehaviourState()
    }
    
    func updateInformation(information: String) {
        self._information = information
        updateBehaviourState()
    }
    
    func updatePhoto(photo: Photo?) {
        self._photo = photo
        updateBehaviourState()
    }
    
    
    private func updateBehaviourState() {
        updateInfo(updatedBy: UserAuthService.sharedInstance.user, updatedAt: NSDate())
    }
    
    required init(coder aDecoder: NSCoder) {
        self._name = aDecoder.decodeObjectForKey("name") as! String
        self._information = aDecoder.decodeObjectForKey("information") as! String
        self._photo = aDecoder.decodeObjectForKey("photo") as! Photo?
        super.init(coder: aDecoder)
    }
    
    class func behaviourStateWithId(id: Int) -> BehaviourState {
        let manager = CloudStorageManager.sharedInstance
        let behaviourDictionary = manager.getItemForClass(ClassUrl, itemId: id)
        return BehaviourState(dictionary: behaviourDictionary)
    }
}

func ==(lhs: BehaviourState, rhs: BehaviourState) -> Bool {
    return lhs.name == rhs.name &&
        lhs.information == rhs.information &&
        lhs.photo == rhs.photo
}


extension BehaviourState: NSCoding {
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_name, forKey: "name")
        aCoder.encodeObject(_information, forKey: "information")
        aCoder.encodeObject(_photo, forKey: "photo")
    }
}


extension BehaviourState: CloudStorable {
    var classUrl: String { return BehaviourState.ClassUrl }
    
    func getDependencies() -> [CloudStorable] {
        var dependencies = [CloudStorable]()
        // append dependencies here
        return dependencies
    }
    
    override func encodeWithDictionary(dictionary: NSMutableDictionary) {
        super.encodeWithDictionary(dictionary)
        // write data here
    }
}
