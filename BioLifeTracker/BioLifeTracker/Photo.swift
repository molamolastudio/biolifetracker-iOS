//
//  Photo.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 12/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Photo: BiolifeModel {
    static var ClassUrl: String { return "photos" }
    override var requiresMultipart: Bool { return true }
    
    private var _image: UIImage
    var image: UIImage { get { return _image } }
    
    init(image: UIImage) {
        self._image = image
        super.init()
    }
    
    required override init(dictionary: NSDictionary) {
        let imageUrl = NSURL(string: dictionary["image"] as! String)!
        let imageData = CloudStorage.makeRequestToUrl(imageUrl, withMethod: "GET", withPayload: nil)
        assert(imageData != nil, "Cannot get image binary from server")
        let image = UIImage(data: imageData!)
        assert(image != nil, "Cannot convert binary data into UIImage")
        self._image = image!
        super.init(dictionary: dictionary)
    }
    
    func updateImage(image: UIImage) {
        self._image = image
        updateImage()
    }
    
    private func updateImage() {
        updateInfo(updatedBy: UserAuthService.sharedInstance.user,
            updatedAt: NSDate())
    }

    required init(coder aDecoder: NSCoder) {
        self._image = aDecoder.decodeObjectForKey("image") as! UIImage
        super.init(coder: aDecoder)
    }
    
    class func photoWithId(id: Int) -> Photo {
        let manager = CloudStorageManager.sharedInstance
        let photoDictionary = manager.getItemForClass(ClassUrl, itemId: id)
        return Photo(dictionary: photoDictionary)
    }
}

extension Photo: NSCoding {
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_image, forKey: "image")
    }
}

extension Photo: CloudStorable {
    var classUrl: String { return Photo.ClassUrl }
    
    func getDependencies() -> [CloudStorable] {
        return [] // no dependencies
    }
    
    override func encodeWithDictionary(dictionary: NSMutableDictionary) {
        dictionary.setValue(image, forKey: "image")
        super.encodeWithDictionary(dictionary)
    }
}

extension Photo {
    override func encodeRecursivelyWithDictionary(dictionary: NSMutableDictionary) {
        let imageString = UIImageJPEGRepresentation(image, 1.0)
            .base64EncodedStringWithOptions(nil)
        dictionary.setValue(imageString, forKey: "image")
    }
}
