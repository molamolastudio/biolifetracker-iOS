//
//  SessionsViewControllerDelegate.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 14/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

protocol ScanSessionViewControllerDelegate {
    func userDidSelectScan(session: Session, index: Int)
}