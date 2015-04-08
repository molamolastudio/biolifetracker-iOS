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
    
//    required init(dictionary: NSDictionary) {
//        let cloudStorage = CloudStorageManager.sharedInstance
//        self.createdAt = dictionary["createdAt"] as NSDate
//        self.updatedAt = dictionary["updatedAt"] as NSDate
//        self.createdBy = cloudStorage.getUserWithId(dictionary["createdBy"] as Int)
//        self.updatedBy = cloudStorage.getUserWithId(dictionary["updatedBy"] as Int)
//        super.init()
//    }
    
}


extension BiolifeModel: NSCoding {    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(createdAt, forKey: "createdAt")
        coder.encodeObject(updatedAt, forKey: "updatedAt")
        coder.encodeObject(createdBy, forKey: "createdBy")
        coder.encodeObject(updatedBy, forKey: "updatedBy")
    }
}

//extension BiolifeModel: CloudStorable {
//    var classUrl: String { return "biolifemodel" }
//    
//    func setId(id: Int) { self.id = id }
//    func lock() { isLocked = true }
//    func unlock() { isLocked = false }
//    
//    func encodeWithDictionary(inout dictionary: NSMutableDictionary) {
//        dictionary.setObject(createdAt, forKey: "createdAt")
//        dictionary.setObject(updatedAt, forKey: "updatedAt")
//        dictionary.setObject(createdBy, forKey: "createdBy")
//        dictionary.setObject(updatedBy, forKey: "updatedBy")
//    }
//    
//    func getDependencies() -> [CloudStorable] {
//        return [] // does not depend on anything
//    }
//}
