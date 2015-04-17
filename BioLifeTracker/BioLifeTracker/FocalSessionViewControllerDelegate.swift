//
//  FocalSessionViewControllerDelegate.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 16/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

protocol FocalSessionViewControllerDelegate {
    func userDidSelectObservation(session: Session, observation: Observation)
}