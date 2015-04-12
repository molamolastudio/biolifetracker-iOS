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
    
    var image: UIImage
    
    init(image: UIImage) {
        self.image = image
        super.init()
    }
    
    required override init(dictionary: NSDictionary) {
        let imageUrl = NSURL(string: dictionary["image"] as! String)!
        let imageData = CloudStorage.makeRequestToUrl(imageUrl, withMethod: "GET", withPayload: nil)
        assert(imageData != nil, "Cannot get image binary from server")
        let image = UIImage(data: imageData!)
        assert(image != nil, "Cannot convert binary data into UIImage")
        self.image = image!
        super.init(dictionary: dictionary)
    }

    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func photoWithId(id: Int) -> Photo {
        let manager = CloudStorageManager.sharedInstance
        let photoDictionary = manager.getItemForClass(ClassUrl, itemId: id)
        return Photo(dictionary: photoDictionary)
    }
}

extension Photo: CloudStorable {
    var classUrl: String { return Photo.ClassUrl }
    
    func getDependencies() -> [CloudStorable] {
        return [] // no dependencies
    }
    
    override func encodeWithDictionary(dictionary: NSMutableDictionary) {
        fatalError("Photo::encodeWithDictionary has not been implemented")
        super.encodeWithDictionary(dictionary)
    }
}