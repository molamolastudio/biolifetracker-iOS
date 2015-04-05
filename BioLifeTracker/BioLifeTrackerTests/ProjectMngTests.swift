//
//  ProjectMngTests.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 5/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import XCTest

class ProjectMngTests: XCTestCase {
    let state1 = BehaviourState(name: "Feeding", information: "Small claws bringing food to mouth")
    let state2 = BehaviourState(name: "Fighting", information: "Engagement of large clawa with another crab")
    let state3 = BehaviourState(name: "Hiding", information: "Withdrawal of fiddler crab into its burrow")
    var ethogram = Ethogram(name: "Fiddler Crabs")
    
    func testSaveLoadProjectMng() {
        UserAuthService.sharedInstance.useDefaultUser()
        ProjectManager.sharedInstance.clearProjects()

        ethogram.addBehaviourState(state1)
        let project1 = Project(name: "A Day in a Fiddler Crab life", ethogram: ethogram)
        ProjectManager.sharedInstance.addProject(project1)
        ProjectManager.sharedInstance.saveToArchives()
        XCTAssert(ProjectManager.sharedInstance.projects[0].name == "A Day in a Fiddler Crab life", "Project not added")

        // Edit ProjectManager without saving
        ProjectManager.sharedInstance.removeProjectAtIndexes([0])
        XCTAssert(ProjectManager.sharedInstance.projects.count == 0, "Project not removed")
        
        // ProjectManager retrieved the state last saved
        UserAuthService.sharedInstance.useDefaultUser()
        XCTAssert(ProjectManager.sharedInstance.projects[0].name == "A Day in a Fiddler Crab life", "Project not retrieved properly")
        
        // Edit ProjectManager with saving
        let project2 = Project(name: "A Day in a Porcelain Fiddler Crab life", ethogram: ethogram)
        ProjectManager.sharedInstance.updateProject(0, project: project2)
        ProjectManager.sharedInstance.saveToArchives()
        XCTAssert(ProjectManager.sharedInstance.projects[0].name == "A Day in a Porcelain Fiddler Crab life", "Project not updated")
        
        // ProjectManager retrieved the state last saved
        UserAuthService.sharedInstance.useDefaultUser()
        XCTAssert(ProjectManager.sharedInstance.projects[0].name == "A Day in a Porcelain Fiddler Crab life", "Project not retrieved properly")
    }
}