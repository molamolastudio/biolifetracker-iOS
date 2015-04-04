//
//  ProjectStorageTest.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 3/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import XCTest

class ProjectTests: XCTestCase {
    let state1 = BehaviourState(name: "Feeding", information: "Small claws bringing food to mouth")
    let state2 = BehaviourState(name: "Fighting", information: "Engagement of large clawa with another crab")
    let state3 = BehaviourState(name: "Hiding", information: "Withdrawal of fiddler crab into its burrow")
    var ethogram = Ethogram(name: "Fiddler Crabs")

    
    let user1 = User(name: "Captain America", email: "iamcaptamerica@default.com")
    let user2 = User(name: "The Hulk", email: "iamgreen@default.com")
    let user3 = User(name: "Black Power Ranger", email: "black.ranger@default.com")

    func testSaveLoadProject() {
        ethogram.addBehaviourState(state1)
        var project = Project(name: "A Day in a Fiddler Crab life", ethogram: ethogram)

        // Testing correctness of project details
        var retrieved = Project.loadFromArchives("A Day in a Fiddler Crab life") as Project?
        XCTAssert(retrieved?.name == "A Day in a Fiddler Crab life", "Project not saved")
        
        // Testing correctness of admin and member at initialisation
        retrieved = Project.loadFromArchives("A Day in a Fiddler Crab life") as Project?
        var containsAdmin = false
        for admin in retrieved!.admins {
            if admin.toString() == UserAuthService.sharedInstance.user.toString() {
                containsAdmin = true
            }
        }
        XCTAssert(containsAdmin == true, "Project not initialised properly")
        
        var containsMember = false
        for member in retrieved!.members {
            if member.toString() == UserAuthService.sharedInstance.user.toString() {
                containsMember = true
            }
        }
        XCTAssert(containsMember == true, "Project not initialised properly")
        
        // Testing correctness of adding admin and member
        project.addAdmins([user2])
        project.addMembers([user3])
        
        retrieved = Project.loadFromArchives("A Day in a Fiddler Crab life") as Project?
        containsAdmin = false
        for admin in retrieved!.admins {
            if admin.toString() == "The Hulk" {
                containsAdmin = true
            }
        }
        XCTAssert(containsAdmin == true, "Admin not added properly")
        
        containsAdmin = false
        for admin in retrieved!.admins {
            if admin.toString() == "Black Power Ranger" {
                containsAdmin = true
            }
        }
        XCTAssert(containsAdmin == false, "Normal user not added properly, got into admin")
        
        containsMember = false
        for member in retrieved!.members {
            if member.toString() == "The Hulk" {
                containsMember = true
            }
        }
        XCTAssert(containsMember == true, "Admin not added as member properly")
        
        containsMember = false
        for member in retrieved!.members {
            if member.toString() == "Black Power Ranger" {
                containsMember = true
            }
        }
        XCTAssert(containsMember == true, "Normal user not added properly")

        
        // Testing session and observation
        var session = Session(project: project, type: SessionType.Scan)
        let individual = Individual(label: "M1")
        let observation1 = Observation(session: session, individual: individual, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        session.addObservation([observation1])
        
        project.addSessions([session])
        retrieved = Project.loadFromArchives("A Day in a Fiddler Crab life") as Project?
        
        XCTAssert(retrieved?.sessions[0].observations[0].information == "Eating vigourously", "Project not saved properly")
        XCTAssert(retrieved?.sessions[0].type == SessionType.Scan, "Project not saved properly")
        
        
        
        XCTAssert(retrieved?.ethogram.name == "Fiddler Crabs", "Ethogram in project not saved")
        XCTAssert(retrieved?.ethogram.creator.toString() == UserAuthService.sharedInstance.user.toString(), "Ethogram not saved")
        
        XCTAssert(retrieved?.ethogram.behaviourStates[0].name == "Feeding", "BS in Ethogram not saved")
        XCTAssert(retrieved?.ethogram.behaviourStates[0].information == "Small claws bringing food to mouth", "BS in Ethogram not saved")
    }
    
}