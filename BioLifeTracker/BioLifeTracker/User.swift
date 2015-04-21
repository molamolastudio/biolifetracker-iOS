//
//  User.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    class var ClassUrl: String { return "users" }
    
    var id: Int = 0
    var email: String
    var name: String
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObjectForKey("id") as! Int
        self.email = aDecoder.decodeObjectForKey("email") as! String
        self.name = aDecoder.decodeObjectForKey("name") as! String
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(email, forKey: "email")
        aCoder.encodeObject(name, forKey: "name")
    }
    
    func toString() -> String {
        return name
    }
    
    init(dictionary: NSDictionary) {
        id = dictionary["id"] as! Int
        email = dictionary["email"] as! String
        name = dictionary["username"] as! String
        super.init()
    }
    
    convenience init(dictionary: NSDictionary, recursive: Bool) {
        self.init(dictionary: dictionary)
    }
    
    class func usersWithIds(idList: [Int]) -> [User] {
        let manager = CloudStorageManager.sharedInstance
        return idList.map {
            let memberDictionary = manager.getItemForClass(User.ClassUrl, itemId: $0)
            return User(dictionary: memberDictionary)
        }
    }
    
    func encodeRecursivelyWithDictionary(dictionary: NSMutableDictionary) {
        dictionary.setValue(id, forKey: "id")
        dictionary.setValue(email, forKey: "email")
        dictionary.setValue(name, forKey: "username")
    }
}

func ==(lhs: User, rhs: User) -> Bool {
    println("lhs: \(lhs.name) \(lhs.email) \(lhs.id)")
    println("rhs: \(rhs.name) \(rhs.email) \(rhs.id)")
    
    
    if lhs.name != rhs.name { return false }
    if lhs.email != rhs.email { return false }
    if lhs.id != rhs.id { return false }
    return true
}

func !=(lhs: User, rhs: User) -> Bool {
    return !(lhs == rhs)
}