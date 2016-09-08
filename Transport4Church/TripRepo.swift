//
//  RequestRepo.swift
//  Transport4Church
//
//  Created by mac on 8/22/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import Parse

class TripRepo {
    
    static func fetchAllPickupRequests(location: CLLocationCoordinate2D) -> [Trip] {
        
    
        let tripDestination = PFGeoPoint.init(latitude: location.latitude, longitude: location.longitude)

        var query = PFQuery(className:"Trip")
        query.whereKey("pickupLocation", nearGeoPoint: tripDestination)
        query.limit = 10
        
        var result : [Trip] = [Trip]()
        
        do {
            result = try query.findObjects() as! [Trip]

        }catch _ {
            
        }
        
        print(result)
        
        return result
    }
}

class TestRepo {
    
    static func sendTest(){
//        let test = Tester()
//        
//        
//        var query = PFQuery(className: Tester.parseClassName())
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [PFObject]?, error: NSError?) -> Void in
//            
//            if error == nil {
//                // The find succeeded.
//                print("Successfully retrieved \(objects!.count) .")
//                // Do something with the found objects
//                if let objects = objects {
//                    for object in objects {
//                        let test = object as! Tester
//                        print(test.displayName)
//                    }
//                }
//            } else {
//                // Log details of the failure
//                print("Error: \(error!) \(error!.userInfo)")
//            }
//        }


    }
}