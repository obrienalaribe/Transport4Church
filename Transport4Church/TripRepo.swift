//
//  RequestRepo.swift
//  Transport4Church
//
//  Created by mac on 8/22/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import Parse

class TripRepo {
        
    func fetchAllPickupRequests(_ view : DriverRequestListController, tripStatus: TripStatus){
        
        let tripDestination = PFGeoPoint.init(latitude: EFA_Coord.latitude, longitude: EFA_Coord.longitude)
        
        let query = PFQuery(className:"Trip")
        query.whereKey("destination", equalTo: tripDestination)
        query.whereKey("status", equalTo: tripStatus.rawValue)
        query.includeKey("Rider")
        query.includeKey("User")
        query.addDescendingOrder("pickup_time")
        query.cachePolicy = .cacheThenNetwork
        query.order(byAscending: "pickup_time")
        query.limit = 100
        

        print("making request")
        
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully refreshed \(objects?.count) object.")
                pickupRequests = objects as? [Trip]
                view.collectionView?.reloadData()
                
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        }

    }
}
