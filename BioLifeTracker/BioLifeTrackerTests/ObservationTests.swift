//
//  ObservationTests.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 4/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import XCTest

class ObservationTests: XCTestCase {
    
    func testInitialization() {
        let state1 = BehaviourState(name: "Feeding", information: "Small claws bringing food to mouth")
        let state2 = BehaviourState(name: "Fighting", information: "Engagement of large clawa with another crab")
        var ethogram = Ethogram(name: "Fiddler Crabs")
        ethogram.addBehaviourState(state1)
        ethogram.addBehaviourState(state2)
        
        let project = Project(name: "A Day in a Fiddler Crab life", ethogram: ethogram)
        
        let session = Session(project: project, type: SessionType.Scan)
        let individual = Individual(label: "M1")
        var observation = Observation(session: session, individual: individual, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        
        XCTAssert(observation.session.project.name == "A Day in a Fiddler Crab life", "Observation not initialised properly")
        XCTAssert(observation.state.name == "Feeding", "Observation not initialised properly")
        XCTAssert(observation.information == "Eating vigourously", "Observation not initialised properly")
        XCTAssert(observation.individual.label == "M1", "Observation not initialised properly")
    }
    
    func testUpdates() {
        let state1 = BehaviourState(name: "Feeding", information: "Small claws bringing food to mouth")
        let state2 = BehaviourState(name: "Fighting", information: "Engagement of large clawa with another crab")
        var ethogram = Ethogram(name: "Fiddler Crabs")
        ethogram.addBehaviourState(state1)
        ethogram.addBehaviourState(state2)
        
        let project = Project(name: "A Day in a Fiddler Crab life", ethogram: ethogram)
        
        let session = Session(project: project, type: SessionType.Scan)
        let individual = Individual(label: "M1")
        var observation = Observation(session: session, individual: individual, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        
        XCTAssert(observation.state.name == "Feeding", "Observation not initialised properly")
        observation.changeBehaviourState(state2)
        XCTAssert(observation.state.name == "Fighting", "Observation not initialised properly")
        
        XCTAssert(observation.information == "Eating vigourously", "Observation not initialised properly")
        observation.updateInformation("Claw dropped off")
        XCTAssert(observation.information == "Claw dropped off", "Observation not initialised properly")
        
        // Test updatePhoto
        
        XCTAssert(observation.individual.label == "M1", "Observation not initialised properly")
        let newIndividual = Individual(label: "M3")
        observation.changeIndividual(newIndividual)
        XCTAssert(observation.individual.label == "M3", "Observation not initialised properly")
        
        // Test changeLocation
        // Test changeWeather
        
        observation.addPhotoUrl("www.photo1.com")
        XCTAssert(observation.photoUrls[0] == "www.photo1.com", "Individual not initialised properly")
        
        observation.addPhotoUrl("www.photo2.com")
        XCTAssert(observation.photoUrls[1] == "www.photo2.com", "Individual not initialised properly")
        
        observation.removePhotoUrlAtIndex(0)
        XCTAssert(observation.photoUrls[0] == "www.photo2.com", "Individual not initialised properly")
        
        XCTAssert(observation.notes == "", "Observation not initialised properly")
        observation.updateNotes("Fought with a bigger crab")
        XCTAssert(observation.notes == "Fought with a bigger crab", "Observation not initialised properly")
    }

}