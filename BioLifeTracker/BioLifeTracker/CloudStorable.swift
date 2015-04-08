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
    
    var id: Int? { get }
    func setId(id: Int)
    
    var isLocked: Bool { get }
    func lock()
    func unlock()
    
    init(dictionary: NSDictionary)
    func encodeWithDictionary(dictionary: NSMutableDictionary)
    
    func getDependencies() -> [CloudStorable]
}