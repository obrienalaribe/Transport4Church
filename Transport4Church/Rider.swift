//
//  Rider.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 15/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import Foundation

//TODO: should extend user and only have location 
class Rider : CustomStringConvertible {
    
    var location : Address
    var destination : Address
    var userDetails: User
//    
//    init(currentLocation: Address?, destination: Address?, userDetails: User?) {
//        self.currentLocation = currentLocation
//        self.destination = destination
//        self.userDetails = userDetails
//    }
    
    init(location: Address, destination: Address, userDetails: User){
        self.location = location
        self.destination = destination
        self.userDetails = userDetails
    }
    
    var description : String {
        return "[Rider [Location: [\(location)], Dest: [\(destination)], User: [\(userDetails)]] \n"
    }
    
}
