//
//  ProjectManagers.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 5/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class ProjectManager: NSObject, Storable {
    private var _projects: [Project] = []
    
    var projects: [Project] { get { return _projects } }
    
    override init() {
        _projects = []
        super.init()
    }
    
    class var sharedInstance: ProjectManager {
        struct Singleton {
            static let instance = ProjectManager()
        }
        return Singleton.instance
    }
    
    func updateProjects(projects: [Project]) {
        self._projects = projects
        saveToArchives()
    }
    
    func addProject(project: Project) {
        var isReplace = false
        for (var i = 0; i < _projects.count; i++) {
            if _projects[i].id == project.id {
                _projects[i] = project
                isReplace = true
                break
            }
        }
        if !isReplace {
            self._projects.append(project)
        }
        saveToArchives()
    }
    
    func updateProject(index: Int, project: Project) {
        self._projects.removeAtIndex(index)
        self._projects.insert(project, atIndex: index)
    }
    
    func removeProjects(indexes: [Int]) {
        var decreasingIndexes = sorted(indexes) { $0 > $1 } // sort indexes in non-increasing order
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
    
    // For testing.
    func clearProjects() {
        self._projects = [Project]()
        saveToArchives()
    }
    
    // Returns true if the given ethogram is being used in a project.
    func isEthogramInProjects(ethogram: Ethogram) -> Bool {
        for p in ProjectManager.sharedInstance.projects {
            if p.ethogram == ethogram {
                return true
            }
        }
        return false
    }
    
    /**************Saving to Archives****************/
    func saveToArchives() {
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        
        if ((dirs) != nil) {
            let dir = dirs![0]; //documents directory
            let path = dir.stringByAppendingPathComponent("Existing projects of" + String(UserAuthService.sharedInstance.user.id))
            
            let data = NSMutableData();
            let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
            archiver.encodeObject(self, forKey: "projects")
            archiver.finishEncoding()
            let success = data.writeToFile(path, atomically: true)
        }
    }
    
    class func loadFromArchives(identifier: String) -> NSObject? {
        
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        
        if (dirs == nil) {
            return nil
        }
        
        // documents directory
        let dir = dirs![0]
        let path = dir.stringByAppendingPathComponent("Existing projects of" + identifier)
        let data = NSMutableData(contentsOfFile: path)
        
        if data == nil {
            return nil
        }
        
        let archiver = NSKeyedUnarchiver(forReadingWithData: data!)
        var projectManager = archiver.decodeObjectForKey("projects") as? ProjectManager
        
        return projectManager
    }
    
    class func deleteFromArchives(identifier: String) -> Bool {
        // Cannot delete user projects
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        
        if (dirs == nil) {
            return false
        }
        
        // documents directory
        let dir = dirs![0]
        let path = dir.stringByAppendingPathComponent("Existing projects of" + identifier)
        
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
        
        let objectProjects: AnyObject = aDecoder.decodeObjectForKey("projects")!
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
    
    func handleLogOut() {
        // Please do anything to manage user data here
        ProjectManager.deleteFromArchives(String(UserAuthService.sharedInstance.user.id))
        ProjectManager.sharedInstance._projects = [] 
    }
    
    func hasProjectWithId(id: Int) -> Bool {
        for project in projects {
            if project.id == id {
                return true
            }
        }
        return false
    }
}

extension ProjectManager: NSCoding {
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(_projects, forKey: "projects")
    }
}
