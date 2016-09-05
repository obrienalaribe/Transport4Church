//
//  Rider.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 15/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import Foundation

//TODO: should extend user and only have location 
class Rider  {
    var location : Address
    var destination : Address
    
    init(location: Address, destination: Address){
        self.location = location
        self.destination = destination
    }

}
