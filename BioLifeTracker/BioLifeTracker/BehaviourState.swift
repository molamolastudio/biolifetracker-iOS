//
//  BehaviourState.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Edited by Andhieka Putra.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class BehaviourState: BiolifeModel, BLTBehaviourStateProtocol {
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
        _name = dictionary["name"] as! String
        _information = dictionary["information"] as! String
        if let photoId = dictionary["photo"] as? Int {
            _photo = Photo.photoWithId(photoId)
        }
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
    if lhs.name != rhs.name { return false }
    if lhs.information != rhs.information { return false }
    if lhs.photo != rhs.photo { return false }
    return true
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
        if photo != nil { dependencies.append(photo!) }
        return dependencies
    }
    
    override func encodeWithDictionary(dictionary: NSMutableDictionary) {
        dictionary.setValue(name, forKey: "name")
        dictionary.setValue(information, forKey: "information")
        dictionary.setValue(photo?.id, forKey: "photo")
        super.encodeWithDictionary(dictionary)
    }
}

extension BehaviourState {
    func encodeRecursivelyWithDictionary(dictionary: NSMutableDictionary) {
        let dateFormatter = BiolifeDateFormatter()
        
        super.encodeWithDictionary(dictionary)
    }
}
