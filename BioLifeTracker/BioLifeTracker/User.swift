//
//  User.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 10/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class User: NSObject {
    var id: String          // Use email or object id
    var name: String
    
    //        println("User: \(user)")
    //        println("User ID: \(user.objectID)")
    //        println("User Name: \(user.name)")
    //        var userEmail = user.objectForKey("email") as String
    //        println("User Email: \(userEmail)")
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}