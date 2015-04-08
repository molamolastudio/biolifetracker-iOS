//
//  CloudUploadTask.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 5/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation


/// A subclass of CloudStorage task that is meant to prepare
/// for uploading a specified item and all its dependencies
class UploadTask: CloudStorageTask {
    var serverUrl = NSURL(string: Constants.WebServer.serverUrl)
    
    var item: CloudStorable
    var queue = [CloudStorable]()
    
    init(item: CloudStorable) {
        self.item = item
    }
    
    /// Upload item and its dependencies to the cloud
    func execute() {
        assert(serverUrl != nil, "Error: server url is not specified")
        enqueueDependencies(item)
        while !queue.isEmpty {
            let currentItem = queue.removeLast()
            
            // Handle item locking to prevent duplicate uploading
            if currentItem.isLocked { continue }
            currentItem.lock()
            
            // Serialize item to NSDictionary
            var dictionary = NSMutableDictionary()
            currentItem.encodeWithDictionary(&dictionary)
            
            var destinationUrl = serverUrl!.URLByAppendingPathComponent(currentItem.classUrl).URLByAppendingSlash()
            let responseDictionary = uploadDictionary(dictionary, toURL: destinationUrl)
            
            if responseDictionary == nil {
                NSLog("Response dictionary is nil. Cannot set item id.")
            } else {
                checkForItemCongruency(dictionary, target: responseDictionary!)
                let newId = responseDictionary!["id"] as Int?
                assert(newId != nil, "The server does not return item ID for \(currentItem.classUrl)")
                currentItem.setId(newId!)
            }
            
            // Unlock item
            currentItem.unlock()
        }
    }
    
    func checkForItemCongruency(source: NSDictionary, target: NSDictionary) {
        for keyObject in source.allKeys{
            let key = keyObject as String
            assert(source[key] != nil)
            assert(target[key] != nil, "The entry is mising from server reply")
            let originalValue = source[key] as NSObject
            let newValue = target[key] as NSObject
            if originalValue != newValue {
                NSLog("Returned value for key %@, (%@) does not match original (%@)", key, newValue, originalValue)
            }
        }
    }
    
    func enqueueDependencies(item: CloudStorable) {
        for dependedItem in item.getDependencies() {
            enqueueDependencies(dependedItem)
        }
        queue.append(item)
    }
    
    func uploadDictionary(dictionary: NSDictionary, toURL url: NSURL) -> NSDictionary? {
        let data = serializeToJson(dictionary)
        if data == nil {
            NSLog("Cannot upload nil data. Cancelling upload to %@", url)
            return nil // if data is nil, write a log and cancel upload
        }
        
        // if there is a valid data, continue with upload process
        assert(data != nil)
        let responseData = makePostRequestToUrl(url, withPayload: data!)
        if responseData == nil {
            NSLog("Dictionary has been uploaded to %@ but there is no response", url.description)
            return nil
        }
        
        assert(responseData != nil)
        let updatedDictionary = readFromJson(responseData!)
        return updatedDictionary
    }
    
    func makePostRequestToUrl(url: NSURL, withPayload payload: NSData) -> NSData? {
        // sets up URL request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(payload.length)", forHTTPHeaderField: "Content-Length")
        request.HTTPBody = payload
        
        var uploadError: NSError?
        var response: NSURLResponse?
        let responseData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &uploadError)
        if (uploadError != nil) {
            NSLog("POST Request Error: %@", uploadError!.userInfo!)
            return nil
        }
        return responseData
    }
    
    func serializeToJson(dictionary: NSDictionary) -> NSData? {
        var serializationError: NSError?
        let data = NSJSONSerialization.dataWithJSONObject(dictionary,
            options: NSJSONWritingOptions.PrettyPrinted,
            error: &serializationError)
        
        let requestJson = NSString(data: data!, encoding: NSUTF8StringEncoding)
        NSLog("Request JSON is %@", requestJson!)
        
        // error handling
        if serializationError != nil {
            NSLog("JSON Serialization Error: %@", serializationError!.localizedDescription)
            return nil
        }
        return data
    }
    
    func readFromJson(data: NSData) -> NSDictionary? {
        let stringRepresentation = NSString(data: data, encoding: NSUTF8StringEncoding)
        NSLog("Received data: %@", stringRepresentation!)
        
        var readingError: NSError?
        var dictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &readingError) as NSDictionary
        if readingError != nil {
            NSLog("JSON Reading Error: %@", readingError!.localizedDescription)
            return nil
        }
        return dictionary
    }
}

