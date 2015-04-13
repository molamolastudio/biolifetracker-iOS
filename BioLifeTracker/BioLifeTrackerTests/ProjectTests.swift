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

// This test case is meant to check for the correctness of saving individual projects
// Please uncomment savedToArchives in Project class before using this test case
    
//    func testSaveLoadProject() {
//        ethogram.addBehaviourState(state1)
//        var project = Project(name: "A Day in a Fiddler Crab life", ethogram: ethogram)
//
//        // Testing correctness of project details
//        var retrieved = Project.loadFromArchives("A Day in a Fiddler Crab life") as Project?
//        XCTAssert(retrieved?.name == "A Day in a Fiddler Crab life", "Project not saved")
//        
//        // Testing correctness of admin and member at initialisation
//        retrieved = Project.loadFromArchives("A Day in a Fiddler Crab life") as Project?
//        var containsAdmin = false
//        for admin in retrieved!.admins {
//            if admin.toString() == UserAuthService.sharedInstance.user.toString() {
//                containsAdmin = true
//            }
//        }
//        XCTAssert(containsAdmin == true, "Project not initialised properly")
//        
//        var containsMember = false
//        for member in retrieved!.members {
//            if member.toString() == UserAuthService.sharedInstance.user.toString() {
//                containsMember = true
//            }
//        }
//        XCTAssert(containsMember == true, "Project not initialised properly")
//        
//        // Testing correctness of adding admin and member
//        project.addAdmins([user2])
//        project.addMembers([user3])
//        
//        retrieved = Project.loadFromArchives("A Day in a Fiddler Crab life") as Project?
//        containsAdmin = false
//        for admin in retrieved!.admins {
//            if admin.toString() == "The Hulk" {
//                containsAdmin = true
//            }
//        }
//        XCTAssert(containsAdmin == true, "Admin not added properly")
//        
//        containsAdmin = false
//        for admin in retrieved!.admins {
//            if admin.toString() == "Black Power Ranger" {
//                containsAdmin = true
//            }
//        }
//        XCTAssert(containsAdmin == false, "Normal user not added properly, got into admin")
//        
//        containsMember = false
//        for member in retrieved!.members {
//            if member.toString() == "The Hulk" {
//                containsMember = true
//            }
//        }
//        XCTAssert(containsMember == true, "Admin not added as member properly")
//        
//        containsMember = false
//        for member in retrieved!.members {
//            if member.toString() == "Black Power Ranger" {
//                containsMember = true
//            }
//        }
//        XCTAssert(containsMember == true, "Normal user not added properly")
//
//        
//        // Testing session and observation
//        var session = Session(project: project, type: SessionType.Scan)
//        let individual = Individual(label: "M1")
//        let observation1 = Observation(session: session, individual: individual, state: state1, timestamp: NSDate(), information: "Eating vigourously")
//        session.addObservation([observation1])
//        
//        project.addSessions([session])
//        retrieved = Project.loadFromArchives("A Day in a Fiddler Crab life") as Project?
//        
//        XCTAssert(retrieved?.sessions[0].observations[0].information == "Eating vigourously", "Project not saved properly")
//        XCTAssert(retrieved?.sessions[0].type == SessionType.Scan, "Project not saved properly")
//        
//        
//        
//        XCTAssert(retrieved?.ethogram.name == "Fiddler Crabs", "Ethogram in project not saved")
//        XCTAssert(retrieved?.ethogram.creator.toString() == UserAuthService.sharedInstance.user.toString(), "Ethogram not saved")
//        
//        XCTAssert(retrieved?.ethogram.behaviourStates[0].name == "Feeding", "BS in Ethogram not saved")
//        XCTAssert(retrieved?.ethogram.behaviourStates[0].information == "Small claws bringing food to mouth", "BS in Ethogram not saved")
//    }
    
    func testInitialization() {
        ethogram.addBehaviourState(state1)
        var project = Project(name: "A Day in a Fiddler Crab life", ethogram: ethogram)
        
        XCTAssert(project.name == "A Day in a Fiddler Crab life", "Project not initialized properly")
        XCTAssert(project.ethogram.name == "Fiddler Crabs", "Project not initialized properly")
        XCTAssert(ethogram.behaviourStates.count == 1, "Ethogram not initialized properly")
        
        var containsAdmin = false
        for admin in project.admins {
            if admin.toString() == UserAuthService.sharedInstance.user.toString() {
                containsAdmin = true
            }
        }
        XCTAssert(containsAdmin == true, "Project not initialised properly")
        
        var containsMember = false
        for member in project.members {
            if member.toString() == UserAuthService.sharedInstance.user.toString() {
                containsMember = true
            }
        }
        XCTAssert(containsMember == true, "Project not initialised properly")
    }
    
    func testUpdating() {
        ethogram.addBehaviourState(state1)
        var project = Project(name: "A Day in a Fiddler Crab life", ethogram: ethogram)
        
        XCTAssert(project.name == "A Day in a Fiddler Crab life", "Project not updated properly")
        project.updateName("A morning of a Fiddler Crab Life")
        XCTAssert(project.name == "A morning of a Fiddler Crab Life", "Project not updated properly")
        
        ethogram = Ethogram(name: "Red Fiddler Crabs")
        ethogram.addBehaviourState(state2)
        project.updateEthogram(ethogram)
        
        XCTAssert(project.ethogram.name == "Red Fiddler Crabs", "Project not updated properly")
        XCTAssert(project.ethogram.behaviourStates[0].name == "Fighting", "Project not updated properly")

        
        project.addAdmins([user2])
        project.addMembers([user3])
        
        var containsAdmin = false
        for admin in project.admins {
            if admin.toString() == "The Hulk" {
                containsAdmin = true
            }
        }
        XCTAssert(containsAdmin == true, "Project not updated properly")
        
        containsAdmin = false
        for admin in project.admins {
            if admin.toString() == "Black Power Ranger" {
                containsAdmin = true
            }
        }
        XCTAssert(containsAdmin == false, "Project not updated properly")
        
        var containsMember = false
        for member in project.members {
            if member.toString() == "The Hulk" {
                containsMember = true
            }
        }
        XCTAssert(containsMember == true, "Project not updated properly")
        
        containsMember = false
        for member in project.members {
            if member.toString() == "Black Power Ranger" {
                containsMember = true
            }
        }
        XCTAssert(containsMember == true, "Project not updated properly")
        
        project.removeAdmins([1])
        project.removeMembers([2])
        
        containsAdmin = false
        for admin in project.admins {
            if admin.toString() == "The Hulk" {
                containsAdmin = true
            }
        }
        XCTAssert(containsAdmin == false, "Project not updated properly")
        
        
        containsMember = false
        for member in project.members {
            if member.toString() == "The Hulk" {
                containsMember = true
            }
        }
        XCTAssert(containsMember == true, "Project not updated properly")
        
        containsMember = false
        for member in project.members {
            if member.toString() == "Black Power Ranger" {
                containsMember = true
            }
        }
        XCTAssert(containsMember == false, "Project not updated properly")
        
        
        var session1 = Session(project: project, name: "Session1", type: SessionType.Scan)
        project.addSessions([session1])
        XCTAssert(project.sessions[0].type == SessionType.Scan, "Project not updated properly")
        
        var session2 = Session(project: project, name: "Session2", type: SessionType.Focal)
        project.updateSession(0, updatedSession: session2)
        XCTAssert(project.sessions[0].type == SessionType.Focal, "Project not updated properly")
        
        project.removeSessions([0])
        XCTAssert(project.sessions.count == 0, "Project not updated properly")
        
        
        let individual1 = Individual(label: "M2")
        project.addIndividuals([individual1])
        XCTAssert(project.individuals[0].label == "M2", "Session not updated properly")
        
        let individual2 = Individual(label: "M3")
        project.updateIndividual(0, updatedIndividual: individual2)
        XCTAssert(project.individuals[0].label == "M3", "Session not updated properly")
        
        project.removeIndividuals([0])
        XCTAssert(project.individuals.count == 0, "Session not updated properly")
    }
    
    func testGetObservationPerBS() {
        ethogram.addBehaviourState(state1)
        ethogram.addBehaviourState(state2)
        ethogram.addBehaviourState(state3)
    
        var project = Project(name: "A Day in a Fiddler Crab life", ethogram: ethogram)
    
        var session = Session(project: project, name: "Session1", type: SessionType.Scan)
    
        let individual1 = Individual(label: "M1")
        let individual2 = Individual(label: "M2")
        let observation1 = Observation(session: session, individual: individual1, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        let observation2 = Observation(session: session, individual: individual1, state: state2, timestamp: NSDate(), information: "")
        let observation3 = Observation(session: session, individual: individual1, state: state3, timestamp: NSDate(), information: "")
        let observation4 = Observation(session: session, individual: individual2, state: state3, timestamp: NSDate(), information: "")
    
        session.addObservation([observation1, observation2, observation3, observation4])
        project.addSessions([session])
        
        let bsDict = project.getObservationsPerBS()
        
        XCTAssert(bsDict[state1.name] == 1, "Cannot retrieve number of occurrence of behaviourStates")
        XCTAssert(bsDict[state2.name] == 1, "Cannot retrieve number of occurrence of behaviourStates")
        XCTAssert(bsDict[state3.name] == 2, "Cannot retrieve number of occurrence of behaviourStates")
    }
    
    func testGetSelectedObservations() {
        // 1 session, 3 users, 3 bs each
        ethogram.addBehaviourState(state1)
        ethogram.addBehaviourState(state2)
        ethogram.addBehaviourState(state3)
        
        var project = Project(name: "A Day in a Fiddler Crab life", ethogram: ethogram)
        
        var session1 = Session(project: project, name: "Session1", type: SessionType.Scan)
        var session2 = Session(project: project, name: "Session2", type: SessionType.Scan)
        var session3 = Session(project: project, name: "Session3", type: SessionType.Scan)

        
        let individual1 = Individual(label: "M1")
        let individual2 = Individual(label: "M2")
        let individual3 = Individual(label: "F1")
        
        
        // Observations for session 1
        var observation1 = Observation(session: session1, individual: individual1, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        observation1.changeCreator(user1)
        var observation2 = Observation(session: session1, individual: individual1, state: state2, timestamp: NSDate(), information: "")
        observation2.changeCreator(user1)
        var observation3 = Observation(session: session1, individual: individual1, state: state3, timestamp: NSDate(), information: "")
        observation3.changeCreator(user1)
        var observation4 = Observation(session: session1, individual: individual2, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        observation4.changeCreator(user2)
        var observation5 = Observation(session: session1, individual: individual2, state: state2, timestamp: NSDate(), information: "")
        observation5.changeCreator(user2)
        var observation6 = Observation(session: session1, individual: individual2, state: state3, timestamp: NSDate(), information: "")
        observation6.changeCreator(user2)
        var observation7 = Observation(session: session1, individual: individual3, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        observation7.changeCreator(user3)
        var observation8 = Observation(session: session1, individual: individual3, state: state2, timestamp: NSDate(), information: "")
        observation8.changeCreator(user3)
        var observation9 = Observation(session: session1, individual: individual3, state: state3, timestamp: NSDate(), information: "")
        observation9.changeCreator(user3)
        
        // Observations for session 2
        var observation10 = Observation(session: session2, individual: individual1, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        observation10.changeCreator(user1)
        var observation11 = Observation(session: session2, individual: individual1, state: state2, timestamp: NSDate(), information: "")
        observation11.changeCreator(user1)
        var observation12 = Observation(session: session2, individual: individual2, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        observation12.changeCreator(user2)
        var observation13 = Observation(session: session2, individual: individual2, state: state2, timestamp: NSDate(), information: "")
        observation13.changeCreator(user2)
        var observation14 = Observation(session: session2, individual: individual3, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        observation14.changeCreator(user3)
        var observation15 = Observation(session: session2, individual: individual3, state: state2, timestamp: NSDate(), information: "")
        observation15.changeCreator(user3)
        
        
        // Observations for session 3
        var observation16 = Observation(session: session3, individual: individual1, state: state2, timestamp: NSDate(), information: "")
        observation16.changeCreator(user1)
        var observation17 = Observation(session: session3, individual: individual1, state: state3, timestamp: NSDate(), information: "")
        observation17.changeCreator(user1)
        var observation18 = Observation(session: session3, individual: individual2, state: state2, timestamp: NSDate(), information: "")
        observation18.changeCreator(user2)
        var observation19 = Observation(session: session3, individual: individual2, state: state3, timestamp: NSDate(), information: "")
        observation19.changeCreator(user2)
        var observation20 = Observation(session: session3, individual: individual3, state: state2, timestamp: NSDate(), information: "")
        observation20.changeCreator(user3)
        var observation21 = Observation(session: session3, individual: individual3, state: state3, timestamp: NSDate(), information: "")
        observation21.changeCreator(user3)
        
        session1.addObservation([observation1, observation2, observation3, observation4,
                observation5, observation6, observation7, observation8, observation9])
        session2.addObservation([observation10, observation11, observation12,
            observation13, observation14, observation15])
        session3.addObservation([observation16, observation17, observation18, observation19, observation20, observation21])
        
        project.addSessions([session1, session2, session3])
        
        let results1 = project.getObservations(sessions: [session1, session2], users: [user1], behaviourStates: [state1, state2])
        XCTAssert(results1.count == 4, "Cannot retrieve number of observations")
        
        let results2 = project.getObservations(sessions: [session1, session3], users: [user1, user3], behaviourStates: [state1, state3])
        XCTAssert(results2.count == 6, "Cannot retrieve number of observations")
        
        let results3 = project.getObservations(sessions: [session2, session3], users: [user2], behaviourStates: [state2])
        XCTAssert(results3.count == 2, "Cannot retrieve number of observations")
        
    }
    
    func testEquality() {
        ethogram.addBehaviourState(state1)
        ethogram.addBehaviourState(state2)
        ethogram.addBehaviourState(state3)
        
        var project = Project(name: "A Day in a Fiddler Crab life", ethogram: ethogram)
        var project1 = Project(name: "Fiddler Crab life", ethogram: ethogram)
        
        let individual1 = Individual(label: "M1")
        let individual2 = Individual(label: "M2")
        let individual3 = Individual(label: "F1")
        
        var session3 = Session(project: project, name: "Session3", type: SessionType.Scan)
        
        var observation16 = Observation(session: session3, individual: individual1, state: state2, timestamp: NSDate(), information: "")
        observation16.changeCreator(user1)
        var observation17 = Observation(session: session3, individual: individual1, state: state3, timestamp: NSDate(), information: "")
        observation17.changeCreator(user1)
        var observation18 = Observation(session: session3, individual: individual2, state: state2, timestamp: NSDate(), information: "")
        observation18.changeCreator(user2)
        var observation19 = Observation(session: session3, individual: individual2, state: state3, timestamp: NSDate(), information: "")
        observation19.changeCreator(user2)
        var observation20 = Observation(session: session3, individual: individual3, state: state2, timestamp: NSDate(), information: "")
        observation20.changeCreator(user3)
        var observation21 = Observation(session: session3, individual: individual3, state: state3, timestamp: NSDate(), information: "")
        observation21.changeCreator(user3)
        
        session3.addObservation([observation16, observation17, observation18, observation19, observation20, observation21])
        
        project.addSessions([session3])
        
        XCTAssert(project == project, "Not equal")
        XCTAssert(project != project1, "Not equal")
    }
}