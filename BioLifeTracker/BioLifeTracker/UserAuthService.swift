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
        let loadedProjectMng = ProjectManager.loadFromArchives(UserAuthService.sharedInstance.user.toString()) as ProjectManager?
        if loadedProjectMng != nil {
            ProjectManager.sharedInstance.updateProjects(loadedProjectMng!.projects)
        }
        let loadedEthogramMng = EthogramManager.loadFromArchives(UserAuthService.sharedInstance.user.toString()) as EthogramManager?
        if loadedEthogramMng != nil {
            EthogramManager.sharedInstance.updateEthograms(loadedEthogramMng!.ethograms)
        }
    }
}