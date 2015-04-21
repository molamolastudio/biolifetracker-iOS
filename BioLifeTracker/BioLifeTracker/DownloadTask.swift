//
//  DownloadTask.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 5/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

/// Prepares a task to download item(s) from the server. After execution,
/// you can retrieve the results using the provided getResults() function.
class DownloadTask: CloudStorageTask {
    private let serverUrl = NSURL(string: CloudStorage.serverUrl)!
    
    private var classUrl: String
    private var itemId: Int?
    private var results = [NSDictionary]()
    var completedSuccessfully: Bool?
    var description: String {
        if let itemId = itemId {
            return "Downloading \(classUrl) with id \(itemId)"
        } else {
            return "Downloading all \(classUrl)"
        }
    }
    
    init(classUrl: String) {
        self.classUrl = classUrl
    }
    
    init(classUrl: String, itemId: Int) {
        self.classUrl = classUrl
        self.itemId = itemId
    }
    
    func execute() {
        results.removeAll(keepCapacity: false) // clear results first
        
        var destinationUrl = serverUrl
            .URLByAppendingPathComponent(classUrl)
            .URLByAppendingSlash()
        if (itemId != nil) {
            destinationUrl = destinationUrl
                .URLByAppendingPathComponent(String(itemId!))
                .URLByAppendingSlash()
        }
        let responseData = CloudStorage.makeRequestToUrl(destinationUrl, withMethod: "GET", withPayload: nil)
        if responseData == nil {
            completedSuccessfully = false
        } else {
            if (itemId == nil) {
                let responseArray = CloudStorage.readFromJsonAsArray(responseData!)
                if (responseArray == nil) { completedSuccessfully = false; return }
                assert(responseArray != nil, "Fail to translate JSON to array")
                for item in responseArray! {
                    results.append(item as! NSDictionary)
                }
            } else {
                let responseDictionary = CloudStorage.readFromJsonAsDictionary(responseData!)
                assert(responseDictionary != nil, "Fail to translate JSON to dictionary")
                results.append(responseDictionary!)
            }
            completedSuccessfully = true
        }
    }
    
    func getResults() -> [NSDictionary] {
        return results
    }
    
}
