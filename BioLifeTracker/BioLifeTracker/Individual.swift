//
//  Individual.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 16/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Individual: BiolifeModel {
    private var _label: String
    private var _tags: [Tag]
    private var _photo: UIImage?
    private var _photoUrls:[String]
    
    var label: String { get { return _label } }
    var tags: [Tag] { get { return _tags } }
    var photo: UIImage? { get { return _photo } }
    var photoUrls: [String] { get { return _photoUrls } }

    override init() {
        self._label = ""
        self._tags = []
        self._photoUrls = [String]()
        super.init()
    }
    
    convenience init(label: String) {
        self.init()
        self._label = label
    }
    
    /*****************Individual*******************/
    func updateLabel(label: String) {
        self._label = label
        updateIndividual()
    }
    
    func updatePhoto(photo: UIImage) {
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
    
    func addPhotoUrl(url: String) {
        self._photoUrls.append(url)
        updateIndividual()
    }
    
    func removePhotoUrlAtIndex(index: Int) {
        self._photoUrls.removeAtIndex(index)
        updateIndividual()
    }
    
    private func updateIndividual() {
        updateInfo(updatedBy: UserAuthService.sharedInstance.user, updatedAt: NSDate())
    }
    
    required init(coder aDecoder: NSCoder) {
        var enumerator: NSEnumerator
        self._label = aDecoder.decodeObjectForKey("label") as! String
        self._photo = aDecoder.decodeObjectForKey("photo") as! UIImage?
        let objectPhotoUrls: AnyObject = aDecoder.decodeObjectForKey("photoUrls")!
        enumerator = objectPhotoUrls.objectEnumerator()
        self._photoUrls = Array<String>()
        while true {
            let url = enumerator.nextObject() as! String?
            if url == nil {
                break
            }
            
            self._photoUrls.append(url!)
        }
        
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
}

func ==(lhs: Individual, rhs: Individual) -> Bool {
    return lhs.label == rhs.label && lhs.tags == rhs.tags
            && lhs.photo == rhs.photo && lhs.photoUrls == rhs.photoUrls
}


extension Individual: NSCoding {
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_label, forKey: "label")
        aCoder.encodeObject(_photo, forKey: "photo")
        aCoder.encodeObject(_photoUrls, forKey: "photoUrls")
        aCoder.encodeObject(_tags, forKey: "tags")
    }
}

//extension Individual: CloudStorable {
//    class var classUrl: String { return "Individual" }
//    func upload() { }
//    func getDependencies() -> [CloudStorable] { return [] }
//}
