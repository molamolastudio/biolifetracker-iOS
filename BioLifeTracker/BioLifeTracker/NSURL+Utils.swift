//
//  NSURL+Utils.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 8/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

extension NSURL {
    /// Returns an NSURL that ends with a slash.
    /// Return itself if already ends with a slash
    func URLByAppendingSlash() -> NSURL {
        if self.endsWithSlash { return self }
        return self.URLByAppendingPathComponent("/")
    }
    
    /// Returns whether this URL ends with a slash
    var endsWithSlash: Bool {
        if let urlString = self.absoluteString {
            return urlString.hasSuffix("/")
        } else {
            return false
        }
    }
}
