//
//  Individual.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 16/3/15.
//  Maintained by Li Jia'En, Nicholette.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

//  This is a data model class for Individual.
//  This class contains methods to initialise Individual instances,
//  get and set instance attributes.
//  This class also contains methods to store and retrieve saved
//  Individual instances to the disk.
class Individual: BiolifeModel {
    // Constants
    static let emptyString = ""
    static let labelKey = "label"
    static let tagsKey = "tags"
    static let photoKey = "photo"
    
    static let ClassUrl = "individuals"
    
    // Private attributes
    private var _label: String
    private var _tags: [Tag]
    private var _photo: Photo?
    
    // Accessors
    var label: String { get { return _label } }
    var tags: [Tag] { get { return _tags } }
    var photo: Photo? { get { return _photo } }

    override init() {
        self._label = Individual.emptyString
        self._tags = []
        super.init()
    }
    
    convenience init(label: String) {
        self.init()
        self._label = label
    }
    
    override init(dictionary: NSDictionary, recursive: Bool) {
        _label = dictionary[Individual.labelKey] as! String
        if recursive {
            let tagInfos = dictionary[Individual.tagsKey] as! [NSDictionary]
            _tags = tagInfos.map { Tag(dictionary: $0, recursive: true) }
            if let photoInfo = dictionary[Individual.photoKey] as? NSDictionary {
                _photo = Photo(dictionary: photoInfo, recursive: true)
            }
        } else {
            _tags = Tag.tagsWithIds(dictionary[Individual.tagsKey] as! [Int])
            if let photoId = dictionary[Individual.photoKey] as? Int {
                _photo = Photo.photoWithId(photoId)
            }
        }
        super.init(dictionary: dictionary, recursive: recursive)
    }
    
    required convenience init(dictionary: NSDictionary) {
        self.init(dictionary: dictionary, recursive: false)
    }

    
    // MARK: METHODS FOR INDIVIDUAL
    
    
    /// This function is used to update the label of an individual.
    func updateLabel(label: String) {
        self._label = label
        updateIndividual()
    }
    
    /// This function is used to update the photo of an individual.
    func updatePhoto(photo: Photo?) {
        self._photo = photo
        updateIndividual()
    }
    
    /// This function is used to add tags to an individual.
    func addTag(tag: Tag) {
        self._tags.append(tag)
        updateIndividual()
    }
    
    /// This function is used to remove the tag at a specified index.
    func removeTagAtIndex(index: Int) {
        self._tags.removeAtIndex(index)
        updateIndividual()
    }
    
    /// This is a private function to update the instance's createdAt, createdBy
    /// updatedBy and updatedAt.
    private func updateIndividual() {
        updateInfo(updatedBy: UserAuthService.sharedInstance.user, updatedAt: NSDate())
    }
    
    
    // MARK: IMPLEMENTATION OF NSKEYEDARCHIVAL
    
    
    required init(coder aDecoder: NSCoder) {
        var enumerator: NSEnumerator
        self._label = aDecoder.decodeObjectForKey(Individual.labelKey) as! String
        self._photo = aDecoder.decodeObjectForKey(Individual.photoKey) as? Photo
        
        let objectTags: AnyObject = aDecoder.decodeObjectForKey(Individual.tagsKey)!
        enumerator = objectTags.objectEnumerator()
        self._tags = []
        while true {
            let tag = enumerator.nextObject() as? Tag
            if tag == nil {
                break
            }
            self._tags.append(tag!)
        }

        super.init(coder: aDecoder)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_label, forKey: Individual.labelKey)
        aCoder.encodeObject(_photo, forKey: Individual.photoKey)
        aCoder.encodeObject(_tags, forKey: Individual.tagsKey)
    }
}

/// This function checks for individual equality.
func ==(lhs: Individual, rhs: Individual) -> Bool {
    if lhs.label != rhs.label { return false }
    if lhs.tags != rhs.tags { return false }
    if lhs.photo != rhs.photo { return false }
    return true
}

/// This function checks for individual inequality.
func !=(lhs: Individual, rhs: Individual) -> Bool {
    return !(lhs == rhs)
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
        dictionary.setValue(label, forKey: Individual.labelKey)
        dictionary.setValue(photo?.id, forKey: Individual.photoKey)
        dictionary.setValue(tags.map { $0.id! }, forKey: Individual.tagsKey)
    }
}

extension Individual {
    override func encodeRecursivelyWithDictionary(dictionary: NSMutableDictionary) {
        dictionary.setValue(label, forKey: Individual.labelKey)

        var photoDictionary = NSMutableDictionary()
        if let photo = photo {
            photo.encodeRecursivelyWithDictionary(photoDictionary)
            dictionary.setValue(photoDictionary, forKey: Individual.photoKey)
        }
        
        var tagInfos = [NSDictionary]()
        for tag in tags {
            var tagDictionary = NSMutableDictionary()
            tag.encodeRecursivelyWithDictionary(tagDictionary)
            tagInfos.append(tagDictionary)
        }
        dictionary.setValue(tagInfos, forKey: Individual.tagsKey)
        
        super.encodeRecursivelyWithDictionary(dictionary)
    }
}