//
//  RideData.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 10/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import Parse

//TODO: Subclass PFObject and include destination
class Trip : CustomStringConvertible {
    var rider: Rider
    var driver: Driver?
    var status: TripStatus = TripStatus.NEW
    var extraRiders : Int = 0
    var pickupTime : NSDate?
    
    init (rider: Rider) {
        self.rider = rider
    }

      var description : String {
        return "[TripDetails [Rider: [\(rider)] Status: [\(status)]] \n"
    }
}

enum TripStatus : String {
    case NEW = "New"
    case REQUESTED = "Requested"
    case ACCEPTED = "Accepted"
    case CANCELLED = "Cancelled"
    case STARTED = "Started"
    case COMPLETED = "Completed"
}