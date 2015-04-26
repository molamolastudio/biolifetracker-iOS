//
//  CSVWriter.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 14/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

/// This is a helper class to convert observation objects to
/// CSV file format.
class CSVWriter {
    var rows = [String]()
    
    func addRow(row: [String]) {
        var rowStr = "\""
        if row.count > 0 { rowStr += row[0] }
        for(var i = 1; i < row.count; i++) {
            rowStr += "\",\""
            rowStr += row[i]
        }
        rowStr += "\""
        rows.append(rowStr)
    }
    
    func getResult() -> String {
        return rows.reduce("", combine: { $0 + $1 + "\r\n" })
    }
}
