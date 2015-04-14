//
//  Individual.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 16/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Individual: BiolifeModel, BLTIndividualProtocol {
    static let ClassUrl = "individuals"
    
    private var _label: String
    private var _tags: [Tag]
    private var _photo: Photo?
    
    var label: String { get { return _label } }
    var tags: [Tag] { get { return _tags } }
    var photo: Photo? { get { return _photo } }

    override init() {
        self._label = ""
        self._tags = []
        super.init()
    }
    
    convenience init(label: String) {
        self.init()
        self._label = label
    }
    
    required override init(dictionary: NSDictionary) {
        _label = dictionary["label"] as! String
        _tags = Tag.tagsWithIds(dictionary["tags"] as! [Int])
        if let photoId = dictionary["photo"] as? Int {
            _photo = Photo.photoWithId(photoId)
        }
        super.init(dictionary: dictionary)
    }
    
    /*****************Individual*******************/
    func updateLabel(label: String) {
        self._label = label
        updateIndividual()
    }
    
    func updatePhoto(photo: Photo?) {
        self._photo = photo
        updateIndividual()
    }
    
    func addTag(tag: Tag) {
        self._tags.append(tag)
        updateIndividual()
    }
    
    func removeTagAtIndex(index: Int) {
        self._tags.removeAtIndex(index)
        updateIndividual()
    }
    
    private func updateIndividual() {
        updateInfo(updatedBy: UserAuthService.sharedInstance.user, updatedAt: NSDate())
    }
    
    required init(coder aDecoder: NSCoder) {
        var enumerator: NSEnumerator
        self._label = aDecoder.decodeObjectForKey("label") as! String
        self._photo = aDecoder.decodeObjectForKey("photo") as! Photo?
        
        let objectTags: AnyObject = aDecoder.decodeObjectForKey("tags")!
        enumerator = objectTags.objectEnumerator()
        self._tags = []
        while true {
            let tag = enumerator.nextObject() as! Tag?
            if tag == nil {
                break
            }
            self._tags.append(tag!)
        }

        super.init(coder: aDecoder)
    }
    
    class func individualWithId(id: Int) -> Individual {
        let manager = CloudStorageManager.sharedInstance
        let individualDictionary = manager.getItemForClass(ClassUrl, itemId: id)
        return Individual(dictionary: individualDictionary)
    }
}

func ==(lhs: Individual, rhs: Individual) -> Bool {
    if lhs.label != rhs.label { return false }
    if lhs.tags != rhs.tags { return false }
    if lhs.photo != rhs.photo { return false }
    return true
}


extension Individual: NSCoding {
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_label, forKey: "label")
        aCoder.encodeObject(_photo, forKey: "photo")
        aCoder.encodeObject(_tags, forKey: "tags")
    }
}


extension Individual: CloudStorable {
    var classUrl: String { return Individual.ClassUrl }
    
    func getDependencies() -> [CloudStorable] {
        var dependencies = [CloudStorable]()
        tags.map { dependencies.append($0) }
        if photo != nil { dependencies.append(photo!) }
        return dependencies
    }
    
    override func encodeWithDictionary(dictionary: NSMutableDictionary) {
        super.encodeWithDictionary(dictionary)
        dictionary.setValue(label, forKey: "label")
        dictionary.setValue(photo?.id, forKey: "photo")
        dictionary.setValue(tags.map { $0.id! }, forKey: "tags")
    }
}

extension Individual {
    func encodeRecursivelyWithDictionary(dictionary: NSMutableDictionary) {
        dictionary.setValue(label, forKey: "label")

        var photoDictionary = NSMutableDictionary()
        if let photo = photo {
            photo.encodeRecursivelyWithDictionary(photoDictionary)
        }
        dictionary.setValue(photoDictionary, forKey: "photo")
        
        var tagInfos = [NSDictionary]()
        for tag in tags {
            var tagDictionary = NSMutableDictionary()
            tag.encodeRecursivelyWithDictionary(tagDictionary)
            tagInfos.append(tagDictionary)
        }
        dictionary.setValue(tagInfos, forKey: "tags")
        
        super.encodeWithDictionary(dictionary)
    }
}