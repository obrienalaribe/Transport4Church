//
//  RideData.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 10/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

//

import Parse

class Trip : PFObject, PFSubclassing  {
    var rider: Rider {
        //set rider on parse
        get { return objectForKey(Rider.parseClassName()) as! Rider }
        set {setObject(newValue, forKey: Rider.parseClassName())}
    }
    
    var status : TripStatus {
        get { return TripStatus.reverse(objectForKey("status") as! String)!}
        set { self["status"] = newValue.rawValue }
    }
    
    var extraRiders : Int = 0
    
    //only set destination on this object then Rider will have location
    @NSManaged var destination : PFGeoPoint

    var pickupTime : NSDate {
        get { return Helper.convertStringToDate(objectForKey("pickup_time" ) as! String)}
        set { setObject(Helper.convertDateToString(newValue), forKey: "pickup_time") }
    }

    override class func initialize() {
        struct Static {
            static var onceToken: dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
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
    
    static func reverse(status: String) -> TripStatus? {
        switch(status){
            case "New" :
                return .NEW
                break
            case "Requested" :
                return .REQUESTED
                break
            case "Accepted" :
                return .ACCEPTED
                break
            case "Cancelled" :
                return .CANCELLED
                break
            case "Started" :
                return .STARTED
                break
            case "Completed" :
                return .COMPLETED
                break            
            default:
                return nil
           
        }
        
    }
}