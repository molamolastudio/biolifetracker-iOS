//
//  ExportObservationsService.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 12/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class ExportObservationsServices {
    var project: Project
    var plistPath: String
    
    init(project: Project) {
        self.project = project
        self.plistPath = ""
    }
    
    func createObservationsCSV() {
        let csvWriter = CSVWriter()
        let dateFormatter = BiolifeDateFormatter()
        
        // Write CSV Header
        let header = ["Session Name", "Information", "Timestamp", "Individual", "Location", "Weather"]
        csvWriter.addRow(header)
        
        // Write CSV Body
        let observations = project.getObservations(project.sessions)
        for observation in observations {
            let sessionName = observation.session.getDisplayName()
            let information = observation.information
            let timestamp = dateFormatter.formatDate(observation.timestamp)
            let individual = observation.individual.label
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
            csvWriter.addRow([sessionName, information, information, timestamp, individual, location, weather])
        }
        
        // Write CSV File to disk
        let csvString = csvWriter.getResult()
        let fileManager = (NSFileManager.defaultManager())
        let directories  = NSSearchPathForDirectoriesInDomains(
            NSSearchPathDirectory.DocumentDirectory,
            NSSearchPathDomainMask.AllDomainsMask,
            true) as? [String]
    
        if let directories = directories {
            let targetDirectory = directories[0]
            let plistFileName = "\(project.name).csv"
            plistPath = targetDirectory
                .stringByAppendingPathComponent(plistFileName)
                .stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            plistPath = plistPath.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            csvString.writeToFile(plistPath, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        }
    }
    
    func openInOtherApps(vc: UIViewController) {
        if let fileURL = NSURL.fileURLWithPath(plistPath) {
            let docuVC = UIDocumentInteractionController(URL: fileURL)
            docuVC.UTI = "public.comma-separated-values-text"
            docuVC.presentOptionsMenuFromRect(CGRectZero, inView: vc.view, animated: true)
        }
    }

}