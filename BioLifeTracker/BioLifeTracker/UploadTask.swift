//
//  CloudUploadTask.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 5/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation


/// A subclass of CloudStorage task that is meant to prepare
/// for uploading a specified item and all its dependencies.
/// On successful execution, the item and all its recursive dependencies
/// will be assigned an id.
/// If an item already has an id, this task will send a PUT request instead
/// of POST request.
class UploadTask: CloudStorageTask {
    
    var serverUrl = NSURL(string: Constants.WebServer.serverUrl)!
    var item: CloudStorable
    var itemStack = [CloudStorable]()
    var description: String {
        return "UploadTask for \(item.classUrl) : \(item.id)"
    }
    
    init(item: CloudStorable) {
        self.item = item
    }

    /// Upload item and its dependencies to the cloud
    func execute() {
        stackDependencies(item)
        while !itemStack.isEmpty {
            let currentItem = itemStack.removeLast()
            
            // Handle item locking to prevent duplicate uploading
            if (currentItem.isLocked) { continue }
            currentItem.lock()
            
            // Serialize item to NSDictionary
            var dictionary = NSMutableDictionary()
            currentItem.encodeWithDictionary(dictionary)
            
            var payloadData = CloudStorage.dictionaryToData(dictionary)
            var responseData: NSData?
            var destinationUrl: NSURL
            if currentItem.id == nil { // item has not been uploaded before, therefore POST
                destinationUrl = serverUrl
                    .URLByAppendingPathComponent(currentItem.classUrl)
                    .URLByAppendingSlash()
                responseData = CloudStorage.makeRequestToUrl(destinationUrl, withMethod: "POST", withPayload: payloadData)
            } else { // item has been uploaded before, therefore PUT
                destinationUrl = serverUrl
                    .URLByAppendingPathComponent(currentItem.classUrl)
                    .URLByAppendingPathComponent(String(currentItem.id!))
                    .URLByAppendingSlash()
                responseData = CloudStorage.makeRequestToUrl(destinationUrl, withMethod: "PUT", withPayload: payloadData)
            }
            
            if responseData == nil {
                NSLog("There is no response from server", destinationUrl.description)
            }
            assert(responseData != nil)
            
            let responseDictionary = (responseData == nil) ? nil : CloudStorage.readFromJsonAsDictionary(responseData!)
            
            if responseDictionary == nil {
                NSLog("Response dictionary is nil. Cannot set item id.")
            } else {
                CloudStorage.checkForItemCongruency(dictionary, target: responseDictionary!)
                let newId = responseDictionary!["id"] as Int?
                assert(newId != nil, "The server does not return item ID for \(currentItem.classUrl)")
                currentItem.setId(newId!)
            }
            
            // Unlock item
            currentItem.unlock()
        }
    }
    
    func stackDependencies(item: CloudStorable) {
        itemStack.append(item)
        for dependedItem in item.getDependencies() {
            stackDependencies(dependedItem)
        }
    }

}
