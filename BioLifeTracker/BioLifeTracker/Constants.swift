//
//  Constants.swift
//  Mockups
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

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
}
