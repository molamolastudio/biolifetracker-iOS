//
//  BiolifeDateFormatter.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 8/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class BiolifeDateFormatter {
    var dateFormatter = NSDateFormatter()

    init() {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSSSSSZ"
    }
    
    func formatDate(date: NSDate) -> String {
        return dateFormatter.stringFromDate(date)
    }
}