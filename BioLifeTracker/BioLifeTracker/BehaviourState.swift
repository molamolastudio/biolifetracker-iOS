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
    private var _name: String
    private var _information: String
    private var _photo: UIImage?
    private var _photoUrls: [String]
    
    var name: String { get { return _name } }
    var information: String { get { return _information } }
    var photo: UIImage? { get { return _photo } }
    var photoUrls: [String] { get { return _photoUrls } }
    
    override init() {
        self._name = ""
        self._information = ""
        self._photoUrls = []
        super.init()
    }
    
    convenience init(name: String, information: String) {
        self.init()
        self._name = name
        self._information = information
        self._photoUrls = []
    }
    
    func updateName(name: String) {
        self._name = name
        updateBehaviourState()
    }
    
    func updateInformation(information: String) {
        self._information = information
        updateBehaviourState()
    }
    
    func updatePhoto(photo: UIImage) {
        self._photo = photo
        updateBehaviourState()
    }
    
    func addPhotoUrl(url: String) {
        self._photoUrls.append(url)
        updateBehaviourState()
    }
    
    func removePhotoUrlAtIndex(index: Int) {
        self._photoUrls.removeAtIndex(index)
        updateBehaviourState()
    }
    
    private func updateBehaviourState() {
        updateInfo(updatedBy: UserAuthService.sharedInstance.user, updatedAt: NSDate())
    }
    
    required init(coder aDecoder: NSCoder) {

        self._name = aDecoder.decodeObjectForKey("name") as String
        self._information = aDecoder.decodeObjectForKey("information") as String
        
        let objectPhotoUrls: AnyObject = aDecoder.decodeObjectForKey("photoUrls")!
        let enumerator = objectPhotoUrls.objectEnumerator()
        self._photoUrls = Array<String>()
        while true {
            let url = enumerator.nextObject() as String?
            if url == nil {
                break
            }
            self._photoUrls.append(url!)
        }
        
        super.init(coder: aDecoder)
    }
}


extension BehaviourState: NSCoding {
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_name, forKey: "name")
        aCoder.encodeObject(_information, forKey: "information")
        aCoder.encodeObject(_photoUrls, forKey: "photoUrls")
    }
}

extension BehaviourState: CloudStorable {
    class var classUrl: String { return "behaviourState" }
    func upload() { }
    func getDependencies() -> [CloudStorable] { return [] }
}
