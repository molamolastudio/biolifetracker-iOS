//
//  MenuViewControllerDelegate.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 2/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

protocol MenuViewControllerDelegate {
    func userDidSelectProjects()
    func userDidSelectEthograms()
    func userDidSelectAnalysis()
    func userDidSelectLogout()
    func userDidSelectSessions(project: Project)
    func userDidSelectIndividuals(project: Project)
}