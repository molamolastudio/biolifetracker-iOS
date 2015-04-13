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
    var plistpath: String
    
    init(project: Project) {
        self.project = project
        self.plistpath = ""
    }
    
    func createObservationsCSV() {
        var csvString = NSMutableString()
        
        let string = "\"Session name\",\"Information\",\"Timestamp\",\"Individual\",\"Location\",\"Weather\""
        
        csvString.appendString(string)
        
        let observations = project.getObservations(project.sessions)
        
        var sessionName: String
        var information: String
        var timestamp: NSDate
        var individual: String
        var location = ""
        var weather = ""
        
        for observation in observations {
            sessionName = observation.session.getDisplayName()
            information = observation.information
            timestamp = observation.timestamp
            individual = observation.individual.label
            if let tempLocation = observation.location {
                location = tempLocation.location
            }
            if let tempWeather = observation.weather {
                location = tempWeather.weather
            }
            
            csvString.appendString("\n\"\(sessionName)\".\"\(information)\",\"\(timestamp)\",\"\(individual)\",\"\(location)\",\"\(weather)\"")
        }

        let fileManager = (NSFileManager.defaultManager())
        let directorys : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
    
        if ((directorys) != nil) {
    
            let directories:[String] = directorys!;
            let dictionary = directories[0];
            let plistfile = "\(project.name).csv"
            plistpath = dictionary.stringByAppendingPathComponent(plistfile);
            plistpath = plistpath.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            
            println("\(plistpath)")
    
            csvString.writeToFile(plistpath, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        }
    }
    
    func openInOtherApps(vc: UIViewController) {
        if let fileURL = NSURL.fileURLWithPath(plistpath) {
            let docuVC = UIDocumentInteractionController(URL: fileURL)
            docuVC.UTI = "public.comma-separated-values-text"
            docuVC.presentOptionsMenuFromRect(CGRectZero, inView: vc.view, animated: true)
            
//            let objectsToShare = [fileURL]
//            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//            let popup = UIPopoverController(contentViewController: activityVC)
//            popup.presentPopoverFromRect(CGRectMake(100, 100, 100, 100), inView: vc.view, permittedArrowDirections: .Any, animated: true)
            
//            //New Excluded Activities Code
//            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
        
        }
    }
    
}