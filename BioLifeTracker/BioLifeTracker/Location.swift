//
//  Location.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 16/3/15.
//  Maintained by Li Jia'En, Nicholette.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

//  This is a data model class for Location.
//  This class contains methods to initialise Location instances,
//  get and set instance attributes.
//  This class also contains methods to store and retrieve saved
//  Location instances to the disk.
class Location: BiolifeModel {
    // Constants
    static let emptyString = ""
    static let locationKey = "location"
    
    static let ClassUrl = "locations"
    
    // Private Attributes
    private var _location: String // to change when we determine what maps to use
    
    // Accessor
    var location: String { get { return _location } }
    
    override init() {
        _location = Location.emptyString
        super.init()
    }
    
    convenience init(location: String) {
        self.init()
        self._location = location
    }
    
    override init(dictionary: NSDictionary, recursive: Bool) {
        _location = dictionary[Location.locationKey] as! String
        super.init(dictionary: dictionary, recursive: recursive)
    }
    
    convenience required init(dictionary: NSDictionary) {
        self.init(dictionary: dictionary, recursive: false)
    }
    
    /// This function updates the location.
    func updateLocation(location: String) {
        self._location = location
        updateLocation()
    }
    
    /// This is a private function to update the instance's createdAt, createdBy
    /// updatedBy and updatedAt.
    private func updateLocation() {
        updateInfo(updatedBy: UserAuthService.sharedInstance.user, updatedAt: NSDate())
    }
    
    
    // MARK: IMPLEMENTATION OF NSKEYEDARCHIVAL
    
    
    required init(coder aDecoder: NSCoder) {
        self._location = aDecoder.decodeObjectForKey(Location.locationKey) as! String
        super.init(coder: aDecoder)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_location, forKey: Location.locationKey)
    }
    
}

/// This function checks for location equality.
func ==(lhs: Location, rhs: Location) -> Bool {
    if lhs.location != rhs.location { return false }
    return true
}

/// This function checks for location inequality.
func !=(lhs: Location, rhs: Location) -> Bool {
    return !(lhs == rhs)
}

extension Location: CloudStorable {
    var classUrl: String { return Location.ClassUrl }
    
    func getDependencies() -> [CloudStorable] {
        return []
    }
    
    override func encodeWithDictionary(dictionary: NSMutableDictionary) {
        dictionary.setValue(location, forKey: Location.locationKey)
        super.encodeWithDictionary(dictionary)
    }
}

extension Location {
    override func encodeRecursivelyWithDictionary(dictionary: NSMutableDictionary) {
        dictionary.setValue(location, forKey: Location.locationKey)
        super.encodeRecursivelyWithDictionary(dictionary)
    }
}