//
//  UserAuthService.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 2/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class UserAuthService {
    private var _user: User = User(name: "Default", email: "Default")
    private var _accessToken: String = ""
    
    var projectManager: ProjectManager = ProjectManager.sharedInstance
    var ethogramManager: EthogramManager = EthogramManager.sharedInstance
    
    var user: User {
        get { return _user }
    }
    var accessToken: String {
        get { return _accessToken }
    }
    
    class var sharedInstance: UserAuthService {
        struct Singleton {
            static let instance = UserAuthService()
        }
        return Singleton.instance
    }
    
    func useDefaultUser() {
        initialiseManagers()
    }
    
    func setUserAuth(user: User, accessToken: String) {
        self._user = user
        self._accessToken = accessToken
        initialiseManagers()
    }
    
    private func initialiseManagers() {
        let loadedProjectMng = ProjectManager.loadFromArchives(user.toString()) as ProjectManager?
        if loadedProjectMng != nil {
            projectManager = loadedProjectMng!
        }
        let loadedEthogramMng = EthogramManager.loadFromArchives(user.toString()) as EthogramManager?
        if loadedEthogramMng != nil {
            ethogramManager = loadedEthogramMng!
        }
    }
}