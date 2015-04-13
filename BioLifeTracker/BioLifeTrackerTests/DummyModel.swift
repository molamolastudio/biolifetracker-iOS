//
//  DummyModel.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 5/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class DummyModel: BiolifeModel {
    class var ClassUrl: String { return "dummy" }
    override var requiresMultipart: Bool { return false }
    
    var stringProperty: String = "Test string"
    var intProperty: Int = 1234567890
    var optionalStringProperty: String?
    var dateProperty: NSDate = NSDate()
    var friends = [DummyModel]()
    
    override init() {
        super.init()
    }

    override required init(dictionary: NSDictionary) {
        let dateFormatter = BiolifeDateFormatter()
        
        dateProperty = dateFormatter.getDate(dictionary["dateProperty"] as! String)
        intProperty = dictionary["intProperty"] as! Int
        optionalStringProperty = dictionary["optionalStringProperty"] as? String
        stringProperty = dictionary["stringProperty"] as! String
        friends = DummyModel.retrieveFriends(dictionary["friends"] as! [Int])
        
        super.init(dictionary: dictionary)
    }
    
    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DummyModel: CloudStorable {
    var classUrl: String { return DummyModel.ClassUrl }
    
    func getDependencies() -> [CloudStorable] {
        var dependencies = [CloudStorable]()
        for friend in friends {
            dependencies.append(friend)
        }
        return dependencies
    }
    
    override func encodeWithDictionary(dictionary: NSMutableDictionary) {
        super.encodeWithDictionary(dictionary)
        let dateFormatter = BiolifeDateFormatter()
        dictionary.setValue(stringProperty, forKey: "stringProperty")
        dictionary.setValue(intProperty, forKey: "intProperty")
        dictionary.setValue(optionalStringProperty, forKey: "optionalStringProperty")
        dictionary.setValue(dateFormatter.formatDate(dateProperty), forKey: "dateProperty")
        dictionary.setValue(friendsIdList, forKey: "friends")
    }
    
    var friendsIdList: [Int] {
        var friendsId = [Int]()
        for friend in friends {
            assert(friend.id != nil, "Friend must have been uploaded beforehand")
            friendsId.append(friend.id!)
        }
        return friendsId
    }
    
    class func retrieveFriends(idList: [Int]) -> [DummyModel] {
        let manager = CloudStorageManager.sharedInstance
        var friends = [DummyModel]()
        for friendId in idList {
            let friendData = manager.getItemForClass(DummyModel.ClassUrl, itemId: friendId)
            let friend = DummyModel(dictionary: friendData)
            friends.append(friend)
        }
        return friends
    }
    
}
