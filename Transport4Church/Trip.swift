//
//  RideData.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 10/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import Foundation

struct Trip : CustomStringConvertible {
    private var rider: Rider?
    private var driver: Driver?
    private var tripStatus: TripStatus = TripStatus.NEW
    private var extraRiders : Int = 0
    private var pickupTime : NSDate?
    
    init (rider: Rider?) {
        self.rider = rider
    }

      var description : String {
        return "Rider: \(rider)"
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