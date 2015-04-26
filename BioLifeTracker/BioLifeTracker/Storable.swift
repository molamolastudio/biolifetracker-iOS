//
//  Storable.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 25/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

/// This protocol specifies the necessary methods required to store data
/// into the disk.
protocol Storable: NSCoding {
    
    func saveToArchives()
    static func loadFromArchives(identifier: String) -> NSObject?
    static func deleteFromArchives(identifier: String) -> Bool
}