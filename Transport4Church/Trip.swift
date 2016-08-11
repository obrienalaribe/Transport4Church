//
//  RideData.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 10/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import Foundation

class Trip {
    private var coordinates : CLLocationCoordinate2D!
    private var address : String!
    private var postcode : String!
    private var currentRideStatus: RideStatus = RideStatus.NEW
    private var user: User?
    private var extraRiders : Int = 0
    private var destinationAddress : String?
    private var destinationCoordinates : CLLocationCoordinate2D?
    private var pickupTime : NSDate?
    
    func getCoordinates() -> CLLocationCoordinate2D {
        return coordinates
    }
    
    func setCoordinates(inputCoordinates:CLLocationCoordinate2D) -> Trip {
        self.coordinates = inputCoordinates
        return self
    }
    
    func getAddress() -> String {
        return address
    }
    
    func address(inputAddress:String) -> Trip {
        self.address = inputAddress
        return self
    }
    
    func getCurrentRideStatus() -> RideStatus {
        return self.currentRideStatus
    }
    
    func currentRideStatus(rideStatus:RideStatus) -> Trip {
        self.currentRideStatus = rideStatus
        return self
    }
    
    func getDestinationCoordinates() -> CLLocationCoordinate2D? {
        return destinationCoordinates
    }
    
    func destinationCoordinates(inputCoordinates:CLLocationCoordinate2D) -> Trip {
        self.destinationCoordinates = inputCoordinates
        return self
    }
    
    func getDestinationAddress() -> String? {
        return destinationAddress
    }
    
    func setDestinationAddress(inputAddress:String) -> Trip {
        self.destinationAddress = inputAddress
        return self
    }
}

enum RideStatus : String {
    case NEW = "New"
    case REQUESTED = "Requested"
    case ACCEPTED = "Accepted"
    case CANCELLED = "Cancelled"
    case COMPLETED = "Completed"
    case STARTED = "Started"
}