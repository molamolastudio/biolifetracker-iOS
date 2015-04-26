//
//  BLTSessionProtocol.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 14/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

/// This protocol is to be implemented by external applications
/// that wishes to export their project to BioLifeTracker.
protocol BLTSessionProtocol {
    var type: SessionType { get }
    var name: String { get }
    var project: Project { get }
    var observations: [Observation] { get }
    var individuals: [Individual] { get }
    
    func encodeRecursivelyWithDictionary(dictionary: NSMutableDictionary)
}