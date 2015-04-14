//
//  Tag.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 30/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Tag: BiolifeModel {
    static let ClassUrl = "tags"
    
    private var _name: String
    var name: String {
        get { return _name }
    }
    
    override init() {
        _name = ""
        super.init()
    }
    
    init(name: String) {
        self._name = name
        super.init()
    }
    
    required override init(dictionary: NSDictionary) {
        _name = dictionary["name"] as! String
        super.init(dictionary: dictionary)
    }
    
    func updateName(name: String) {
        self._name = name
        updateTag()
    }
    
    private func updateTag() {
        updateInfo(updatedBy: UserAuthService.sharedInstance.user,
            updatedAt: NSDate())
    }
    
    required init(coder aDecoder: NSCoder) {
        self._name = aDecoder.decodeObjectForKey("name") as! String
        super.init(coder: aDecoder)
    }
    
    class func tagsWithIds(idList: [Int]) -> [Tag] {
        let manager = CloudStorageManager.sharedInstance
        return idList.map {
            Tag(dictionary: manager.getItemForClass(Tag.ClassUrl, itemId: $0))
        }
    }
    
}

func ==(lhs: Tag, rhs: Tag) -> Bool {
    return lhs.name == rhs.name
}

extension Tag: NSCoding {
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_name, forKey: "name")
    }
}

extension Tag: CloudStorable {
    var classUrl: String { return Tag.ClassUrl }
    
    func getDependencies() -> [CloudStorable] {
        return []
    }
    
    override func encodeWithDictionary(dictionary: NSMutableDictionary) {
        dictionary.setValue(name, forKey: "name")
        super.encodeWithDictionary(dictionary)
    }
}

extension Tag {
    func encodeRecursivelyWithDictionary(dictionary: NSMutableDictionary) {
        encodeWithDictionary(dictionary)
    }
}
