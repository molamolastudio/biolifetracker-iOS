//
//  BiolifeDateFormatter.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 8/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

/// Formats date in a format compatible with BioLifeTracker
/// Web Service API.
class BiolifeDateFormatter {
    var dateFormatter = NSDateFormatter()
    var dateFormatterNoMillis = NSDateFormatter()
    
    init() {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        dateFormatterNoMillis.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    }
    
    func formatDate(date: NSDate) -> String {
        return dateFormatter.stringFromDate(date)
    }
    
    func getDate(string: String) -> NSDate {
        if let date = dateFormatter.dateFromString(string) {
            return date
        } else if let date = dateFormatterNoMillis.dateFromString(string) {
            return date
        } else {
            NSLog("Error retrieving date from string: %@. Returning default value...", string)
            return NSDate()
        }
    }
}
