//
//  LocalStorageTests.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 26/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//


import Foundation
import XCTest

class LocalStorageTests: XCTestCase {
    let state1 = BehaviourState(id: 1, name: "Feeding", information: "Small claws bringing food to mouth")
    var ethogram = Ethogram(name: "Fiddler Crabs")
    
    func testSaveLoadBehaviourState() {
        
        state1.saveToArchives()
        
        let retrieved = BehaviourState.loadFromArchives("Feeding") as BehaviourState?
        println(retrieved?.name)
        
  //      XCTAssert(retrieved?.id == 1, "BS not saved")
        XCTAssert(retrieved?.name == "Feeding", "BS not saved")
        XCTAssert(retrieved?.information == "Small claws bringing food to mouth", "BS not saved")
    }
    
    func testSaveLoadEthogram() {
        ethogram.addBehaviourState(state1)
        ethogram.saveToArchives()

        let retrieved = Ethogram.loadFromArchives("Fiddler Crabs") as Ethogram?
        println(retrieved?.name)
        println(retrieved?.creator)
        
        XCTAssert(retrieved?.name == "Fiddler Crabs", "Ethogram not saved")
        XCTAssert(retrieved?.creator.toString() == Constants.Default.userName, "Ethogram not saved")
  //      XCTAssert(retrieved?.behaviourStates[0].id == 1, "BS in Ethogram not saved")
        XCTAssert(retrieved?.behaviourStates[0].name == "Feeding", "BS in Ethogram not saved")
        XCTAssert(retrieved?.behaviourStates[0].information == "Small claws bringing food to mouth", "BS in Ethogram not saved")
    }
    
    func testSaveLoadProject() {
        ethogram.addBehaviourState(state1)
        var project = Project(name: "A Day in a Fiddler Crab life", ethogram: ethogram)
        
        project.saveToArchives()
        
        let retrieved = Project.loadFromArchives("A Day in a Fiddler Crab life") as Project?
        
        XCTAssert(retrieved?.name == "A Day in a Fiddler Crab life", "Project not saved")
        XCTAssert(retrieved?.ethogram.name == "Fiddler Crabs", "Ethogram in project not saved")
        XCTAssert(retrieved?.ethogram.creator.toString() == Constants.Default.userName, "Ethogram not saved")
 //       XCTAssert(retrieved?.ethogram.behaviourStates[0].id == 1, "BS in Ethogram not saved")
        XCTAssert(retrieved?.ethogram.behaviourStates[0].name == "Feeding", "BS in Ethogram not saved")
        XCTAssert(retrieved?.ethogram.behaviourStates[0].information == "Small claws bringing food to mouth", "BS in Ethogram not saved")
    }
    
}

