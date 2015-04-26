//
//  ExportObservationsService.swift
//  BioLifeTracker
//
//  Created by Li Jia'En, Nicholette on 12/4/15.
//  Maintained by Andhieka Putra.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

/// This class exports the project's observations in CSV file format,
/// which can be opened in Microsoft Excel.
class ExportObservationsService {
    var project: Project
    var plistPath: String
    static var documentInteractionVC: UIDocumentInteractionController!
    
    init(project: Project) {
        self.project = project
        self.plistPath = ""
    }
    
    func openInOtherApps(button: UIBarButtonItem) {
        startWritingCSVToDisk()
        if let fileURL = NSURL.fileURLWithPath(plistPath) {
            ExportObservationsService.documentInteractionVC =
                                        UIDocumentInteractionController(URL: fileURL)
            ExportObservationsService.documentInteractionVC.UTI =
                                        "public.comma-separated-values-text"
            ExportObservationsService.documentInteractionVC.presentOpenInMenuFromBarButtonItem(
                                                                            button, animated: true)
        }
    }
    
    /// [Semi-Async]
    /// Effect: plistPath will be updated after this method returns.
    /// Async-effect: some time after this function returns, the CSV document
    /// will be written to file at plistPath.
    private func startWritingCSVToDisk() {
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
            
            // Asynchronously generate CSV and write file to the specified directory
            let dispatchQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
            dispatch_async(dispatchQueue, {
                let csvString = self.generateCSV()
                csvString.writeToFile(self.plistPath, atomically: true,
                                        encoding: NSUTF8StringEncoding, error: nil)
            })
        }
    }
    
    private func generateCSV() -> String {
        let csvWriter = CSVWriter()
        let dateFormatter = BiolifeDateFormatter()
        
        // Write CSV Header
        let header = ["Session Name", "Behaviour State", "Information",
                        "Timestamp", "Individual", "Location", "Weather", "Creator"]
        csvWriter.addRow(header)
        
        // Write CSV Body
        let observations = project.getObservations(project.sessions)
        for observation in observations {
            let sessionName = observation.session.getDisplayName()
            let state = observation.state.name
            let information = observation.information
            let timestamp = dateFormatter.formatDate(observation.timestamp)
            let individual = (observation.individual == nil) ? ""
                                                    : observation.individual!.label
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
            csvWriter.addRow([sessionName, state, information, timestamp,
                                            individual, location, weather, creator])
        }
        return csvWriter.getResult()
    }
}

