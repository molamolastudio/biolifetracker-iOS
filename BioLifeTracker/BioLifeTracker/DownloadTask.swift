//
//  DownloadTask.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 5/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation


class DownloadTask<T: CloudStorable>: CloudStorageTask {
    
    var itemId: Int?
    var completionHandler: ((items: [T]) -> Void)?
    var results = [T]()
    
    init() { }
    
    init(forItemWithId itemId: Int) {
        self.itemId = itemId
    }
    
    func setCompletionHandler(completionHandler: ((items: [T]) -> Void)?) {
        self.completionHandler = completionHandler
    }
    
    // download the specified items and then call completionHandler
    func execute() {
        //download items

        
        // call completion handler
        if let completionHandler = completionHandler {
            completionHandler(items: results)
        }
        
    }
    
    func getResults() -> [T] {
        return results
    }
}
