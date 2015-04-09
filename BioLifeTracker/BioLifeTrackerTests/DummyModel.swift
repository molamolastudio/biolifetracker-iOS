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

    override required init(dictionary: NSDictionary) {
        // read values from dictionary here
        let dateFormatter = BiolifeDateFormatter()
        dateProperty = dateFormatter.getDate(dictionary["dateProperty"] as String)
        intProperty = dictionary["intProperty"] as Int
        optionalStringProperty = dictionary["optionalStringProperty"] as String?
        stringProperty = dictionary["stringProperty"] as String
        // call parent class' init
        super.init(dictionary: dictionary)
    }
    
    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DummyModel: CloudStorable {
    var classUrl: String { return "dummy" }
    
    func getDependencies() -> [CloudStorable] {
        return [] //this object does not depend on anything
    }
    
    override func encodeWithDictionary(dictionary: NSMutableDictionary) {
        super.encodeWithDictionary(dictionary)
        dictionary.setValue(stringProperty, forKey: "stringProperty")
        dictionary.setValue(intProperty, forKey: "intProperty")
        
        dictionary.setValue(optionalStringProperty, forKey: "optionalStringProperty")
        let dateFormatter = BiolifeDateFormatter()
        dictionary.setValue(dateFormatter.formatDate(dateProperty), forKey: "dateProperty")
        
    }
    
}
