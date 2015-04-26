//
//  BLTPhotoProtocol.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 14/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import UIKit

/// This protocol is to be implemented by external applications
/// that wishes to export their project to BioLifeTracker.
protocol BLTPhotoProtocol {
    var image: UIImage { get }
    
    func encodeRecursivelyWithDictionary(dictionary: NSMutableDictionary)
}