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
    
    let user1 = User(name: "Captain America", email: "iamcaptamerica@default.com")
    let user2 = User(name: "The Hulk", email: "iamgreen@default.com")
    let user3 = User(name: "Black Power Ranger", email: "black.ranger@default.com")
    
    func testInitialization() {
        let state1 = BehaviourState(name: "Feeding", information: "Small claws bringing food to mouth")
        let state2 = BehaviourState(name: "Fighting", information: "Engagement of large clawa with another crab")
        var ethogram = Ethogram(name: "Fiddler Crabs")
        ethogram.addBehaviourState(state1)
        ethogram.addBehaviourState(state2)
        
        let project = Project(name: "A Day in a Fiddler Crab life", ethogram: ethogram)
        
        var session = Session(project: project, name: "Session1", type: SessionType.Scan)
        
        let name = session.getDisplayName()
        XCTAssert(name == "Session1", "Session not initialised properly")
        
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
        var session = Session(project: project, name: "Session1", type: SessionType.Scan)
        
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
    
    func testEquality() {
        let state1 = BehaviourState(name: "Feeding", information: "Small claws bringing food to mouth")
        let state2 = BehaviourState(name: "Fighting", information: "Engagement of large clawa with another crab")
        let state3 = BehaviourState(name: "Hiding", information: "Withdrawal of fiddler crab into its burrow")
        
        var ethogram = Ethogram(name: "Fiddler Crabs")
        ethogram.addBehaviourState(state1)
        ethogram.addBehaviourState(state2)
        
        let project = Project(name: "A Day in a Fiddler Crab life", ethogram: ethogram)
        
        let individual1 = Individual(label: "M1")
        let individual2 = Individual(label: "M2")
        let individual3 = Individual(label: "F1")
        
        var session2 = Session(project: project, name: "Session2", type: SessionType.Scan)
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
        
        XCTAssert(session3 == session3, "Not equal")
        XCTAssert(session3 != session2, "Error with equality")
    }
    
    func testGetTimestamp() {
        let state1 = BehaviourState(name: "Feeding", information: "Small claws bringing food to mouth")
        let state2 = BehaviourState(name: "Fighting", information: "Engagement of large clawa with another crab")
        let state3 = BehaviourState(name: "Hiding", information: "Withdrawal of fiddler crab into its burrow")
        
        var ethogram = Ethogram(name: "Fiddler Crabs")
        ethogram.addBehaviourState(state1)
        ethogram.addBehaviourState(state2)
        
        let project = Project(name: "A Day in a Fiddler Crab life", ethogram: ethogram)
        
        let individual1 = Individual(label: "M1")
        let individual2 = Individual(label: "M2")
        let individual3 = Individual(label: "F1")
        
        var session2 = Session(project: project, name: "Session2", type: SessionType.Scan)
        var session3 = Session(project: project, name: "Session3", type: SessionType.Scan)
        
        var observation16 = Observation(session: session3, individual: individual1, state: state2, timestamp: NSDate(), information: "")
        var observation17 = Observation(session: session3, individual: individual1, state: state3, timestamp: NSDate(), information: "")
        var observation18 = Observation(session: session3, individual: individual2, state: state2, timestamp: NSDate(), information: "")
        var observation19 = Observation(session: session3, individual: individual2, state: state3, timestamp: NSDate(), information: "")
        var observation20 = Observation(session: session3, individual: individual3, state: state2, timestamp: NSDate(), information: "")
        var observation21 = Observation(session: session3, individual: individual3, state: state3, timestamp: NSDate(), information: "")
        
        session3.addObservation([observation16, observation17, observation18, observation19, observation20, observation21])
        
        println("/**********************TestTimestamps*************************/")
        let timestamps = session3.getTimestamps()
        for timestamp in timestamps {
            println(timestamp)
        }
        
    }
    
    func testGetObservationsByTimestamp() {
        let state1 = BehaviourState(name: "Feeding", information: "Small claws bringing food to mouth")
        let state2 = BehaviourState(name: "Fighting", information: "Engagement of large clawa with another crab")
        let state3 = BehaviourState(name: "Hiding", information: "Withdrawal of fiddler crab into its burrow")
        
        var ethogram = Ethogram(name: "Fiddler Crabs")
        ethogram.addBehaviourState(state1)
        ethogram.addBehaviourState(state2)
        
        let project = Project(name: "A Day in a Fiddler Crab life", ethogram: ethogram)
        
        let individual1 = Individual(label: "M1")
        let individual2 = Individual(label: "M2")
        let individual3 = Individual(label: "F1")
        
        var session2 = Session(project: project, name: "Session2", type: SessionType.Scan)
        var session3 = Session(project: project, name: "Session3", type: SessionType.Scan)
        
        let timestamp = NSDate()
        
        var observation16 = Observation(session: session3, individual: individual1, state: state2, timestamp: timestamp, information: "")
        var observation17 = Observation(session: session3, individual: individual1, state: state3, timestamp: NSDate(), information: "")
        var observation18 = Observation(session: session3, individual: individual2, state: state2, timestamp: NSDate(), information: "")
        
        
        session3.addObservation([observation16, observation17, observation18])
        let observations = session3.getObservationsByTimestamp(timestamp)
        
        XCTAssert(containObservation(session3.observations, observation: observation16), "Cannot retrieve by timestamp")
        XCTAssert(containObservation(session3.observations, observation: observation17), "Cannot retrieve by timestamp")
        XCTAssert(containObservation(session3.observations, observation: observation18), "Cannot retrieve by timestamp")
    }
    
    func testGetObservationsByIndividual() {
        let state1 = BehaviourState(name: "Feeding", information: "Small claws bringing food to mouth")
        let state2 = BehaviourState(name: "Fighting", information: "Engagement of large clawa with another crab")
        let state3 = BehaviourState(name: "Hiding", information: "Withdrawal of fiddler crab into its burrow")
        
        var ethogram = Ethogram(name: "Fiddler Crabs")
        ethogram.addBehaviourState(state1)
        ethogram.addBehaviourState(state2)
        
        let project = Project(name: "A Day in a Fiddler Crab life", ethogram: ethogram)
        
        let individual1 = Individual(label: "M1")
        let individual2 = Individual(label: "M2")
        let individual3 = Individual(label: "F1")

        var session3 = Session(project: project, name: "Session3", type: SessionType.Scan)
        
        let timestamp = NSDate()
        
        var observation16 = Observation(session: session3, individual: individual1, state: state2, timestamp: timestamp, information: "")
        var observation17 = Observation(session: session3, individual: individual1, state: state3, timestamp: NSDate(), information: "")
        var observation18 = Observation(session: session3, individual: individual2, state: state2, timestamp: NSDate(), information: "")
        
        session3.addObservation([observation16, observation17])
        let observations = session3.getAllObservationsForIndividual(individual1)
        
        XCTAssert(containObservation(session3.observations, observation: observation16), "Cannot retrieve by individual")
        XCTAssert(containObservation(session3.observations, observation: observation17), "Cannot retrieve by individual")
        XCTAssert(!containObservation(session3.observations, observation: observation18), "Cannot retrieve by individual")
    }
    
    // Helper function to test testGetObservationsByTimestamp()
    func containObservation(observations: [Observation], observation: Observation) -> Bool {
        for existingOb in observations {
            if observation == existingOb {
                return true
            }
        }
        return false
    }

}