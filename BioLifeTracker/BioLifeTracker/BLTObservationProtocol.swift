//
//  BLTObservationProtocol.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 14/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

protocol BLTObservationProtocol {
    var session: Session! { get }
    var state: BehaviourState { get }
    var information: String { get }
    var timestamp: NSDate { get }
    var photo: Photo? { get }
    var individual: Individual { get }
    var location: Location? { get }
    var weather: Weather? { get }
    
    func encodeRecursivelyWithDictionary(dictionary: NSMutableDictionary)
}