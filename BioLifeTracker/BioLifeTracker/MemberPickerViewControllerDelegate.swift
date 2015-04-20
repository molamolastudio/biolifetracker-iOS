//
//  MemberPickerViewControllerDelegate.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 20/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

protocol MemberPickerViewControllerDelegate {
    func userDidSelectMember(member: User)
}