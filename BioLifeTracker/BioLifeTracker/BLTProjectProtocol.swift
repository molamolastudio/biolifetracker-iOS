//
//  BLTProjectProtocol.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 14/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

/// This protocol is to be implemented by external applications
/// that wishes to export their project to BioLifeTracker.
protocol BLTProjectProtocol {
    var name: String { get }
    var ethogram: Ethogram { get }
    var admins: [User] { get }
    var members: [User] { get }
    var sessions: [Session] { get }
    var individuals: [Individual] { get }
    
    /// This function encodes the instance into a dictionary.
    func encodeRecursivelyWithDictionary(dictionary: NSMutableDictionary)
}