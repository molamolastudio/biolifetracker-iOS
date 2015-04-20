//
//  UserManager.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 20/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class UserManager {
    var users = [String: User]()
    
    class var sharedInstance: UserManager {
        struct Singleton {
            static let instance = UserManager()
        }
        return Singleton.instance
    }
    
    func addUser(user: User) {
        users[user.name] = user
    }
    
    func getAllUsers() -> [User] {
        var result = [User]()
        for user in users.values {
            result.append(user)
        }
        return result
    }
    
    func getUsersExcept(excludedUsers: [User]) -> [User] {
        // stub
        
        return []
    }
    
    func getUserWithName(name: String) -> User? {
        return users[name]
    }
    
}
