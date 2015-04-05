//
//  EthogramMngTests.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 5/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import XCTest

class EthogramMngTests: XCTestCase {
    let state1 = BehaviourState(name: "Feeding", information: "Small claws bringing food to mouth")
    let state2 = BehaviourState(name: "Fighting", information: "Engagement of claws")
    let state3 = BehaviourState(name: "Hiding", information: "Withdrawal of fiddler crab into its burrow")
    var ethogram = Ethogram(name: "Fiddler Crabs")
    
    func testSaveLoadProjectMng() {
        UserAuthService.sharedInstance.useDefaultUser()
        EthogramManager.sharedInstance.clearEthograms()
        
        ethogram.addBehaviourState(state1)
        EthogramManager.sharedInstance.addEthogram(ethogram)
        EthogramManager.sharedInstance.saveToArchives()
        XCTAssert(EthogramManager.sharedInstance.ethograms[0].name == "Fiddler Crabs", "Ethogram not added")
        
        // Edit EthogramManager without saving
        EthogramManager.sharedInstance.removeEthograms([0])
        XCTAssert(EthogramManager.sharedInstance.ethograms.count == 0, "Ethogram not removed")
        
        // EthogramManager retrieved the state last saved
        UserAuthService.sharedInstance.useDefaultUser()
        XCTAssert(EthogramManager.sharedInstance.ethograms[0].name == "Fiddler Crabs", "Ethogram not retrieved properly")
        
        // Edit EthogramManager with saving
        var ethogram2 =  Ethogram(name: "Red Foxes")
        ethogram2.addBehaviourState(state2)
        EthogramManager.sharedInstance.updateEthogram(0, ethogram: ethogram2)
        EthogramManager.sharedInstance.saveToArchives()
        XCTAssert(EthogramManager.sharedInstance.ethograms[0].name == "Red Foxes", "Ethogram not updated properly")
        
        // EthogramManager retrieved the state last saved
        UserAuthService.sharedInstance.useDefaultUser()
        XCTAssert(EthogramManager.sharedInstance.ethograms[0].name == "Red Foxes", "Ethogram not retrieved properly")
    }
}