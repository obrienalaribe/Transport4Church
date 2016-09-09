//
//  Rider.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 15/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import Parse

class Rider : PFObject, PFSubclassing  {
    //replace Address with PFGeopoint and only call location network worker in Confirm Controller
    var address : Address!
    @NSManaged var user : PFUser
    @NSManaged var location : PFGeoPoint
    
    override init(){
        super.init()
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
