//
//  CloudStorageUtils.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 9/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

/// Contains Cloud Storage static properties, and utility functions
/// for use across cloud storage classes.
struct CloudStorage {
    
    static var defaultUrl: String = "https://bltserver.herokuapp.com"
    static let userDefaults = NSUserDefaults.standardUserDefaults()
    
    static var serverUrl: String {
        get {
            userDefaults.synchronize()
            let useCustomUrl = userDefaults.boolForKey("use_custom_url_preference")
            if !useCustomUrl {
                return defaultUrl
            }
            let preferredUrl = userDefaults.stringForKey("server_url_preference")!
            if preferredUrl.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet()) == "" {
                return defaultUrl
            } else {
                return preferredUrl
            }
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "server_url_preference")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    static var networkThread: dispatch_queue_t = dispatch_queue_create(
        "com.cs3217.biolifetracker.network",
        DISPATCH_QUEUE_SERIAL)
    
    static let boundary = "$$BOUNDARY$$"
    
    // MARK: Network Operations
    
    
    static func makeMultipartRequestToUrl(url: NSURL, withMethod method: String, withPayload payload: NSData?) -> NSData? {
        var headers = [String: String]()
        headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        return makeRequestToUrl(url, withMethod: method, withPayload: payload, withHeaders: headers)
    }
    
    /// Synchronously sends the specified payload to the specified URL, with the specified HTTP method.
    /// Returns the NSData received as reply from server, if there is response.
    static func makeRequestToUrl(url: NSURL, withMethod method: String, withPayload payload: NSData?) -> NSData? {
        var headers = [String: String]()
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"
        return makeRequestToUrl(url, withMethod: method, withPayload: payload, withHeaders: headers)
    }
    
    static func makeRequestToUrl(url: NSURL, withMethod method: String, withPayload payload: NSData?, withHeaders headers: [String: String]) -> NSData? {
        NSLog("%@ %@", method, url)
        
        // sets up URL request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        if let accessToken = UserAuthService.sharedInstance.accessToken {
            request.setValue("Token \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        if let payload = payload {
            request.setValue("\(payload.length)", forHTTPHeaderField: "Content-Length")
            request.HTTPBody = payload
        }
        
        var uploadError: NSError?
        var response: NSURLResponse?
        let responseData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &uploadError)
        if (uploadError != nil) {
            NSLog("%@ Request To %@ Error: %@", method, url.description, uploadError!.userInfo!)
            return nil
        }
        return responseData
    }

    
    // MARK: NSDictionary Operations
    
    
    /// A debug "checkRep" function to assert that
    /// the two dictionaries are consistent. Does nothing if for every key
    /// in the source dictionary, there is the same value in both source and target.
    /// Otherwise, it will trigger an assertion error.
    /// Will not check for key that is in target but not in source dictionary.
    static func checkForItemCongruency(source: NSDictionary, target: NSDictionary) {
        for keyObject in source.allKeys{
            let key = keyObject as! String
            assert(source[key] != nil)
            assert(target[key] != nil, "The entry for \(key) is missing from server reply")
        }
    }
    
    
    // MARK: Interaction between NSDictionary and NSData
    
    
    static func dictionaryToMultipartData(dictionary: NSDictionary) -> NSData {
        var mutableData = NSMutableData()
        for entry in dictionary {
            appendObjectToMutableData(entry.key as! String,
                value: entry.value as! NSObject,
                body: mutableData)
        }
        return mutableData
    }
    
    static func encode(s: NSString) -> NSData {
        return s.dataUsingEncoding(NSUTF8StringEncoding)!
    }
    
    static func appendObjectToMutableData(key: String, value: NSObject, body: NSMutableData) {
        body.appendData(encode("\r\n--\(boundary)\r\n"))
        if let image = value as? UIImage {
            body.appendData(encode("Content-Disposition: form-data; name=\"\(key)\"; filename=\"image.jpg\"\r\n"))
            body.appendData(encode("Content-Type: application/octet-stream\r\n\r\n"))
            body.appendData(UIImageJPEGRepresentation(image, 1.0))
        } else if let number = value as? NSNumber {
            body.appendData(encode("Content-Disposition: form-data; name=\"\(key)\"\r\n"))
            body.appendData(encode("Content-Type: text/plain\r\n\r\n"))
            body.appendData(encode(number.stringValue))
        } else if let text = value as? String {
            body.appendData(encode("Content-Disposition: form-data; name=\"\(key)\"\r\n"))
            body.appendData(encode("Content-Type: text/plain\r\n\r\n"))
            body.appendData(encode(text))
        } else {
            NSLog("%@ Not Sent. Only NSString, NSNumber and UIImage are supported.", key)
        }
        let string = NSString(data: body, encoding: NSUTF8StringEncoding)
    }
    
    /// Serializes a dictionary into JSON and then convert it to NSData.
    /// Returns representation of dictionary in NSData. This function will fail
    /// if dictionary cannot be converted to JSON.
    static func dictionaryToJsonData(dictionary: NSDictionary) -> NSData {
        let data = serializeToJson(dictionary)
        assert(data != nil, "Fail to convert dictionary to data")
        return data!
    }
    
    /// Serializes a dictionary to JSON.
    /// Requires: All keys must be an instance of NSString.
    /// All values must be an instance of NSString, NSNumber, NSArray, NSDictionary, or NSNull
    static func serializeToJson(dictionary: NSDictionary) -> NSData? {
        var serializationError: NSError?
        let data = NSJSONSerialization.dataWithJSONObject(dictionary,
            options: NSJSONWritingOptions.PrettyPrinted,
            error: &serializationError)
        assert(data != nil, "Error serializing to JSON. JSON only allows NSString, NSNumber, NSArray, NSDictionary, or NSNull")
        
        //let requestJson = NSString(data: data!, encoding: NSUTF8StringEncoding)
        //NSLog("Request JSON is %@", requestJson!)
        
        // error handling
        if serializationError != nil {
            NSLog("JSON Serialization Error: %@", serializationError!.localizedDescription)
            return nil
        }
        return data
    }
    
    /// Deserializes a JSON data into NSDictionary.
    /// Will return the corresponding NSDictionary if successful.
    /// Otherwise, returns nil.
    static func readFromJsonAsDictionary(data: NSData) -> NSDictionary? {
        //let stringRepresentation = NSString(data: data, encoding: NSUTF8StringEncoding)
        //NSLog("Received data: %@", stringRepresentation!)
        
        var readingError: NSError?
        var dictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &readingError) as? NSDictionary
        if readingError != nil {
            NSLog("JSON Reading Error: %@", readingError!.localizedDescription)
            return nil
        }
        return dictionary
    }
    
    /// Deserializes a JSON data into NSArray.
    /// Will return the corresponding array of NSDictionary if successful.
    /// Otherwise, returns nil.
    static func readFromJsonAsArray(data: NSData) -> NSArray? {
        let stringRepresentation = NSString(data: data, encoding: NSUTF8StringEncoding)
        //NSLog("Received data: %@", stringRepresentation!)
        
        var readingError: NSError?
        var dictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &readingError) as? NSArray
        if readingError != nil {
            NSLog("JSON Reading Error: %@", readingError!.localizedDescription)
            return nil
        }
        return dictionary
    }

}
