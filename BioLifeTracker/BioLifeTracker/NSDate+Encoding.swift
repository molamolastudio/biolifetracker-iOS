//
//  NSDate+Encoding.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 14/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

extension NSDate {
    /// Returns a String representation of the date using the format recognized
    /// by BioLifeTracker Web Server.
    func toBiolifeDateFormat() -> String {
        let dateFormatter = BiolifeDateFormatter()
        return dateFormatter.formatDate(self)
    }
}
