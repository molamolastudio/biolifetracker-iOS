//
//  ExportObservationsService.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 12/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class ExportObservationsService {
    var project: Project
    var plistPath: String
    static var documentInteractionVC: UIDocumentInteractionController!
    
    init(project: Project) {
        self.project = project
        self.plistPath = ""
    }
    
    private func createObservationsCSV() {
        let csvWriter = CSVWriter()
        let dateFormatter = BiolifeDateFormatter()
        
        // Write CSV Header
        let header = ["Session Name", "Behaviour State", "Information", "Timestamp", "Individual", "Location", "Weather", "Creator"]
        csvWriter.addRow(header)
        
        // Write CSV Body
        let observations = project.getObservations(project.sessions)
        for observation in observations {
            let sessionName = observation.session.getDisplayName()
            let state = observation.state.name
            let information = observation.information
            let timestamp = dateFormatter.formatDate(observation.timestamp)
            let individual = (observation.individual == nil) ? "" : observation.individual!.label
            let location: String
            if let tempLocation = observation.location {
                location = tempLocation.location
            } else {
                location = ""
            }
            let weather: String
            if let tempWeather = observation.weather {
                weather = tempWeather.weather
            } else {
                weather = ""
            }
            let creator = observation.createdBy.name
            csvWriter.addRow([sessionName, state, information, timestamp, individual, location, weather, creator])
        }
        
        // Write CSV File to disk
        let csvString = csvWriter.getResult()
        let fileManager = (NSFileManager.defaultManager())
        let directories  = NSSearchPathForDirectoriesInDomains(
            NSSearchPathDirectory.DocumentDirectory,
            NSSearchPathDomainMask.AllDomainsMask,
            true) as? [String]
    
        if let directories = directories {
            // find target directory
            let targetDirectory = directories[0]
            let plistFileName = "\(project.name).csv"
            plistPath = targetDirectory
                .stringByAppendingPathComponent(plistFileName)
            
            // delete item with the same file name
            let fileManager = NSFileManager.defaultManager()
            if fileManager.fileExistsAtPath(plistPath) {
                fileManager.removeItemAtPath(plistPath, error: nil)
            }
            
            // write csv to disk
            csvString.writeToFile(plistPath, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        }
    }
    
    func openInOtherApps(button: UIBarButtonItem) {
        createObservationsCSV()
        if let fileURL = NSURL.fileURLWithPath(plistPath) {
            ExportObservationsService.documentInteractionVC = UIDocumentInteractionController(URL: fileURL)
            ExportObservationsService.documentInteractionVC.UTI = "public.comma-separated-values-text"
            ExportObservationsService.documentInteractionVC.presentOpenInMenuFromBarButtonItem(button, animated: true)
        }
    }
}


// In case you need test case:
//        let state1 = BehaviourState(name: "Feeding", information: "Small claws bringing food to mouth")
//        let state2 = BehaviourState(name: "Fighting", information: "Engagement of large clawa with another crab")
//        var ethogram = Ethogram(name: "Fiddler Crabs")
//        ethogram.addBehaviourState(state1)
//        ethogram.addBehaviourState(state2)
//
//        let project = Project(name: "A Day in a Fiddler Crab life", ethogram: ethogram)
//
//        let session = Session(project: project, name: "Session1", type: SessionType.Scan)
//        let individual = Individual(label: "M1")
//
//        let observation1 = Observation(session: session, individual: individual, state: state1, timestamp: NSDate(), information: "Eating vigourously")
//        let observation2 = Observation(session: session, individual: individual, state: state2, timestamp: NSDate(), information: "Eating vigourously")
//        session.addObservation([observation1, observation2])
//        project.addSessions([session])
//
//        var example = ExportObservationsService(project: project)
//        example.createObservationsCSV()
//        example.openInOtherApps(self)

