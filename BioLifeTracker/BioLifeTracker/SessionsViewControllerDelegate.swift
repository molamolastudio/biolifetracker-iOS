//
//  SessionsViewControllerDelegate.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 6/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

protocol SessionsViewControllerDelegate {
    func userDidSelectSession(selectedProject: Project, selectedSession: Session)
}
