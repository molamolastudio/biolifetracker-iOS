//
//  CloudStorageManager.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 6/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class CloudStorageManager {
    
    var globalCache: [String: [Int: NSDictionary]]
    var individualCache: [Int: Individual]
    
    private init() {
        globalCache = [String: [Int: NSDictionary]]()
        individualCache = [Int: Individual]()
    }
    
    class var sharedInstance: CloudStorageManager {
        struct Singleton {
            static let instance = CloudStorageManager()
        }
        return Singleton.instance
    }
    
    func clearCache() {
        globalCache.removeAll(keepCapacity: false)
        individualCache.removeAll(keepCapacity: false)
    }
    
    /// Returns an NSDictionary representation of the specified item.
    /// Will simply return a cached item if item is already downloaded after the
    /// last time clearCache() is called. Otherwise, will synchronously download
    /// the item from server, puts it inside cache, and return the item.
    /// Will trigger an assertion error if the item does not exist on server.
    func getItemForClass(classUrl: String, itemId: Int) -> NSDictionary {
        if globalCache[classUrl] == nil {
            globalCache[classUrl] = [Int: NSDictionary]()
        }
        var classCache = globalCache[classUrl]! // classCache is guaranteed to exist
        if let item = classCache[itemId] {
            return item // item is cached. simply return
        } else {
            let downloadTask = DownloadTask(classUrl: classUrl, itemId: itemId)
            downloadTask.execute() // download item synchronously
            assert(downloadTask.getResults().count == 1) // must always have one item
            let retrievedItem = downloadTask.getResults()[0]
            assert(retrievedItem["id"] as! Int == itemId) // assert that item has correct id
            classCache[itemId] = retrievedItem
            globalCache[classUrl] = classCache
            
            return retrievedItem
        }
    }
    
    /// Returns a cached "Individual" object. This is to prevent initializing
    /// the same "Individual" object many times, resulting in each object taking
    /// its own space in memory.
    func getIndividualWithId(id: Int) -> Individual {
        if let individual = individualCache[id] {
            return individual
        } else {
            let individualDictionary = getItemForClass(Individual.ClassUrl, itemId: id)
            let individual = Individual(dictionary: individualDictionary)
            individualCache[id] = individual
            return individual
        }
    }
    
    func putIntoCache(classUrl: String, itemInfo: NSDictionary) {
        if globalCache[classUrl] == nil {
            globalCache[classUrl] = [Int: NSDictionary]()
        }
        var classCache = globalCache[classUrl]! // classCache is guaranteed to exist
        
        if let itemId = itemInfo["id"] as? Int {
            classCache[itemId] = itemInfo
            globalCache[classUrl] = classCache
            assert(globalCache[classUrl]![itemId] == itemInfo)
        }
    }
}
