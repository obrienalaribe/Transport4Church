//
//  User.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 11/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import Foundation

//struct because parse contains current user session

//TODO: Subclass PFObject
struct User {
    var name : String
    var gender: String
    var email: String
    var role : UserRoles?
    var username : String
    var password : String
    
//
//    override var description: String {
//        return "[User [Name: \(name), Gender: \(gender), Email: \(email), Role: \(role) ]] \n"
//    }
}

enum UserRoles : String {
    case Driver = "Driver"
    case Rider = "Rider"
}