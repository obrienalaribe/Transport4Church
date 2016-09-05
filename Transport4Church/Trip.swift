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

class Trip {
    var rider: Rider
    var driver: Driver?
    var status: TripStatus = TripStatus.NEW
    var extraRiders : Int = 0
    var pickupTime : NSDate?
    
    init (rider: Rider) {
        self.rider = rider
    }
}

class TripRequest : PFObject, PFSubclassing {
    // MARK: - PFSubclassing
    @NSManaged var pickupLocation : PFGeoPoint
    @NSManaged var rider: PFUser
    var time : NSDate {
        get {return convertStringToDate(objectForKey("pickup_time") as! String)}
        set { setObject(convertDateToString(newValue), forKey: "pickup_time") }
    }
    
    var status : String {
        get {return objectForKey("status") as! String}
        set { self["status"] = newValue }
    }

    
    override class func initialize() {
        struct Static {
            static var onceToken: dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    override init(){
        super.init()
        self.rider = PFUser.currentUser()!
    }

    
    private func convertDateToString(date : NSDate) -> String{
        // format the NSDate to a NSString
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "cccc, MMM d, hh:mm aa"
        let dateString = dateFormat.stringFromDate(date)
        return dateString
    }
    
    
    
    private func convertStringToDate (date : String) -> NSDate{
        // format the NSDate to a NSString
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        var dateFromString = NSDate()
        dateFromString = dateFormatter.dateFromString(date)!
        return dateFromString
    }
    
    static func parseClassName() -> String {
        return "Trip"
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