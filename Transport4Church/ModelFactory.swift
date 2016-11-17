//
//  ModelFactory.swift
//  Transport4Church
//
//  Created by mac on 11/17/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import Foundation


class ModelFactory {
    static func makeTrip() -> Trip  {
        let testTrip = Trip()
        testTrip.rider = Rider()
        testTrip.rider.address = Address(result: ["2323","2323","2323"], coordinate: CLLocationCoordinate2DMake(34.4, 23.23))
        let church =  Church()
        church.objectId = "dfdf"
        testTrip.destination = church
        testTrip.pickupTime = Date()
        return testTrip
    }
}
