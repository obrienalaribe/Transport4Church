//
//  RideData.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 10/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

//
////TODO: Subclass PFObject and include destination

import Parse

class Trip : PFObject, PFSubclassing {
    var rider: Rider
    var driver: Driver?
    var status: TripStatus = TripStatus.NEW
    var extraRiders : Int = 0
    var pickupTime : NSDate?
    
    init (rider: Rider) {
        self.rider = rider
        super.init()
    }

    static func parseClassName() -> String {
        return "Trip"
    }
}

class Tester : PFObject, PFSubclassing {
    @NSManaged var displayName: String

    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }

    static func parseClassName() -> String {
        return "Tester"
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