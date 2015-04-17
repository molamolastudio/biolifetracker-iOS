//
//  BLTProjectSerializer.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 14/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class BLTProjectSerializer {
    var project: Project
    var targetUrl: NSURL?
    
    init(project: Project) {
        self.project = project
    }
    
    /// This function will encode self.project into data and then save it
    /// into disk, using the provided fileName (or decide on a default filename
    /// if not provided). Upon successful saving, this function should return
    /// a file url indicating the location where the file has been saved.
    func writeToFileAndRetrieveFileUrl(fileName: String = "") -> NSURL? {
        let fileManager = (NSFileManager.defaultManager())
        let directories  = NSSearchPathForDirectoriesInDomains(
            NSSearchPathDirectory.DocumentDirectory,
            NSSearchPathDomainMask.AllDomainsMask,
            true) as? [String]
        
        if let directories = directories {
            let targetDirectory = directories[0]
            let fileName = "\(project.name).bltproject"
            let fileLocation = targetDirectory.stringByAppendingPathComponent(fileName)
            let dispatchQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
            dispatch_async(dispatchQueue, {
                var dictionary = NSMutableDictionary()
                self.project.encodeRecursivelyWithDictionary(dictionary)
                let data = self.serializeToJson(dictionary)
                assert(data != nil, "Error serializing project")
                data?.writeToFile(fileLocation, atomically: true)
            })
            return NSURL.fileURLWithPath(fileLocation)!
        }
        return nil
    }
    
    /// Serializes a dictionary to JSON.
    /// Requires: All keys must be an instance of NSString.
    /// All values must be an instance of NSString, NSNumber, NSArray, NSDictionary, or NSNull
    func serializeToJson(dictionary: NSDictionary) -> NSData? {
        var serializationError: NSError?
        let data = NSJSONSerialization.dataWithJSONObject(dictionary,
            options: NSJSONWritingOptions(0),
            error: &serializationError)
        assert(data != nil, "Error serializing to JSON. JSON only allows NSString, NSNumber, NSArray, NSDictionary, or NSNull")
        
        // error handling
        if serializationError != nil {
            NSLog("JSON Serialization Error: %@", serializationError!.localizedDescription)
            return nil
        }
        return data
    }
}