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
    
    required override init(dictionary: NSDictionary) {
        _tag = dictionary["tag"] as! String
        super.init(dictionary: dictionary)
    }
    
    func updateTag(tag: String) {
        self._tag = tag
        updateTag()
    }
    
    private func updateTag() {
        updateInfo(updatedBy: UserAuthService.sharedInstance.user,
            updatedAt: NSDate())
    }
    
    required init(coder aDecoder: NSCoder) {
        self._tag = aDecoder.decodeObjectForKey("tag") as! String
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
    return lhs.tag == rhs.tag
}

extension Tag: NSCoding {
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_tag, forKey: "tag")
    }
}

extension Tag: CloudStorable {
    var classUrl: String { return Tag.ClassUrl }
    
    func getDependencies() -> [CloudStorable] {
        var dependencies = [CloudStorable]()
        // append dependencies here
        return dependencies
    }
    
    override func encodeWithDictionary(dictionary: NSMutableDictionary) {
        dictionary.setValue(tag, forKey: "name")
        super.encodeWithDictionary(dictionary)
    }
}
