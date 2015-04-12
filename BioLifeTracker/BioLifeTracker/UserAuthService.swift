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
    
    func useDefaultUser() {
        initialiseManagers()
    }
    
    func setUserAuth(user: User, accessToken: String) {
        self._user = user
        self._accessToken = accessToken
        initialiseManagers()
    }
    
    private func initialiseManagers() {
        let loadedProjectMng = ProjectManager.loadFromArchives(UserAuthService.sharedInstance.user.toString()) as! ProjectManager?
        if loadedProjectMng != nil {
            ProjectManager.sharedInstance.updateProjects(loadedProjectMng!.projects)
        }
        
        let loadedEthogramMng = EthogramManager.loadFromArchives(UserAuthService.sharedInstance.user.toString()) as! EthogramManager?
        if loadedEthogramMng != nil {
            EthogramManager.sharedInstance.updateEthograms(loadedEthogramMng!.ethograms)
        }
    }
    
    /// Login to server using Facebook token asynchronously.
    /// Will set user and accessToken upon successful login.
    func loginToServerUsingFacebookToken(facebookToken: String) {
        loginToServerWithSocialLogin("facebook", withToken: facebookToken)
        _authProvider = .Facebook
    }
    
    /// Login to server using Google token asynchronously.
    /// Will set user and accessToken upon successful login.
    func loginToServerUsingGoogleToken(googleToken: String) {
        loginToServerWithSocialLogin("google", withToken: googleToken)
        _authProvider = .Google
    }
    
    /// Login to server using the specified OAuth social login provider,
    /// and the corresponding OAuth token from the specified provider.
    /// Will set _user and _accessToken upon successful login.
    /// This function runs asynchronously on network queue and will immediately return.
    private func loginToServerWithSocialLogin(provider: String, withToken token: String) {
        dispatch_async(CloudStorage.networkThread, {
            let destinationUrl = NSURL(string: Constants.WebServer.serverUrl)!
                .URLByAppendingPathComponent("auth")
                .URLByAppendingPathComponent(provider)
                .URLByAppendingSlash()
            var postDictionary = NSMutableDictionary()
            postDictionary.setValue(token, forKey: "access_token")
            let postData = CloudStorage.dictionaryToData(postDictionary)
            let responseData = CloudStorage.makeRequestToUrl(destinationUrl, withMethod: "POST", withPayload: postData)
            assert(responseData != nil, "The server rejects the \(provider) token. This shouldn't happen.")
            let responseDictionary = CloudStorage.readFromJsonAsDictionary(responseData!)!
            let serverToken = responseDictionary["key"] as! String
            self._accessToken = serverToken
            let user = self.getCurrentUserFromServer()
            assert(user != nil, "Token is not accepted by server")
            self._user = user!
        })
    }
    
    /// Gets the currently logged in user information from server. The server
    /// will deduce the currently logged in user from the access token sent in
    /// HTTP Header. If the token is not accepted, this function will return nil.
    func getCurrentUserFromServer() -> User? {
        let destinationUrl = NSURL(string: Constants.WebServer.serverUrl)!
            .URLByAppendingPathComponent("auth")
            .URLByAppendingPathComponent("current_user")
            .URLByAppendingSlash()
        let responseData = CloudStorage.makeRequestToUrl(destinationUrl, withMethod: "GET", withPayload: nil)
        assert(responseData != nil, "No response from server")
        let responseDictionary = CloudStorage.readFromJsonAsDictionary(responseData!)
        assert(responseDictionary != nil, "Error parsing JSON")
        if responseDictionary!["id"] == nil {
            return nil
        } else {
            return User(dictionary: responseDictionary!)
        }
    }
}