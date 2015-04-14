//
//  CloudStorable.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 31/3/15.
//  Maintained by Andhieka Putra.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

protocol CloudStorable {
    var classUrl: String { get }
    var requiresMultipart: Bool { get }
    
    var id: Int? { get }
    func setId(id: Int?)
    
    var isLocked: Bool { get }
    func lock()
    func unlock()
    
    /// This function is about LOADING the object. It should read simple properties
    /// from the provided dictionary and also call instantiate the complex 
    /// objects it depends on by calling either CloudStorageManager method
    /// or using the depended class's objectWithId(id) method.
    init(dictionary: NSDictionary)
    
    /// This function is about SAVING the object. It should return a dictionary
    /// representation of this object. If this object depends on another
    /// CloudStorable, you should indicate the dependence in getDependencies()
    /// method so that you can retrieve the depended objects' id and encode it in dictionary.
    func encodeWithDictionary(dictionary: NSMutableDictionary)
    
    /// This function is about SAVING the object. It should return all 
    /// CloudStorable objects that needs to be saved before this object can
    /// be saved. After these dependencies are saved to cloud, they will be
    /// guaranteed to have an id that you can make use of.
    func getDependencies() -> [CloudStorable]
}
