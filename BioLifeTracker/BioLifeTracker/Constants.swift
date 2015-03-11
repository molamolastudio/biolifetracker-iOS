//
//  Constants.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

struct Constants {
    
    enum CellType {
        case TextOneLine
        case TextTwoLines
        case TextMultipleLines
        case Media
        case ColorPicker
    }
    
    struct FormData {
        struct Project {
            static let labels = ["Name", "", ""]
            static let cells = [CellType.TextOneLine]
        }
    }
    
    struct CodePrefixes {
        static let project = "P"
        static let ethogram = "E"
        static let session = "S"
    }
    
    struct Default {
        static let userName = "Default User"
        static let ethogramName = "Default ethogram"
        static let projectName = "Activity Pattern"
        static let animalName = "Animal"
        
        static let ethogramCode = "E999"
    }
    
    struct Table {
        static let rowHeight: CGFloat = 44
    }
}
