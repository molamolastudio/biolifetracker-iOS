//
//  BLTProjectProtocol.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 14/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

protocol BLTProjectProtocol {
    var name: String { get }
    var ethogram: Ethogram { get }
    var admins: [User] { get }
    var members: [User] { get }
    var sessions: [Session] { get }
    var individuals: [Individual] { get }
    
    func encodeRecursivelyWithDictionary(dictionary: NSMutableDictionary)
}