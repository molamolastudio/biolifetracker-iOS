//
//  CloudUploadTask.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 5/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class UploadTask: CloudStorageTask {
    var item: CloudStorable
    
    init(item: CloudStorable) {
        self.item = item
    }
    
    func execute() {
        // upload item and its dependencies to the cloud
    }
}
