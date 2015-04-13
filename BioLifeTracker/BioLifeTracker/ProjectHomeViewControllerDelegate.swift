//
//  ProjectHomeViewControllerDelegate.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 13/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

protocol ProjectHomeViewControllerDelegate {
    func userDidSelectSession(tag: Int, project: Project, session: Session)
    func userDidSelectMember(project: Project, member: User)
    func userDidChangeEthogram(project: Project, ethogram: Ethogram)
}
