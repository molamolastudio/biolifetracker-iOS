//
//  EthogramStorageTests.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 3/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import XCTest

class EthogramTests: XCTestCase {
    let state1 = BehaviourState(name: "Feeding", information: "Small claws bringing food to mouth")
    let state2 = BehaviourState(name: "Fighting", information: "Engagement of large clawa with another crab")
    let state3 = BehaviourState(name: "Hiding", information: "Withdrawal of fiddler crab into its burrow")
    var ethogram = Ethogram(name: "Fiddler Crabs")
    
// This test case is meant to check for the correctness of saving individual ethograms
// Please uncomment savedToArchives in Ethogram class before using this test case
    
//    func testSaveLoadEthogram() {
//        // Testing for the correctness in adding one behaviour state in the ethogram
//        ethogram.addBehaviourState(state1)
//        
//        var retrieved = Ethogram.loadFromArchives("Fiddler Crabs") as Ethogram?
//        XCTAssert(retrieved?.name == "Fiddler Crabs", "Ethogram not saved")
//        XCTAssert(retrieved?.creator.toString() == UserAuthService.sharedInstance.user.toString(), "Ethogram not saved")
//        XCTAssert(retrieved?.behaviourStates[0].name == "Feeding", "BS in Ethogram not saved")
//        XCTAssert(retrieved?.behaviourStates[0].information == "Small claws bringing food to mouth", "BS in Ethogram not saved")
//        
//        // Testing for the correctness of the ethogram after updating it with another behaviour state
//        ethogram.addBehaviourState(state2)
//        
//        retrieved = Ethogram.loadFromArchives("Fiddler Crabs") as Ethogram?
//        XCTAssert(retrieved?.name == "Fiddler Crabs", "Ethogram not saved")
//        XCTAssert(retrieved?.creator.toString() == UserAuthService.sharedInstance.user.toString(), "Ethogram not saved")
//        XCTAssert(retrieved?.behaviourStates[1].name == "Fighting", "BS in Ethogram not saved")
//        XCTAssert(retrieved?.behaviourStates[1].information == "Engagement of large clawa with another crab", "BS in Ethogram not saved")
//        
//        // Testing for the correctness of the ethogram after updating a behaviour state
//        ethogram.addBehaviourState(state3)
//        
//        retrieved = Ethogram.loadFromArchives("Fiddler Crabs") as Ethogram?
//        XCTAssert(retrieved?.behaviourStates[2].name == "Hiding", "BS in Ethogram not saved")
//        XCTAssert(retrieved?.behaviourStates[2].information == "Withdrawal of fiddler crab into its burrow", "BS in Ethogram not saved")
//        XCTAssert(retrieved?.behaviourStates[2].photoUrls.count == 0, "BS in Ethogram not working properly")
//        
//        ethogram.deleteBehaviourState(1)
//        ethogram.updateBehaviourStateName(1, bsName: "Going Home")
//        ethogram.updateBehaviourStateInformation(1, bsInformation: "Waves goodbye")
//        ethogram.addBSPhotoUrl(1, photoUrl: "www.default.com")
//        
//        retrieved = Ethogram.loadFromArchives("Fiddler Crabs") as Ethogram?
//        XCTAssert(retrieved?.behaviourStates[1].name == "Going Home", "BS in Ethogram not saved")
//        XCTAssert(retrieved?.behaviourStates[1].information == "Waves goodbye", "BS in Ethogram not saved")
//        XCTAssert(retrieved?.behaviourStates[1].photoUrls.count == 1, "BS in Ethogram not working properly")
//        XCTAssert(retrieved?.behaviourStates[1].photoUrls[0] == "www.default.com", "BS in Ethogram not working properly")
//        
//        ethogram.deleteBSPhotoUrl(1, photoIndex: 0)
//        
//        retrieved = Ethogram.loadFromArchives("Fiddler Crabs") as Ethogram?
//        XCTAssert(retrieved?.behaviourStates[1].photoUrls.count == 0, "BS in Ethogram not working properly")
//        
//        // Testing for the correctness after updating the ethogram name
//        ethogram.updateName("Porcelain Fiddler Crabs")
//        
//        retrieved = Ethogram.loadFromArchives("Fiddler Crabs") as Ethogram?
//        XCTAssert(retrieved? == nil, "Update Ethogram not working properly")
//        
//        retrieved = Ethogram.loadFromArchives("Porcelain Fiddler Crabs") as Ethogram?
//        XCTAssert(retrieved?.behaviourStates[1].name == "Going Home", "BS in Ethogram not saved")
//        XCTAssert(retrieved?.behaviourStates[1].information == "Waves goodbye", "BS in Ethogram not saved")
//
//    }
    
    func testInitialization() {
        XCTAssert(ethogram.name == "Fiddler Crabs", "Ethogram not initialized properly")
        XCTAssert(ethogram.information == "", "Ethogram not initialized properly")
        XCTAssert(ethogram.behaviourStates.count == 0, "Ethogram not initialized properly")
    }
    
    func testUpdating() {
        XCTAssert(ethogram.name == "Fiddler Crabs", "Ethogram not updated properly")
        ethogram.updateName("Porcelain Fiddler Crabs")
        XCTAssert(ethogram.name == "Porcelain Fiddler Crabs", "Ethogram not updated properly")
        
        XCTAssert(ethogram.information == "", "Ethogram not updated properly")
        ethogram.updateInformation("Thumb sized crabs with black stripes across the shell")
        XCTAssert(ethogram.information == "Thumb sized crabs with black stripes across the shell", "Ethogram not updated properly")
        
        ethogram.addBehaviourState(state1)
        XCTAssert(ethogram.behaviourStates[0].name == "Feeding", "Ethogram not updated properly")
        
        ethogram.updateBehaviourStateName(0, bsName: "Snacking")
        XCTAssert(ethogram.behaviourStates[0].name == "Snacking", "Ethogram not updated properly")

        ethogram.updateBehaviourStateInformation(0, bsInformation: "Tiny inputs of sand to the mouth")
        XCTAssert(ethogram.behaviourStates[0].information == "Tiny inputs of sand to the mouth", "Ethogram not updated properly")

        ethogram.deleteBehaviourState(0)
        XCTAssert(ethogram.behaviourStates.count == 0, "Ethogram not updated properly")
        
        ethogram.addBehaviourState(state3)
        
        
        ethogram.addBSPhotoUrl(0, photoUrl: "www.photo1.com")
        XCTAssert(ethogram.behaviourStates[0].photoUrls[0] == "www.photo1.com", "Ethogram not updated properly")
        
        ethogram.addBSPhotoUrl(0, photoUrl: "www.photo2.com")
        XCTAssert(ethogram.behaviourStates[0].photoUrls[1] == "www.photo2.com", "Ethogram not updated properly")
        
        ethogram.deleteBSPhotoUrl(0, photoIndex: 0)
        XCTAssert(ethogram.behaviourStates[0].photoUrls[0] == "www.photo2.com", "Ethogram not updated properly")
    }
}