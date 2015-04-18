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
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
    }
    
    func formatDate(date: NSDate) -> String {
        return dateFormatter.stringFromDate(date)
    }
    
    func getDate(string: String) -> NSDate {
        if let date = dateFormatter.dateFromString(string) {
            return date
        } else {
            NSLog("Error retrieving date from string: %@. Returning default value...", string)
            return NSDate()
        }
    }
}
