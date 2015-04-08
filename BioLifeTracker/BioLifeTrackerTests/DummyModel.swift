//
//  DummyModel.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 5/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class DummyModel: BiolifeModel {
    
    var stringProperty: String = "Test string"
    var intProperty: Int = 1234567890
    var optionalStringProperty: String?
    var dateProperty: NSDate = NSDate()
    
    override init() {
        super.init()
    }

    required init(dictionary: NSDictionary) {
        //do nothing
        super.init()
    }
    
    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DummyModel: CloudStorable {
    var classUrl: String { return "dummy/" }
    
    func getDependencies() -> [CloudStorable] {
        return [] //this object does not depend on anything
    }
    
    func encodeWithDictionary(inout dictionary: NSMutableDictionary) {
        dictionary.setObject(stringProperty, forKey: "stringProperty")
        dictionary.setObject(intProperty, forKey: "intProperty")
        
        dictionary.setValue(optionalStringProperty, forKey: "optionalStringProperty")
        let dateFormatter = BiolifeDateFormatter()
        dictionary.setObject(dateFormatter.formatDate(dateProperty), forKey: "dateProperty")
        
    }
    
    func lock() { isLocked = true }
    func unlock() { isLocked = false }
    func setId(id: Int) { self.id = id }
    
}
