//
//  RequestRepo.swift
//  Transport4Church
//
//  Created by mac on 8/22/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import Parse

var tripRepoGroup = dispatch_group_create()

class TripRepo {
    
    var result = [Trip]()
    
    func fetchAllPickupRequests(location: CLLocationCoordinate2D) -> [Trip]{
        
        
        let tripDestination = PFGeoPoint.init(latitude: location.latitude, longitude: location.longitude)

        let query = PFQuery(className:"Trip")
        query.whereKey("destination", equalTo: tripDestination)
        query.includeKey("Rider")
        query.includeKey("User")

        dispatch_group_enter(tripRepoGroup)

        print("making request")

        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects?.count) object.")
                self.result = objects as! [Trip]
               
                dispatch_group_leave(tripRepoGroup)

            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        return result
    }
}
