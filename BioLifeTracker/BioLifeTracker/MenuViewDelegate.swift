//
//  MenuViewDelegate.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 2/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

protocol MenuViewDelegate {
    func userDidSelectProjects()
    func userDidSelectEthograms()
    func userDidSelectGraphs()
    func userDidSelectData()
    func userDidSelectSettings()
    func userDidSelectFacebookLogin()
    func userDidSelectGoogleLogin()
    func userDidSelectLogout()
    func userDidSelectSessions(project: Project)
    func userDidSelectIndividuals(project: Project)
    func userDidSelectObservations(project: Project, session: Session)
}