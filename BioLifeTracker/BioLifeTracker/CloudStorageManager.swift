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
    var projectCache = [Int: Project]()
    var ethogramCache = [Int: Ethogram]()
    
    private init() {
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
    
    func getProjectWithId(id: Int) {
        
    }
    
    func getEthogramWithId(id: Int) {
        
    }
    
    func clearCache() {
        userCache.removeAll(keepCapacity: false)
        projectCache.removeAll(keepCapacity: false)
        ethogramCache.removeAll(keepCapacity: false)
    }
    
}