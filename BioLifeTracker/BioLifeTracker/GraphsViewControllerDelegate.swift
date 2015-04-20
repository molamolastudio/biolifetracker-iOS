//
//  GraphsViewControllerDelegate.swift
//  BioLifeTracker
//
//  Created by Haritha on 12/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import UIKit

protocol GraphsViewControllerDelegate {
    func didAddUser(user: User)
    func didRemoveUser(user: User)
    func didAddSession(session: Session)
    func didRemoveSession(session: Session)
    func didAddState(state: BehaviourState)
    func didRemoveState(state: BehaviourState)
    func userDidSelectProject(project: Project)
}
