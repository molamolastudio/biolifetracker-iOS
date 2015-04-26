//
//  BLTProjectDeserializer.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 14/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

/// This class deserializes the projects sent from other 
/// applications using the BioLifeTracker framework.
class BLTProjectDeserializer {
    
    var pendingProject: Project?
    
    init() {}
    
    /// This function should receive a file url indicating where an encoded
    /// project has been stored. It should read the file, construct a Project
    /// object with all its hierarcy (sessions, behaviours, etc.) and return
    /// the constructed project hierarcy upon completion.
    func process(url: NSURL) -> Project? {
        if let data = readDataFromUrl(url) {
            if let dictionary = readFromJsonAsDictionary(data) {
                let project = Project(dictionary: dictionary, recursive: true)
                changeProjectOwnership(project)
                return project
            }
        }
        return nil
    }
    
    func readDataFromUrl(url: NSURL) -> NSData? {
        var readingError: NSError?
        let data = NSData(contentsOfURL: url,
            options: nil,
            error: &readingError)
        if readingError != nil {
            NSLog("Error reading data: %@", readingError!.localizedDescription)
            return nil
        }
        return data
    }
    
    /// Deserializes a JSON data into NSDictionary.
    /// Will return the corresponding NSDictionary if successful.
    /// Otherwise, returns nil.
    func readFromJsonAsDictionary(data: NSData) -> NSDictionary? {
        var readingError: NSError?
        var dictionary = NSJSONSerialization.JSONObjectWithData(data,
            options: NSJSONReadingOptions(0),
            error: &readingError) as? NSDictionary
        if readingError != nil {
            NSLog("JSON Reading Error: %@", readingError!.localizedDescription)
            return nil
        }
        return dictionary
    }
    
    /// Modifies the project's createdBy and updatedBy property of the project
    /// and its object tree to follow the currently logged in user.
    func changeProjectOwnership(project: Project) {
        let currentUser = UserAuthService.sharedInstance.user
        let admins = project.admins
        admins.map { project.removeAdmin($0) }
        let members = project.members
        members.map { project.removeMember($0) }
        project.addAdmin(currentUser)
        project.addMember(currentUser)
        var stack = [CloudStorable]()
        stack.append(project)
        while !stack.isEmpty {
            let cloudItem = stack.removeLast()
            if let modelItem = cloudItem as? BiolifeModel {
                modelItem.changeCreator(currentUser)
                modelItem.updateInfo(updatedBy: currentUser, updatedAt: NSDate())
            }
            cloudItem.getDependencies().map { stack.append($0) }
        }
        
    }

}