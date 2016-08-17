//
//  User.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 11/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import Foundation

//need core data for this from register
class User : CustomStringConvertible {
    var name : String?
    var gender: String?
    var email: String?
    var role : UserRoles
    
    init(name: String?, gender: String?, email: String?, role: UserRoles) {
        self.name = name
        self.gender = gender
        self.email = email
        self.role = role
    }
    
    var description: String {
        return "[User [Name: \(name), Gender: \(gender), Email: \(email), Role: \(role) ]] \n"
    }
}

enum UserRoles : String {
    case Driver = "Driver"
    case Rider = "Rider"
}