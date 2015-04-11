//
//  CloudStorable.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 31/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

protocol CloudStorable {
    static var classUrl: String { get }
    var id: String? { get set }
    func upload()
    func getDependencies() -> [CloudStorable]
}