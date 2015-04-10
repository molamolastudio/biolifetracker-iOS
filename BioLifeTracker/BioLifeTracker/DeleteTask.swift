//
//  DeleteTask.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 10/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class DeleteTask: CloudStorageTask {
    
    let item: CloudStorable
    let serverUrl = NSURL(string: Constants.WebServer.serverUrl)!
    
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