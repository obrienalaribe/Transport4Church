//
//  Address.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 15/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import Foundation

struct Address : CustomStringConvertible {
    
    var streetName : String? = "15-17 Walter Street"
    var city : String? = "Leeds"
    var postcode: String? = "LS4 2BB"
    var geopoint: CLLocationCoordinate2D? = nil
//   
//    init(streetName : String?, city: String?, postcode: String){
//        self.streetName = streetName
//        self.city = city
//        self.postcode = postcode
//    }
//    
    var description : String {
        return "street: \(streetName), city: \(city), postcode: \(postcode)"
    }
}

