//
//  DeleteTask.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 10/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

/// Prepares a task to DELETE an item from the server.
/// After an item is successfully deleted, its id will be erased and becomes
/// nil. However, the item will not be erased from memory and can still be used,
/// or even reuploaded after deletion (although it may mean getting a new id)
class DeleteTask: CloudStorageTask {
    
    let item: CloudStorable
    let serverUrl = NSURL(string: Constants.WebServer.serverUrl)!
    var description: String {
        return "DeleteTask for \(item.classUrl) : \(item.id)"
    }
    
    init(item: CloudStorable) {
        self.item = item
    }
    
    func execute() {
        if let id = item.id {
            item.lock()
            let destinationUrl = serverUrl
                .URLByAppendingPathComponent(item.classUrl)
                .URLByAppendingPathComponent(String(id))
                .URLByAppendingSlash()
            let responseData = CloudStorage.makeRequestToUrl(destinationUrl, withMethod: "DELETE", withPayload: nil)
            item.setId(nil)
            item.unlock()
            assert(responseData != nil)
        }
    }
}