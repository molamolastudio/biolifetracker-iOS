//
//  Photo.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 12/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//
//  This is a data model class for Photo.
//  This class contains methods to initialise Photo instances,
//  get and set instance attributes.
//  This class also contains methods to store and retrieve saved
//  Photo instances to the disk.

import Foundation

class Photo: BiolifeModel {
    // Constants
    static let imageKey = "image"
    
    static var ClassUrl: String { return "photos" }
    
    override var requiresMultipart: Bool { return true }
    
    // Private Attributes
    private var _image: UIImage
    
    // Accessors
    var image: UIImage { get { return _image } }
    
    /// This function initialises a new photo instance.
    init(image: UIImage) {
        // compress image first to a reasonable size
        let compressedData = UIImageJPEGRepresentation(image, 0.9)
        self._image = UIImage(data: compressedData)!
        super.init()
    }
    
    override init(dictionary: NSDictionary, recursive: Bool) {
        if recursive {
            let imageData = NSData(base64EncodedString: dictionary[Photo.imageKey] as! String, options: nil)
            _image = UIImage(data: imageData!)!
        } else {
            let imageUrl = NSURL(string: dictionary[Photo.imageKey] as! String)!
            let imageData = CloudStorage.makeRequestToUrl(imageUrl, withMethod: "GET", withPayload: nil)
            assert(imageData != nil, "Cannot get image binary from server")
            let image = UIImage(data: imageData!)
            assert(image != nil, "Cannot convert binary data into UIImage")
            self._image = image!
        }
        super.init(dictionary: dictionary, recursive: recursive)
    }
    
    required convenience init(dictionary: NSDictionary) {
        self.init(dictionary: dictionary, recursive: false)
    }
    
    /// This function updates the image of the Photo instance.
    func updateImage(image: UIImage) {
        self._image = image
        updateImage()
    }
    
    /// This is a private function to update the instance's createdAt, createdBy
    /// updatedBy and updatedAt.
    private func updateImage() {
        updateInfo(updatedBy: UserAuthService.sharedInstance.user,
            updatedAt: NSDate())
    }
    
    /// This function returns photos with the specified ids.
    class func photoWithId(id: Int) -> Photo {
        let manager = CloudStorageManager.sharedInstance
        let photoDictionary = manager.getItemForClass(ClassUrl, itemId: id)
        return Photo(dictionary: photoDictionary)
    }

    
    // MARK: IMPLEMENTATION OF NSKEYEDARCHIVAL
    
    
    required init(coder aDecoder: NSCoder) {
        self._image = aDecoder.decodeObjectForKey(Photo.imageKey) as! UIImage
        super.init(coder: aDecoder)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_image, forKey: Photo.imageKey)
    }
}

/// This function checks for photo equality.
func ==(lhs: Photo, rhs: Photo) -> Bool {
    return lhs.image.size == rhs.image.size
}

/// This function checks for photo inequality.
func !=(lhs: Photo, rhs: Photo) -> Bool {
    return !(lhs == rhs)
}

extension Photo: CloudStorable {
    var classUrl: String { return Photo.ClassUrl }
    
    func getDependencies() -> [CloudStorable] {
        return [] // no dependencies
    }
    
    override func encodeWithDictionary(dictionary: NSMutableDictionary) {
        dictionary.setValue(image, forKey: Photo.imageKey)
        super.encodeWithDictionary(dictionary)
    }
}

extension Photo {
    override func encodeRecursivelyWithDictionary(dictionary: NSMutableDictionary) {
        let imageString = UIImageJPEGRepresentation(image, 0.9)
            .base64EncodedStringWithOptions(nil)
        dictionary.setValue(imageString, forKey: Photo.imageKey)
        super.encodeRecursivelyWithDictionary(dictionary)
    }
}
