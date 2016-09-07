//
//  Rider.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 15/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import Parse

class Rider : PFObject, PFSubclassing  {
    var location : Address
    var destination : Address
    @NSManaged var userDetails : PFUser
    

    init(location: Address, destination: Address){
        self.location = location
        self.destination = destination
        super.init()
        self.userDetails = PFUser.currentUser()!
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
        return "Rider"
    }

}
