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
    
    init(project: Project) {
        self.project = project
    }
    
    /// This function will encode self.project into data and then save it
    /// into disk, using the provided fileName (or decide on a default filename
    /// if not provided). Upon successful saving, this function should return
    /// a file url indicating the location where the file has been saved.
    func writeToFileAndRetrieveFileUrl(fileName: String = "") -> NSURL {
        
        return NSURL.fileURLWithPath("path to saved file")!
    }
}