//
//  Address.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 15/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import Foundation

class Address {
    
    var streetName : String? = nil
    var city : String? = nil
    var postcode: String? = nil
    var coordinate: CLLocationCoordinate2D
    var country : String? = nil
//
//    convenience init(coordinate: CLLocationCoordinate2D, streetName : String?, city: String?, postcode: String?, country: String?){
//        self.init(coordinate: coordinate)
//        self.streetName = streetName
//        self.city = city
//        self.postcode = postcode
//        self.coordinate = coordinate
//    }
////
//    
//    init(coordinate:CLLocationCoordinate2D ) {
//        self.coordinate = coordinate
//        let helper : LocationHelper = LocationHelper()
//        helper.reverseGeocodeCoordinate(coordinate)
//        
//        dispatch_group_notify(locationDispatchGroup, dispatch_get_main_queue(), {
//            self.updateProperties(helper.result)
//        })
//    }
    
    init(result: [String], coordinate: CLLocationCoordinate2D){
        self.streetName = result[0]
        var addressArr = result[1].characters.split{$0 == " "}.map(String.init)
        self.country = addressArr.removeLast() //pop region
        self.coordinate = coordinate
        
        if addressArr.isEmpty{
            return
        }
        
        if addressArr.count >= 2 {
            self.city = addressArr.removeFirst() //pop city
            let postcode = addressArr.joinWithSeparator(" ") //join remaining index to string
            self.postcode = postcode.substringToIndex(postcode.endIndex.predecessor()) //remove comma at end index
        }else{
            //clear values to reflect new current location has no city/postcode returned from Google
            self.city = nil
            self.postcode = nil
        }
    }
  
}

