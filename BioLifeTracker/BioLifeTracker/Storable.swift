//
//  Storable.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 25/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

protocol Storable: NSCoding {
    
    func saveToArchives()
    class func loadFromArchives(identifier: String) -> NSObject?
    class func deleteFromArchives(identifier: String) -> Bool
}