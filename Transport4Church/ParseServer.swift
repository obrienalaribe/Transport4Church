//
//  ParseServer.swift
//  Transport4Church
//
//  Created by mac on 8/20/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import Parse

var fakeTrips : [Trip] = [Trip]()

class ParseServer {
    init(){
        registerSubClasses()
        configureServer()
    }
    
    func registerSubClasses(){
        Rider.registerSubclass()
        Trip.registerSubclass()
       
    }
    
    func configureServer(){
        Parse.enableLocalDatastore()
        
        let parseConfiguration = ParseClientConfiguration(block: { (ParseMutableClientConfiguration) -> Void in
            ParseMutableClientConfiguration.applicationId = "myAppId"
            ParseMutableClientConfiguration.clientKey = "myMasterKey"
            ParseMutableClientConfiguration.server = "https://insta231.herokuapp.com/parse"
        })
        
        Parse.initializeWithConfiguration(parseConfiguration)
        
        TestRepo.sendTest()
        
    }
    
    func createTripRequests(){
//        var user = PFUser.currentUser()
//
//        let trip = PFObject(className: "Trip")
//        trip["rider"] = user
//        trip["pickup_time"] = NSDate()
//        trip["status"] = TripStatus.NEW.rawValue
//        trip["destination"] = PFGeoPoint(latitude:EFA_Coord.latitude, longitude:EFA_Coord.longitude)
//        
//        trip.saveInBackgroundWithBlock { (success, error) -> Void in
//            print("Trip has been saved.")
//        }
//        
        
        for index in 0...10 {
           
            let rider = Rider(location: Address(coordinate: EFA_Coord), destination: Address(coordinate: EFA_Coord))
            
            let trip = Trip(rider: rider)
            trip.pickupTime = NSDate().dateByAddingTimeInterval(-Double(index) * 60)
            
            fakeTrips.append(trip)
            
         }
        
        let rider = Rider(location: Address(coordinate: EFA_Coord), destination: Address(coordinate: EFA_Coord))
        
        let trip = Trip(rider: rider)
        trip.pickupTime = NSDate().dateByAddingTimeInterval(-Double(1) * 60)
        
        fakeTrips.append(trip)
        
      
    }
}