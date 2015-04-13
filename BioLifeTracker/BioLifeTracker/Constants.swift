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
    
    struct ViewTags {
        static let projectsCellTitle = 100
        static let projectsCellSubtitle = 101
        static let ethogramFormNameField = 200
        static let ethogramFormCodeField = 201
        static let ethogramFormCellFullTextField = 202
        static let pickerCellLabel = 300
        static let ethogramsCellTitle = 400
        static let ethogramsCellSubtitle = 401
        static let ethogramDetailTitle = 402
        static let ethogramDetailLabel = 403
        static let ethogramDetailState = 404
    }
    
    struct WebServer {
        static let serverUrl: String = "http://localhost:8000"
    }
}
