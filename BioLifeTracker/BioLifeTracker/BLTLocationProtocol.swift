//
//  BLTLocationProtocol.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 14/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

protocol BLTLocationProtocol {
    var location: String { get }
    
    func encodeRecursivelyWithDictionary(dictionary: NSMutableDictionary)
}
