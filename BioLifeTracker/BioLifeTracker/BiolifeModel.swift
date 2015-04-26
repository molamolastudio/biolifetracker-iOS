//
//  BiolifeModel.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 29/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

/// This is a superclass for the data models to inherit from.
/// The properties to inherit are createdAt, createdBy, updatedAt
/// and updatedBy. These are used for file systems permission.
class BiolifeModel: NSObject, NSCoding {
    // Constants
    static let idKey = "id"
    static let createdAtKey = "createdAt"
    static let createdByKey = "createdBy"
    static let updatedAtKey = "updatedAt"
    static let updatedByKey = "updatedBy"
    static let createdAtCloudKey = "created_at"
    static let createdByCloudKey = "created_by"
    static let updatedAtCloudKey = "updated_at"
    static let updatedByCloudKey = "updated_by"
    
    var id: Int?
    var isLocked: Bool = false
    var requiresMultipart: Bool { return false }
    
    // Private attributes
    private var _createdAt: NSDate
    private var _updatedAt: NSDate
    private var _createdBy: User
    private var _updatedBy: User
    
    // Accessors
    var createdAt: NSDate { get { return _createdAt } }
    var updatedAt: NSDate { get { return _updatedAt } }
    var createdBy: User { get { return _createdBy } }
    var updatedBy: User { get { return _updatedBy } }
    
    /// This function initiates an instance of BiolifeModel.
    override init() {
        _createdBy = UserAuthService.sharedInstance.user
        _updatedBy = UserAuthService.sharedInstance.user
        _createdAt = NSDate()
        _updatedAt = NSDate()
        super.init()
    }
    
    /// This function updates the BiolifeModel properties.
    func updateInfo(#updatedBy: User, updatedAt: NSDate) {
        _updatedBy = updatedBy
        _updatedAt = updatedAt
    }
    
    /// This function is for testing only.
    /// This function changes the creator of the data model.
    func changeCreator(creator: User) {
        _createdBy = creator
    }
    
    // MARK: IMPLEMENTATION FOR NSKEYEDARCHIVAL
    
    required init(coder decoder: NSCoder) {
        id = decoder.decodeObjectForKey(BiolifeModel.idKey) as? Int
        _createdAt = decoder.decodeObjectForKey(
                                BiolifeModel.createdAtKey) as! NSDate
        _updatedAt = decoder.decodeObjectForKey(
                                BiolifeModel.updatedAtKey) as! NSDate
        _createdBy = decoder.decodeObjectForKey(
                                BiolifeModel.createdByKey) as! User
        _updatedBy = decoder.decodeObjectForKey(
                                BiolifeModel.updatedByKey) as! User
        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(id, forKey: BiolifeModel.idKey)
        coder.encodeObject(_createdAt, forKey: BiolifeModel.createdAtKey)
        coder.encodeObject(_updatedAt, forKey: BiolifeModel.updatedAtKey)
        coder.encodeObject(_createdBy, forKey: BiolifeModel.createdByKey)
        coder.encodeObject(_updatedBy, forKey: BiolifeModel.updatedByKey)
    }
    
    // MARK: SET OF FUNCTIONALITIES FOR CLOUDSTORABLE PROTOCOL

    
    init(dictionary: NSDictionary, recursive: Bool) {
        let dateFormatter = BiolifeDateFormatter()
        self.id = dictionary[BiolifeModel.idKey] as? Int
        self._createdAt = dateFormatter.getDate(
                            dictionary[BiolifeModel.createdAtCloudKey] as! String)
        self._updatedAt = dateFormatter.getDate(
                            dictionary[BiolifeModel.updatedAtCloudKey] as! String)
        if recursive {
            if let createdByInfo = dictionary[BiolifeModel.createdByCloudKey]
                            as? NSDictionary {
                _createdBy = User(dictionary: createdByInfo, recursive: true)
            } else {
                _createdBy = UserAuthService.sharedInstance.user
            }
            if let updatedByInfo = dictionary[BiolifeModel.updatedByCloudKey]
                            as? NSDictionary {
                _updatedBy = User(dictionary: updatedByInfo, recursive: true)
            } else {
                _updatedBy = UserAuthService.sharedInstance.user
            }
        } else {
            let manager = CloudStorageManager.sharedInstance
            // retrieve dictionary of createdBy and updatedBy
            let createdByDictionary = manager.getItemForClass(User.ClassUrl,
                itemId: dictionary[BiolifeModel.createdByCloudKey] as! Int)
            let updatedByDictionary = manager.getItemForClass(User.ClassUrl,
                itemId: dictionary[BiolifeModel.updatedByCloudKey] as! Int)
            // instantiate createdBy and updatedBy user object
            self._createdBy = User(dictionary: createdByDictionary)
            self._updatedBy = User(dictionary: updatedByDictionary)
        }
        super.init()
    }
    
    required convenience init(dictionary: NSDictionary) {
        self.init(dictionary: dictionary, recursive: false)
    }

    func setId(id: Int?) { self.id = id }
    func lock() { isLocked = true }
    func unlock() { isLocked = false }
    
    /// This function encodes the instance into a dictionary.
    func encodeWithDictionary(dictionary: NSMutableDictionary) {
        let dateFormatter = BiolifeDateFormatter()
        dictionary.setValue(dateFormatter.formatDate(
                        createdAt), forKey: BiolifeModel.createdAtCloudKey)
        dictionary.setValue(dateFormatter.formatDate(
                        updatedAt), forKey: BiolifeModel.updatedAtCloudKey)
        dictionary.setValue(createdBy.id, forKey: BiolifeModel.createdByCloudKey)
        dictionary.setValue(updatedBy.id, forKey: BiolifeModel.updatedByCloudKey)
    }
}

extension BiolifeModel {
    /// This function encodes the instance into a dictionary.
    func encodeRecursivelyWithDictionary(dictionary: NSMutableDictionary) {
        let dateFormatter = BiolifeDateFormatter()
        dictionary.setValue(dateFormatter.formatDate(
                        createdAt), forKey: BiolifeModel.createdAtCloudKey)
        dictionary.setValue(dateFormatter.formatDate(
                        updatedAt), forKey: BiolifeModel.updatedAtCloudKey)
        
        let createdByDictionary = NSMutableDictionary()
        createdBy.encodeRecursivelyWithDictionary(createdByDictionary)
        dictionary.setValue(
                createdByDictionary, forKey: BiolifeModel.createdByCloudKey)
        
        let updatedByDictionary = NSMutableDictionary()
        updatedBy.encodeRecursivelyWithDictionary(updatedByDictionary)
        dictionary.setValue(
                updatedByDictionary, forKey: BiolifeModel.updatedByCloudKey)
    }
}
