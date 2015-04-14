//
//  BLTEthogramProtocol.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 14/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

protocol BLTEthogramProtocol {
    var name: String { get }
    var information: String { get }
    var behaviourStates: [BehaviourState] { get }
    
    func encodeRecursivelyWithDictionary(dictionary: NSMutableDictionary)
}