//
//  BLTProjectDeserializer.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 14/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class BLTProjectDeserializer {
    
    init() {
        
    }
    
    /// This function should receive a file url indicating where an encoded
    /// project has been stored. It should read the file, construct a Project
    /// object with all its hierarcy (sessions, behaviours, etc.) and return
    /// the constructed project hierarcy upon completion.
    func process(url: NSURL) -> Project? {
        if let data = readDataFromUrl(url) {
            if let dictionary = readFromJsonAsDictionary(data) {
                let project = Project(dictionary: dictionary, recursive: true)
                return project
            }
        }
        return nil
    }
    
    func readDataFromUrl(url: NSURL) -> NSData? {
        var readingError: NSError?
        let data = NSData(contentsOfURL: url,
            options: nil,
            error: &readingError)
        if readingError != nil {
            NSLog("Error reading data: %@", readingError!.localizedDescription)
            return nil
        }
        return data
    }
    
    /// Deserializes a JSON data into NSDictionary.
    /// Will return the corresponding NSDictionary if successful.
    /// Otherwise, returns nil.
    func readFromJsonAsDictionary(data: NSData) -> NSDictionary? {
        var readingError: NSError?
        var dictionary = NSJSONSerialization.JSONObjectWithData(data,
            options: NSJSONReadingOptions(0),
            error: &readingError) as? NSDictionary
        if readingError != nil {
            NSLog("JSON Reading Error: %@", readingError!.localizedDescription)
            return nil
        }
        return dictionary
    }

}