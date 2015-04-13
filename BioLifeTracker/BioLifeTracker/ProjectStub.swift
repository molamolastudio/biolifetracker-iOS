//
//  ProjectStub.swift
//  BioLifeTracker
//
//  Created by Haritha on 13/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation


class ProjectStub {
    
    
    let user1 = User(name: "Dean Winchester", email: "impala67@default.com")
    let user2 = User(name: "Castiel", email: "fallenAngel@default.com")
    let user3 = User(name: "Sam Winchester", email: "tooPrecious@default.com")
    let user4 = User(name: "Bobby Singer", email: "whiskey4life@default.com")
    
    
    let state1 = BehaviourState(name: "Eating", information: "Finds human junk food")
    let state2 = BehaviourState(name: "Sleeping", information: "Resting in dark places")
    let state3 = BehaviourState(name: "Making Deals", information: "With a human at crossways")
    let state4 = BehaviourState(name: "Killing", information: "Sharp knives and demon magic")
    let state5 = BehaviourState(name: "Mating", information: "Something similar to the Pizzaman")
    let state6 = BehaviourState(name: "Fighting", information: "With other humans mostly hunters")
    let state7 = BehaviourState(name: "Possessing", information: "Black/red smoke enters into humans")
    
    let ethogram = Ethogram(name: "Demon Behaviour")
    
    var project: Project!
    
    var session1: Session!
    var session2: Session!
    var session3: Session!
    var session4: Session!
    var session5: Session!
    
    let individual1 = Individual(label: "Meg")
    let individual2 = Individual(label: "Crowley")
    let individual3 = Individual(label: "Ruby")
    let individual4 = Individual(label: "Abaddon")
    
    init() {
        
        initialiseEthogram()
        createProject()
        createSessions()
        createObservations()
    }
    
    func initialiseEthogram() {
        ethogram.addBehaviourState(state1)
        ethogram.addBehaviourState(state2)
        ethogram.addBehaviourState(state3)
        ethogram.addBehaviourState(state4)
        ethogram.addBehaviourState(state5)
        ethogram.addBehaviourState(state6)
        ethogram.addBehaviourState(state7)
    }
    
    func createProject() {
         project = Project(name: "Study of Demons", ethogram: ethogram)
    }
    
