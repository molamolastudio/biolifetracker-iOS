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
    }
    
    func addProject(project: Project) {
        self._projects.append(project)
    }
    
    func updateProject(index: Int, project: Project) {
        self._projects.removeAtIndex(index)
        self._projects.insert(project, atIndex: index)
    }
    
    func removeProjects(indexes: [Int]) {
        for index in indexes {
            self._projects.removeAtIndex(index)
        }
    }
    
    // For testing.
    func clearProjects() {
        self._projects = [Project]()
        saveToArchives()
    }
    
    /**************Saving to Archives****************/
    func saveToArchives() {
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        
        if ((dirs) != nil) {
            let dir = dirs![0]; //documents directory
            let path = dir.stringByAppendingPathComponent("Existing projects of" + UserAuthService.sharedInstance.user.toString())
            
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
        var projectManager = archiver.decodeObjectForKey("projects") as! ProjectManager?
        
        return projectManager
    }
    
    class func deleteFromArchives(identifier: String) -> Bool {
        // Cannot delete user projects
        return false
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
}

extension ProjectManager: NSCoding {
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(_projects, forKey: "projects")
    }
}
