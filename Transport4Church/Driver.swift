//
//  Driver.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 15/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import Foundation

class Driver : CustomStringConvertible {
    
    var currentLocation : Address?
    var destination : Address?
    var userDetails: User?
//    
//    init(currentLocation: Address?, destination: Address?, userDetails: User?) {
//        self.currentLocation = currentLocation
//        self.destination = destination
//        self.userDetails = userDetails
//    }
//    
    var description : String {
        return "current: \(currentLocation) dest: \(destination), User: \(userDetails)"
    }
    
}


