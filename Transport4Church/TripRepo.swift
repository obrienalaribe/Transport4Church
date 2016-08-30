//
//  RequestRepo.swift
//  Transport4Church
//
//  Created by mac on 8/22/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import Parse

class TripRepo {
    
    static func fetchAllPickupRequests(location: CLLocationCoordinate2D) -> [AnyObject] {
        
    
        let tripDestination = PFGeoPoint.init(latitude: EFA_Coord.latitude, longitude: EFA_Coord.longitude)

        var query = PFQuery(className:"Trip")
        query.whereKey("destination", equalTo: tripDestination)
        query.limit = 10
        
        var result : [AnyObject] = [AnyObject]()
        
        do {
            result = try query.findObjects()

        }catch _ {
            
        }
        
        print(result)
        
        return result
    }
}