//
//  CloudStorageManager.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 6/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class CloudStorageManager {
    
    var globalCache = [String: [Int: NSDictionary]]()
    
    private init() { }
    
    class var sharedInstance: CloudStorageManager {
        struct Singleton {
            static let instance = CloudStorageManager()
        }
        return Singleton.instance
    }
    
    func clearCache() {
        globalCache.removeAll(keepCapacity: false)
    }
    
    /// Returns an NSDictionary representation of the specified item.
    /// Will simply return a cached item if item is already downloaded after the
    /// last time clearCache() is called. Otherwise, will synchronously download
    /// the item from server, puts it inside cache, and return the item.
    /// Will trigger an assertion error if the item does not exist on server.
    func getItemForClass(className: String, itemId: Int) -> NSDictionary {
        if globalCache[className] == nil {
            globalCache[className] = [Int: NSDictionary]()
        }
        var classCache = globalCache["className"]! // classCache is guaranteed to exist
        if let item = classCache[itemId] {
            return item // item is cached. simply return
        } else {
            let downloadTask = DownloadTask(className: className, itemId: itemId)
            downloadTask.execute() // download item synchronously
            assert(downloadTask.getResults().count == 1) // must always have one item
            let retrievedItem = downloadTask.getResults()[0]
            assert(retrievedItem["id"] as Int == itemId) // assert that item has correct id
            classCache[itemId] = retrievedItem
            return retrievedItem
        }
    }
    
}