//
//  DownloadTask.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 5/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class DownloadTask: CloudStorageTask {
    
    var className: String
    var id: Int?
    
    init(className: String) {
        self.className = className
    }
    
    init(className: String, id: Int) {
        self.className = className
        self.id = id
    }
    
    func execute() {
        // download
    }
    
    func getResults() -> [CloudStorable] {
        return []
    }
}
