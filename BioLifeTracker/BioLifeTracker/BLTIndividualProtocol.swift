//
//  BLTIndividualProtocol.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 14/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

protocol BLTIndividualProtocol {
    var label: String { get }
    var tags: [Tag] { get }
    var photo: Photo? { get }

    func encodeRecursivelyWithDictionary(dictionary: NSMutableDictionary)
}