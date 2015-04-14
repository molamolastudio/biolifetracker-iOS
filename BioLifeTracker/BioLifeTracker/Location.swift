//
//  Location.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 16/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class Location: BiolifeModel, BLTLocationProtocol {
    static let ClassUrl = "locations"
    
    private var _location: String // to change when we determine what maps to use
    var location: String { get { return _location } }
    
    override init() {
        _location = ""
        super.init()
    }
    
    convenience init(location: String) {
        self.init()
        self._location = location
    }
    
    func updateLocation(location: String) {
        self._location = location
        updateLocation()
    }
    
    private func updateLocation() {
        updateInfo(updatedBy: UserAuthService.sharedInstance.user, updatedAt: NSDate())
    }
    
    required init(coder aDecoder: NSCoder) {
        self._location = aDecoder.decodeObjectForKey("location") as! String
        super.init(coder: aDecoder)
    }
    
    override required init(dictionary: NSDictionary) {
        _location = dictionary["location"] as! String
        super.init(dictionary: dictionary)
    }
    
    class func locationWithId(id: Int) -> Location {
        let manager = CloudStorageManager.sharedInstance
        let locationDictionary = manager.getItemForClass(ClassUrl, itemId: id)
        return Location(dictionary: locationDictionary)
    }
}

func ==(lhs: Location, rhs: Location) -> Bool {
    if lhs.location != rhs.location { return false }
    return true
}

extension Location: NSCoding {
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_location, forKey: "location")
    }
}

extension Location: CloudStorable {
    var classUrl: String { return Location.ClassUrl }
    
    func getDependencies() -> [CloudStorable] {
        return []
    }
    
    override func encodeWithDictionary(dictionary: NSMutableDictionary) {
        dictionary.setValue(location, forKey: "location")
        super.encodeWithDictionary(dictionary)
    }
}

extension Location: BLTLocationProtocol {
    override func encodeRecursivelyWithDictionary(dictionary: NSMutableDictionary) {
        encodeWithDictionary(dictionary)
    }
}