    func createSessions() {
        session1 = Session(project: project, type: SessionType.Scan)
        session2 = Session(project: project, type: SessionType.Focal)
        session3 = Session(project: project, type: SessionType.Scan)
        session4 = Session(project: project, type: SessionType.Focal)
        session5 = Session(project: project, type: SessionType.Scan)
    }

    
    func createObservations() {
        // session 1 -- morning
        let observation1 = Observation(session: session1, individual: individual1, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        let observation2 = Observation(session: session1, individual: individual2, state: state2, timestamp: NSDate(), information: "Eating vigourously")
        let observation3 = Observation(session: session1, individual: individual1, state: state2, timestamp: NSDate(), information: "Eating vigourously")
        let observation4 = Observation(session: session1, individual: individual4, state: state2, timestamp: NSDate(), information: "Eating vigourously")
        let observation5 = Observation(session: session1, individual: individual2, state: state2, timestamp: NSDate(), information: "Eating vigourously")
        let observation6 = Observation(session: session1, individual: individual1, state: state2, timestamp: NSDate(), information: "Eating vigourously")
        let observation7 = Observation(session: session1, individual: individual3, state: state6, timestamp: NSDate(), information: "Eating vigourously")
        let observation8 = Observation(session: session1, individual: individual2, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        let observation9 = Observation(session: session1, individual: individual1, state: state7, timestamp: NSDate(), information: "Eating vigourously")
        let observation10 = Observation(session: session1, individual: individual1, state: state2, timestamp: NSDate(), information: "Eating vigourously")
        
        // session 2 -- afternoon
        
        let observation11 = Observation(session: session2, individual: individual1, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        let observation12 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation13 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation14 = Observation(session: session2, individual: individual1, state: state5, timestamp: NSDate(), information: "Eating vigourously")
        let observation15 = Observation(session: session2, individual: individual1, state: state6, timestamp: NSDate(), information: "Eating vigourously")
        let observation16 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation17 = Observation(session: session2, individual: individual1, state: state2, timestamp: NSDate(), information: "Eating vigourously")
        let observation18 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation19 = Observation(session: session2, individual: individual1, state: state5, timestamp: NSDate(), information: "Eating vigourously")
        let observation20 = Observation(session: session2, individual: individual1, state: state6, timestamp: NSDate(), information: "Eating vigourously")
        let observation21 = Observation(session: session2, individual: individual1, state: state6, timestamp: NSDate(), information: "Eating vigourously")
        let observation22 = Observation(session: session2, individual: individual1, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        let observation23 = Observation(session: session2, individual: individual1, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        let observation24 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation25 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation26 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation27 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation28 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation29 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation30 = Observation(session: session2, individual: individual1, state: state5, timestamp: NSDate(), information: "Eating vigourously")
        
        
        // session 3 -- evening
        
        let observation31 = Observation(session: session2, individual: individual1, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        let observation32 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation33 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation34 = Observation(session: session2, individual: individual1, state: state5, timestamp: NSDate(), information: "Eating vigourously")
        let observation35 = Observation(session: session2, individual: individual1, state: state6, timestamp: NSDate(), information: "Eating vigourously")
        let observation36 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation37 = Observation(session: session2, individual: individual1, state: state2, timestamp: NSDate(), information: "Eating vigourously")
        let observation38 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation39 = Observation(session: session2, individual: individual1, state: state5, timestamp: NSDate(), information: "Eating vigourously")
        let observation40 = Observation(session: session2, individual: individual1, state: state6, timestamp: NSDate(), information: "Eating vigourously")
        let observation41 = Observation(session: session2, individual: individual1, state: state6, timestamp: NSDate(), information: "Eating vigourously")
        let observation42 = Observation(session: session2, individual: individual1, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        let observation43 = Observation(session: session2, individual: individual1, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        let observation44 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation45 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation46 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation47 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation48 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation49 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation50 = Observation(session: session2, individual: individual1, state: state5, timestamp: NSDate(), information: "Eating vigourously")
        let observation51 = Observation(session: session2, individual: individual1, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        let observation52 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation53 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation54 = Observation(session: session2, individual: individual1, state: state5, timestamp: NSDate(), information: "Eating vigourously")
        let observation55 = Observation(session: session2, individual: individual1, state: state6, timestamp: NSDate(), information: "Eating vigourously")
        let observation56 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation57 = Observation(session: session2, individual: individual1, state: state2, timestamp: NSDate(), information: "Eating vigourously")
        let observation58 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation59 = Observation(session: session2, individual: individual1, state: state5, timestamp: NSDate(), information: "Eating vigourously")
        let observation60 = Observation(session: session2, individual: individual1, state: state6, timestamp: NSDate(), information: "Eating vigourously")
        let observation61 = Observation(session: session2, individual: individual1, state: state6, timestamp: NSDate(), information: "Eating vigourously")
        let observation62 = Observation(session: session2, individual: individual1, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        let observation63 = Observation(session: session2, individual: individual1, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        let observation64 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation65 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation66 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation67 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation68 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation69 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation70 = Observation(session: session2, individual: individual1, state: state5, timestamp: NSDate(), information: "Eating vigourously")
        
        // session 4 -- evening
        let observation71 = Observation(session: session2, individual: individual1, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        let observation72 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation73 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation74 = Observation(session: session2, individual: individual1, state: state5, timestamp: NSDate(), information: "Eating vigourously")
        let observation75 = Observation(session: session2, individual: individual1, state: state6, timestamp: NSDate(), information: "Eating vigourously")
        let observation76 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation77 = Observation(session: session2, individual: individual1, state: state2, timestamp: NSDate(), information: "Eating vigourously")
        let observation78 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation79 = Observation(session: session2, individual: individual1, state: state5, timestamp: NSDate(), information: "Eating vigourously")
        let observation80 = Observation(session: session2, individual: individual1, state: state6, timestamp: NSDate(), information: "Eating vigourously")
        let observation81 = Observation(session: session2, individual: individual1, state: state6, timestamp: NSDate(), information: "Eating vigourously")
        let observation82 = Observation(session: session2, individual: individual1, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        let observation83 = Observation(session: session2, individual: individual1, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        let observation84 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation85 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation86 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation87 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation88 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation89 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation90 = Observation(session: session2, individual: individual1, state: state5, timestamp: NSDate(), information: "Eating vigourously")
        let observation91 = Observation(session: session2, individual: individual1, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        let observation92 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation93 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation94 = Observation(session: session2, individual: individual1, state: state5, timestamp: NSDate(), information: "Eating vigourously")
        let observation95 = Observation(session: session2, individual: individual1, state: state6, timestamp: NSDate(), information: "Eating vigourously")
        let observation96 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation97 = Observation(session: session2, individual: individual1, state: state2, timestamp: NSDate(), information: "Eating vigourously")
        let observation98 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation99 = Observation(session: session2, individual: individual1, state: state5, timestamp: NSDate(), information: "Eating vigourously")
        let observation100 = Observation(session: session2, individual: individual1, state: state6, timestamp: NSDate(), information: "Eating vigourously")
        let observation101 = Observation(session: session2, individual: individual1, state: state6, timestamp: NSDate(), information: "Eating vigourously")
        let observation102 = Observation(session: session2, individual: individual1, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        let observation103 = Observation(session: session2, individual: individual1, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        let observation104 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation105 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation106 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation107 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation108 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation109 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation110 = Observation(session: session2, individual: individual1, state: state5, timestamp: NSDate(), information: "Eating vigourously")
        
        
        // session 5 -- afternoon
        let observation111 = Observation(session: session2, individual: individual1, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        let observation112 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation113 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation14 = Observation(session: session2, individual: individual1, state: state5, timestamp: NSDate(), information: "Eating vigourously")
        let observation15 = Observation(session: session2, individual: individual1, state: state6, timestamp: NSDate(), information: "Eating vigourously")
        let observation16 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation17 = Observation(session: session2, individual: individual1, state: state2, timestamp: NSDate(), information: "Eating vigourously")
        let observation18 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation19 = Observation(session: session2, individual: individual1, state: state5, timestamp: NSDate(), information: "Eating vigourously")
        let observation20 = Observation(session: session2, individual: individual1, state: state6, timestamp: NSDate(), information: "Eating vigourously")
        let observation21 = Observation(session: session2, individual: individual1, state: state6, timestamp: NSDate(), information: "Eating vigourously")
        let observation22 = Observation(session: session2, individual: individual1, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        let observation23 = Observation(session: session2, individual: individual1, state: state1, timestamp: NSDate(), information: "Eating vigourously")
        let observation24 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation25 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation26 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation27 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation28 = Observation(session: session2, individual: individual1, state: state3, timestamp: NSDate(), information: "Eating vigourously")
        let observation29 = Observation(session: session2, individual: individual1, state: state4, timestamp: NSDate(), information: "Eating vigourously")
        let observation30 = Observation(session: session2, individual: individual1, state: state5, timestamp: NSDate(), information: "Eating vigourously")
        
    }
    
}