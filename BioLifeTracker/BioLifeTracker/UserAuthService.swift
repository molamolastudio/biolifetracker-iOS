//
//  UserAuthService.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 2/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class UserAuthService {
    enum OAuthProvider {
        case Facebook, Google
    }
    private var _user: User = User(name: "Default", email: "Default")
    private var _accessToken: String?
    private var _authProvider: OAuthProvider?
    var user: User {
        get { return _user }
    }
    var accessToken: String? {
        get { return _accessToken }
    }
    var authProvider: OAuthProvider? {
        get { return _authProvider }
    }
    
    class var sharedInstance: UserAuthService {
        struct Singleton {
            static let instance = UserAuthService()
        }
        return Singleton.instance
    }
    
    init() {
        tryLoadTokenFromDisk()
    }
    
    func useDefaultUser() {
        initialiseManagers()
    }
    
    func hasAccessToken() -> Bool {
        if accessToken == nil {
           tryLoadTokenFromDisk()
        }
        return accessToken != nil
    }
    
    func initialiseManagers() {
        let loadedProjectMng = ProjectManager.loadFromArchives(UserAuthService.sharedInstance.user.toString()) as? ProjectManager
        if loadedProjectMng != nil {
            ProjectManager.sharedInstance.updateProjects(loadedProjectMng!.projects)
        }
        
        let loadedEthogramMng = EthogramManager.loadFromArchives(String(UserAuthService.sharedInstance.user.id)) as! EthogramManager?
        if loadedEthogramMng != nil {
            EthogramManager.sharedInstance.updateEthograms(loadedEthogramMng!.ethograms)
        }
    }
    
    /// Login to server using Facebook token asynchronously.
    /// Will set user and accessToken upon successful login.
    func loginToServerUsingFacebookToken(
        facebookToken: String,
        onCompletion: (() -> ())?) {
            
        loginToServerWithSocialLogin("facebook", withToken: facebookToken, onCompletion: onCompletion)
        _authProvider = .Facebook
    }
    
    /// Login to server using Google token asynchronously.
    /// Will set user and accessToken upon successful login.
    func loginToServerUsingGoogleToken(
        googleToken: String,
        onCompletion: (() -> ())?) {
            
        loginToServerWithSocialLogin("google", withToken: googleToken, onCompletion: onCompletion)
        _authProvider = .Google
    }
    
    
    /// [Async] Login to server using the specified OAuth social login provider,
    /// and the corresponding OAuth token from the specified provider.
    /// Will set _user and _accessToken upon successful login.
    /// This function runs asynchronously on network queue and will immediately return.
    private func loginToServerWithSocialLogin(
        provider: String,
        withToken token: String,
        onCompletion: (() -> ())?) {
            
        dispatch_async(CloudStorage.networkThread, {
            let destinationUrl = NSURL(string: Constants.WebServer.serverUrl)!
                .URLByAppendingPathComponent("auth")
                .URLByAppendingPathComponent(provider)
                .URLByAppendingSlash()
            var postDictionary = NSMutableDictionary()
            postDictionary.setValue(token, forKey: "access_token")
            let postData = CloudStorage.dictionaryToJsonData(postDictionary)
            let responseData = CloudStorage.makeRequestToUrl(destinationUrl, withMethod: "POST", withPayload: postData)
            if responseData == nil { return }
            let responseDictionary = CloudStorage.readFromJsonAsDictionary(responseData!)!
            let serverToken = responseDictionary["key"] as! String
            self._accessToken = serverToken
            self.getCurrentUserFromServer()
            let user = self.user
            assert(user != User(name: "Default", email: "Default"), "Token is not accepted by server")
            onCompletion?()
        })
    }
    

    /// [Async] Gets the currently logged in user information from server. The server
    /// will deduce the currently logged in user from the access token sent in
    /// HTTP Header. If the token is not accepted, this function will return nil.
    private func getCurrentUserFromServer() {
        dispatch_async(CloudStorage.networkThread, {
            if self.accessToken == nil {
                self.tryLoadTokenFromDisk()
            }
            let destinationUrl = NSURL(string: Constants.WebServer.serverUrl)!
                .URLByAppendingPathComponent("auth")
                .URLByAppendingPathComponent("current_user")
                .URLByAppendingSlash()
            let responseData = CloudStorage.makeRequestToUrl(destinationUrl, withMethod: "GET", withPayload: nil)
            assert(responseData != nil, "No response from server")
            let responseDictionary = CloudStorage.readFromJsonAsDictionary(responseData!)
            assert(responseDictionary != nil, "Error parsing JSON")
            if let id = responseDictionary!["id"] as? Int {
                self._user = User(dictionary: responseDictionary!)
                self.trySaveTokenToDisk()
                self.initialiseManagers()
            }
        })
    }
    
    func handleLogOut() {
        deleteTokenFromDisk()
    }
    
    private func trySaveTokenToDisk() {
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        if let token = _accessToken {
            if let dir = dirs?[0] {
                let path = dir.stringByAppendingPathComponent("servertoken")
                let success = token.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
                if success {
                    saveUserToDisk()
                }
            }
        }
    }
    
    private func tryLoadTokenFromDisk() {
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        if let dir = dirs?[0] {
            let path = dir.stringByAppendingPathComponent("servertoken")
            if let token = NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil) {
                let userDataIsAvailable = loadUserFromDisk()
                if userDataIsAvailable {
                    _accessToken = token as String
                }
            }
        }
    }
    
    private func deleteTokenFromDisk() {
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        if let dir = dirs?[0] {
            let path = dir.stringByAppendingPathComponent("servertoken")
            let fileManager = NSFileManager.defaultManager()
            if fileManager.fileExistsAtPath(path) {
                let success = fileManager.removeItemAtPath(path, error: nil)
                if success {
                    deleteUserFromDisk()
                }
            }
        }
    }
    
    private func saveUserToDisk() {
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        
        if let dir = dirs?[0] {
            let path = dir.stringByAppendingPathComponent("current_user")
            let success = NSKeyedArchiver.archiveRootObject(user, toFile: path)
        }
    }
    
    private func loadUserFromDisk() -> Bool {
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        if let dir = dirs?[0] {
            let path = dir.stringByAppendingPathComponent("current_user")
            let user = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? User
            if user == nil {
                return false
            } else {
                _user = user!
                return true
            }
        }
        return false
    }
    
    private func deleteUserFromDisk() {
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        if let dir = dirs?[0] {
            let path = dir.stringByAppendingPathComponent("current_user")
            let fileManager = NSFileManager.defaultManager()
            if fileManager.fileExistsAtPath(path) {
                let success = fileManager.removeItemAtPath(path, error: nil)
            }
        }
    }
    
}