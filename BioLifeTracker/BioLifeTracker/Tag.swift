//
//  Tag.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 30/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Tag: BiolifeModel {
    private var _tag: String
    var tag: String {
        get { return _tag }
    }
    
    override init() {
        _tag = ""
        super.init()
    }
    
    init(tag: String) {
        self._tag = tag
        super.init()
    }
    
    func updateTag(tag: String) {
        self._tag = tag
        updateTag()
    }
    
    private func updateTag() {
        updatedBy = UserAuthService.sharedInstance.user
        updatedAt = NSDate()
    }
    
    required init(coder aDecoder: NSCoder) {
        self._tag = aDecoder.decodeObjectForKey("tag") as String
        super.init(coder: aDecoder)
    }
    
}

extension Tag: NSCoding {
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_tag, forKey: "tag")
    }
}