//
//  ProjectManagers.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 5/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//


import Foundation

///  This is a manager class to manage a user's Projects.
///  This class utilises the Singleton pattern to ensure that the same
///  manager instance is used throughout the application to ensure
///  consistency in the manager state.
class ProjectManager: NSObject, Storable {
    static var storageThread: dispatch_queue_t = dispatch_queue_create(
        "com.cs3217.biolifetracker.storage",
        DISPATCH_QUEUE_SERIAL)
    
    // Constants
    static let archivePrefix = "Existing projects of"
    static let projectsKey = "projects"
    
    // Private attributes
    private var _projects: [Project] = []
    
    // Accessors
    var projects: [Project] { get { return _projects } }
    
    /// This function is to initiate an instance of ProjectManager.
    override init() {
        _projects = []
        super.init()
    }
    
    /// Implementation of Singleton Pattern.
    class var sharedInstance: ProjectManager {
        struct Singleton {
            static let instance = ProjectManager()
        }
        return Singleton.instance
    }
    
    /// This function bulk updates the Projects array by overriding
    /// the existing project list with the new one.
    /// This function is meant to be used by the Cloud component to
    /// retrieve the user's existing projects in the cloud.
    func updateProjects(projects: [Project]) {
        self._projects = projects
        saveToArchives()
    }
    
    /// This function adds a Project instance to the Projects array.
    /// It detects whether a project has been updated in the cloud before
    /// and is safe to be used generically by the cloud component.
    func addProject(project: Project) {
        var isReplace = false
        if project.id != nil {
            for (var i = 0; i < _projects.count; i++) {
                if _projects[i].id == project.id {
                    _projects[i] = project
                    isReplace = true
                    break
                }
            }
        }
        if !isReplace {
            _projects.append(project)
        }
        saveToArchives()
    }
    
    /// This function updates the Project instance in the Project list
    /// and saves it to the disk.
    /// Returns true if the project is updated.
    func updateProject(index: Int, project: Project) -> Bool {
        if index >= projects.count {
            return false
        }
        
        self._projects.removeAtIndex(index)
        self._projects.insert(project, atIndex: index)
        saveToArchives()
        
        return true
    }
    
    /// This function bulk removes the Project instances in the Project
    /// list and saves the updated Projects array to disk.
    func removeProjects(indexes: [Int]) {
        // sort indexes in non-increasing order
        var decreasingIndexes = sorted(indexes) { $0 > $1 }
        var prev = -1
        for (var i = 0; i < decreasingIndexes.count; i++) {
            let index = decreasingIndexes[i]
            if prev == index {
                continue;
            } else {
                prev = index
            }
            self._projects.removeAtIndex(index)
        }
        saveToArchives()
    }
    
    /// This function clears the Projects array and saves the updated
    /// Projects array to disk.
    func clearProjects() {
        self._projects = [Project]()
        saveToArchives()
    }
    
    /// This function checks whether any Project is using a specified
    /// ethogram.
    /// Returns true if the given ethogram is being used in a project.
    func isEthogramInProjects(ethogram: Ethogram) -> Bool {
        for p in ProjectManager.sharedInstance.projects {
            if p.ethogram == ethogram {
                return true
            }
        }
        return false
    }
    
    /// This function erases the saved user projects when the user logouts.
    func handleLogOut() {
        ProjectManager.deleteFromArchives(String(
                            UserAuthService.sharedInstance.user.id))
        ProjectManager.sharedInstance._projects = [] 
    }
    
    /// This function checks whether there is an existing project with the
    /// specified id.
    /// Returns a boolean.
    func hasProjectWithId(id: Int) -> Bool {
        for project in projects {
            if project.id == id {
                return true
            }
        }
        return false
    }
    
    /// This function checks whether there is any Project using a specified
    /// ethogram.
    func hasProjectUsingEthogram(ethogram: Ethogram) -> Bool {
        for project in projects {
            if project.ethogram == ethogram {
                return true
            }
        }
        return false
    }
    
    
    // MARK: SAVING TO ARCHIVES
    
    
    /// This function asynchronously saves Projects list into local storage
    func saveToArchives() {
        dispatch_async(ProjectManager.storageThread, {
            let dirs : [String]? = NSSearchPathForDirectoriesInDomains(
                NSSearchPathDirectory.DocumentDirectory,
                NSSearchPathDomainMask.UserDomainMask, true) as? [String]
            
            if ((dirs) != nil) {
                let dir = dirs![0]; //documents directory
                let path = dir.stringByAppendingPathComponent(
                    ProjectManager.archivePrefix +
                        String(UserAuthService.sharedInstance.user.id))
                
                let data = NSMutableData();
                let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
                archiver.encodeObject(self, forKey: ProjectManager.projectsKey)
                archiver.finishEncoding()
                let success = data.writeToFile(path, atomically: true)
            }
        })
    }
    
    /// This function loads existing Projects list from the local storage
    class func loadFromArchives(identifier: String) -> NSObject? {
        
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(
            NSSearchPathDirectory.DocumentDirectory,
            NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        
        if (dirs == nil) {
            return nil
        }
        
        // documents directory
        let dir = dirs![0]
        let path = dir.stringByAppendingPathComponent(
            ProjectManager.archivePrefix + identifier)
        let data = NSMutableData(contentsOfFile: path)
        
        if data == nil {
            return nil
        }
        
        let archiver = NSKeyedUnarchiver(forReadingWithData: data!)
        var projectManager = archiver.decodeObjectForKey(
            ProjectManager.projectsKey) as? ProjectManager
        
        return projectManager
    }
    
    /// This function deletes the existing Projects list directory in the disk
    class func deleteFromArchives(identifier: String) -> Bool {
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(
            NSSearchPathDirectory.DocumentDirectory,
            NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        
        if (dirs == nil) {
            return false
        }
        
        // documents directory
        let dir = dirs![0]
        let path = dir.stringByAppendingPathComponent(
            ProjectManager.archivePrefix + identifier)
        
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(path) {
            // Delete the file and see if it was successful
            var error: NSError?
            let success = fileManager.removeItemAtPath(path, error: &error)
            if error != nil {
                println(error)
            }
            return success;
        } else {
            return true
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        var enumerator: NSEnumerator
        
        let objectProjects: AnyObject = aDecoder.decodeObjectForKey(
            ProjectManager.projectsKey)!
        enumerator = objectProjects.objectEnumerator()
        self._projects = Array<Project>()
        while true {
            let project = enumerator.nextObject() as! Project?
            if project == nil {
                break
            } else {
                self._projects.append(project!)
            }
        }
        super.init()
    }

}

/// Implementation of NSKeyedArchival
extension ProjectManager: NSCoding {
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(_projects, forKey: ProjectManager.projectsKey)
    }
}
