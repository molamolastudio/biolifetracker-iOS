//
//  CloudStorageManager.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 6/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class CloudStorageManager {
    
    var userCache = [Int: User]()
    
    private init() {
        // read from local storage
    }
    
    class var sharedInstance: CloudStorageManager {
        struct Singleton {
            static let instance = CloudStorageManager()
        }
        return Singleton.instance
    }
    
    func getUserWithId(id: Int) -> User {
        if let cachedUser = userCache[id] {
            return cachedUser
        } else {
//            let downloadTask = DownloadTask<User>(id)
//             download user. when finished, return
            return UserAuthService.sharedInstance.user //method stub
        }
    }
    
    func synchronize() {
        // upload all data
        // download all data
    }
}