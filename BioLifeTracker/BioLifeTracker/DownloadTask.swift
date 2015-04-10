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
    private let serverUrl = NSURL(string: Constants.WebServer.serverUrl)!
    
    private var classUrl: String
    private var itemId: Int?
    private var results = [NSDictionary]()
    var description: String {
        return "DownloadTask for \(classUrl) : \(itemId)"
    }
    
    init(className: String) {
        self.classUrl = className
    }
    
    init(className: String, itemId: Int) {
        self.classUrl = className
        self.itemId = itemId
    }
    
    func execute() {
        var destinationUrl = serverUrl
            .URLByAppendingPathComponent(classUrl)
            .URLByAppendingSlash()
        if (itemId != nil) {
            destinationUrl = destinationUrl
                .URLByAppendingPathComponent(String(itemId!))
                .URLByAppendingSlash()
        }
        
        let responseData = CloudStorage.makeRequestToUrl(destinationUrl, withMethod: "GET", withPayload: nil)
        assert(responseData != nil, "There is no response from server")
        
        if (itemId == nil) {
            let responseArray = CloudStorage.readFromJsonAsArray(responseData!)
            assert(responseArray != nil, "Fail to translate JSON to array")
            for item in responseArray! {
                results.append(item as NSDictionary)
            }
        } else {
            let responseDictionary = CloudStorage.readFromJsonAsDictionary(responseData!)
            assert(responseDictionary != nil, "Fail to translate JSON to dictionary")
            results.append(responseDictionary!)
        }
    }
    
    func getResults() -> [NSDictionary] {
        return results
    }
    
}
