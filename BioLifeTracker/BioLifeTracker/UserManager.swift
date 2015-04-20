//
//  UserManager.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 20/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class UserManager {
    var usersByName = [String: User]()
    var users = [User]()
    
    class var sharedInstance: UserManager {
        struct Singleton {
            static let instance = UserManager()
        }
        return Singleton.instance
    }
    
    init() {
        loadUsersFromDisk()
    }
    
    func addUser(user: User) {
        usersByName[user.name] = user
        users.append(user)
    }
    
    /// Returns all users in alphabetical order (by name)
    func getAllUsers() -> [User] {
        sort(&users, { $0.name < $1.name })
        return users
    }
    
    /// Returns all users except the ones in the given list.
    func getUsersExcept(var excludedUsers: [User]) -> [User] {
        var result = [User]()
        sort(&users, { $0.name < $1.name })
        sort(&excludedUsers, { $0.name < $1.name })
        var i = 0, j = 0
        while (i < users.count && j < excludedUsers.count) {
            let candidate = users[i]
            while (candidate.name > excludedUsers[j].name && j < excludedUsers.count) {
                j++
            }
            if candidate.name != excludedUsers[j].name {
                result.append(candidate)
            }
            i++
        }
        while (i < users.count) { result.append(users[i++]) }
        return result
    }
    
    /// Same as getAllUsers(), but returns array of string (users' names).
    func getAllUsernames() -> [String] {
        let result = getAllUsers()
        return result.map { $0.name }
    }
    
    /// Same as getUsersExcept(:), but returns array of string (users' names).
    func getUsernamesExcept(var excludedUsers: [User]) -> [String] {
        let result = getUsersExcept(excludedUsers)
        return result.map { $0.name }
    }
    
    /// Get users with the given name, if found. Otherwise returns nil.
    func getUserWithName(name: String) -> User? {
        return usersByName[name]
    }
    
    func clearUsers() {
        users.removeAll(keepCapacity: false)
        usersByName.removeAll(keepCapacity: false)
    }
    
    func saveUsersToDisk() -> Bool {
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        
        if let dir = dirs?[0] {
            let path = dir.stringByAppendingPathComponent("all_users")
            let success = NSKeyedArchiver.archiveRootObject(users, toFile: path)
            return success
        }
        return false
    }
    
    func loadUsersFromDisk() {
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        
        if let dir = dirs?[0] {
            let path = dir.stringByAppendingPathComponent("all_users")
            let loadedUsers = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [User]
            if loadedUsers != nil { self.users = loadedUsers! }
        }
    }
    
}
