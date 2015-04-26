//
//  User.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Maintained by Li Jia'En, Nicholette.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

//  This is a data model class for User.
//  This class contains methods to initialise User instances,
//  get and set instance attributes.
//  This class also contains methods to store and retrieve saved
//  User instances to the disk.
class User: NSObject, NSCoding {
    class var ClassUrl: String { return "users" }
    
    var id: Int = 0
    var email: String
    var name: String
    
    // Constants
    static let idKey = "id"
    static let emailKey = "email"
    static let nameKey = "name"
    static let usernameKey = "username"
    
    /// This function is to initiate an instance of User.
    init(name: String, email: String) {
        self.name = name
        self.email = email
        super.init()
    }
    
    /// This function gives a string representation of a User instance
    func toString() -> String {
        return name
    }
    
    /// This function initiates a User instance from a dictionary
    convenience init(dictionary: NSDictionary) {
        self.init(dictionary: dictionary, recursive: false)
    }
    
    init(dictionary: NSDictionary, recursive: Bool) {
        if recursive {
            id = dictionary[User.idKey] as! Int
            email = dictionary[User.emailKey] as! String
            name = dictionary[User.nameKey] as! String
        } else {
            id = dictionary[User.idKey] as! Int
            email = dictionary[User.emailKey] as! String
            name = dictionary[User.usernameKey] as! String
        }
    }
    
    /// This function retrieves the Users with specified ids.
    /// Returns the Users retrieved
    class func usersWithIds(idList: [Int]) -> [User] {
        let manager = CloudStorageManager.sharedInstance
        return idList.map {
            let memberDictionary = manager.getItemForClass(User.ClassUrl, itemId: $0)
            return User(dictionary: memberDictionary)
        }
    }
    
    /// This function converts a User into a dictionary object.
    func encodeRecursivelyWithDictionary(dictionary: NSMutableDictionary) {
        dictionary.setValue(id, forKey: User.idKey)
        dictionary.setValue(email, forKey: User.emailKey)
        dictionary.setValue(name, forKey: User.nameKey)
    }
    
    
    // MARK: IMPLEMENTATION FOR NSKEYEDARCHIVAL
    
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObjectForKey(User.idKey) as! Int
        self.email = aDecoder.decodeObjectForKey(User.emailKey) as! String
        self.name = aDecoder.decodeObjectForKey(User.nameKey) as! String
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: User.idKey)
        aCoder.encodeObject(email, forKey: User.emailKey)
        aCoder.encodeObject(name, forKey: User.nameKey)
    }
}

/// This function checks for User equality.
func ==(lhs: User, rhs: User) -> Bool {
    if lhs.name != rhs.name { return false }
    if lhs.email != rhs.email { return false }
    if lhs.id != rhs.id { return false }
    return true
}

/// This function checks for User inequality.
func !=(lhs: User, rhs: User) -> Bool {
    return !(lhs == rhs)
}