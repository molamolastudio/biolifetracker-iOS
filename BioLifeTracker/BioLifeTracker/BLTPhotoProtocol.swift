//
//  BLTPhotoProtocol.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 14/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

protocol BLTPhotoProtocol {
    var image: UIImage { get }
    
    func encodeRecursivelyWithDictionary(dictionary: NSMutableDictionary)
}