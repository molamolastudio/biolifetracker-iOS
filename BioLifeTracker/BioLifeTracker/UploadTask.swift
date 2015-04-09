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
    var serverUrl = NSURL(string: Constants.WebServer.serverUrl)!
    
    var item: CloudStorable
    var itemStack = [CloudStorable]()
    
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
            
            var payloadData = dictionaryToData(dictionary)
            var responseData: NSData?
            var destinationUrl: NSURL
            if currentItem.id == nil { // item has not been uploaded before, therefore POST
                destinationUrl = serverUrl
                    .URLByAppendingPathComponent(currentItem.classUrl)
                    .URLByAppendingSlash()
                responseData = makeRequestToUrl(destinationUrl, withMethod: "POST", withPayload: payloadData)
            } else { // item has been uploaded before, therefore PUT
                destinationUrl = serverUrl
                    .URLByAppendingPathComponent(currentItem.classUrl)
                    .URLByAppendingPathComponent(String(currentItem.id!))
                    .URLByAppendingSlash()
                responseData = makeRequestToUrl(destinationUrl, withMethod: "PUT", withPayload: payloadData)
            }
            
            if responseData == nil {
                NSLog("There is no response from server", destinationUrl.description)
            }
            assert(responseData != nil)
            let responseDictionary = (responseData == nil) ? nil : readFromJson(responseData!)
            
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
            assert(target[key] != nil, "The entry for \(key) is mising from server reply")
            let originalValue = source[key] as NSObject
            let newValue = target[key] as NSObject
            if originalValue != newValue {
                NSLog("Returned value for key %@, (%@) does not match original (%@)", key, newValue, originalValue)
            }
        }
    }
    
    func stackDependencies(item: CloudStorable) {
        itemStack.append(item)
        for dependedItem in item.getDependencies() {
            stackDependencies(dependedItem)
        }
    }
    
    func dictionaryToData(dictionary: NSDictionary) -> NSData {
        let data = serializeToJson(dictionary)
        assert(data != nil, "Fail to convert dictionary to data")
        return data!
    }
    
    func makeRequestToUrl(url: NSURL, withMethod method: String, withPayload payload: NSData) -> NSData? {
        // sets up URL request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method
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
    
    /// Serializes a dictionary to JSON.
    /// Requires: All keys must be an instance of NSString.
    /// All values must be an instance of NSString, NSNumber, NSArray, NSDictionary, or NSNull
    func serializeToJson(dictionary: NSDictionary) -> NSData? {
        var serializationError: NSError?
        let data = NSJSONSerialization.dataWithJSONObject(dictionary,
            options: NSJSONWritingOptions.PrettyPrinted,
            error: &serializationError)
        assert(data != nil, "Error serializing to JSON. JSON only allows NSString, NSNumber, NSArray, NSDictionary, or NSNull")
        
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

