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
    
    func addUser(user: User) {
        usersByName[user.name] = user
        users.append(user)
    }
    
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
            while candidate.name > excludedUsers[j].name { j++ }
            if candidate.name != excludedUsers[j].name {
                result.append(candidate)
            }
            i++
        }
        while (i < users.count) { result.append(users[i++]) }
        return result
    }
    
    func getUserWithName(name: String) -> User? {
        return usersByName[name]
    }
    
}
