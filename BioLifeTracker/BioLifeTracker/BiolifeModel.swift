//
//  BiolifeModel.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 29/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class BiolifeModel: NSObject, NSCoding {
    var id: Int?
    var isLocked: Bool = false
    var createdAt: NSDate
    var updatedAt: NSDate
    var createdBy: User
    var updatedBy: User
    
    override init() {
        createdBy = UserAuthService.sharedInstance.user
        updatedBy = UserAuthService.sharedInstance.user
        createdAt = NSDate()
        updatedAt = NSDate()
        super.init()
    }
    
    required init(coder decoder: NSCoder) {
        createdAt = decoder.decodeObjectForKey("createdAt") as NSDate
        updatedAt = decoder.decodeObjectForKey("updatedAt") as NSDate
        createdBy = decoder.decodeObjectForKey("createdBy") as User
        updatedBy = decoder.decodeObjectForKey("updatedBy") as User
        super.init()
    }
    
    // Set of functionalities for CloudStorable protocol
    init(dictionary: NSDictionary) {
        let cloudStorage = CloudStorageManager.sharedInstance
        let dateFormatter = BiolifeDateFormatter()
        self.id = dictionary["id"] as Int?
        self.createdAt = dateFormatter.getDate(dictionary["created_at"] as String)
        self.updatedAt = dateFormatter.getDate(dictionary["updated_at"] as String)
        self.createdBy = cloudStorage.getUserWithId(dictionary["created_by"] as Int)
        self.updatedBy = cloudStorage.getUserWithId(dictionary["updated_by"] as Int)
        super.init()
    }
    func setId(id: Int) { self.id = id }
    func lock() { isLocked = true }
    func unlock() { isLocked = false }
    func encodeWithDictionary(dictionary: NSMutableDictionary) {
        let dateFormatter = BiolifeDateFormatter()
        dictionary.setValue(dateFormatter.formatDate(createdAt), forKey: "created_at")
        dictionary.setValue(dateFormatter.formatDate(updatedAt), forKey: "updated_at")
        dictionary.setValue(createdBy.id, forKey: "created_by")
        dictionary.setValue(updatedBy.id, forKey: "updated_by")
    }

}


extension BiolifeModel: NSCoding {    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(createdAt, forKey: "createdAt")
        coder.encodeObject(updatedAt, forKey: "updatedAt")
        coder.encodeObject(createdBy, forKey: "createdBy")
        coder.encodeObject(updatedBy, forKey: "updatedBy")
    }
}
