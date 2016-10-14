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
    private static var __once: () = {
            registerSubclass()
        }()
    var rider: Rider {
        //set rider on parse
        get { return object(forKey: Rider.parseClassName()) as! Rider }
        set {setObject(newValue, forKey: Rider.parseClassName())}
    }
    
    var status : TripStatus {
        get { return TripStatus.reverse(object(forKey: "status") as! String)!}
        set { self["status"] = newValue.rawValue }
    }
    
    @NSManaged var extraRiders : Int
    
    //only set destination on this object then Rider will have location
    @NSManaged var destination : PFGeoPoint

    @NSManaged var driver : PFObject?
    
    @NSManaged var pickupTime : Date

    override class func initialize() {
        struct Static {
            static var onceToken: Int = 0;
        }
        _ = Trip.__once
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
    
    static func reverse(_ status: String) -> TripStatus? {
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
