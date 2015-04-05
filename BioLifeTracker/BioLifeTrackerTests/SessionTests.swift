//
//  SessionTests.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 4/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import XCTest

class SessionTests: XCTestCase {
    
    func testInitialization() {
        let state1 = BehaviourState(name: "Feeding", information: "Small claws bringing food to mouth")
        let state2 = BehaviourState(name: "Fighting", information: "Engagement of large clawa with another crab")
        var ethogram = Ethogram(name: "Fiddler Crabs")
        ethogram.addBehaviourState(state1)
        ethogram.addBehaviourState(state2)
        
        let project = Project(name: "A Day in a Fiddler Crab life", ethogram: ethogram)
        
        var session = Session(project: project, type: SessionType.Scan)
        
        XCTAssert(session.project.name == "A Day in a Fiddler Crab life", "Session not initialised properly")
        XCTAssert(session.type == SessionType.Scan, "Session not initialised properly")
        XCTAssert(session.observations.count == 0, "Session not initialised properly")
        XCTAssert(session.individuals.count == 0, "Session not initialised properly")
    }
    
    func testUpdates() {
        let state1 = BehaviourState(name: "Feeding", information: "Small claws bringing food to mouth")
        let state2 = BehaviourState(name: "Fighting", information: "Engagement of large clawa with another crab")
        var ethogram = Ethogram(name: "Fiddler Crabs")
        ethogram.addBehaviourState(state1)
        ethogram.addBehaviourState(state2)
        
        let project = Project(name: "A Day in a Fiddler Crab life", ethogram: ethogram)
        var session = Session(project: project, type: SessionType.Scan)
        
        let individual = Individual(label: "M1")
        let observation1 = Observation(session: session, individual: individual, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        
        session.addObservation([observation1])
        XCTAssert(session.observations[0].information == "Eating vigourously", "Session not updated properly")
        
        let observation2 = Observation(session: session, individual: individual, state: state1, timestamp: NSDate(), information: "Picking up sand")
        session.updateObservation(0, updatedObservation: observation2)
        XCTAssert(session.observations[0].information == "Picking up sand", "Session not updated properly")
        
        session.removeObservations([0])
        XCTAssert(session.observations.count == 0, "Session not updated properly")
        
        
        let individual1 = Individual(label: "M2")
        session.addIndividuals([individual1])
        XCTAssert(session.individuals[0].label == "M2", "Session not updated properly")
        
        let individual2 = Individual(label: "M3")
        session.updateIndividual(0, updatedIndividual: individual2)
        XCTAssert(session.individuals[0].label == "M3", "Session not updated properly")
        
        session.removeIndividuals([0])
        XCTAssert(session.individuals.count == 0, "Session not updated properly")
    }
}