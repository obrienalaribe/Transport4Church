//
//  Address.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 15/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import Foundation

class Address : CustomStringConvertible {
    
    var streetName : String? = nil
    var city : String? = nil
    var postcode: String? = nil
    var coordinate: CLLocationCoordinate2D
    var country : String? = nil
//
//    init(streetName : String?, city: String?, postcode: String){
//        self.streetName = streetName
//        self.city = city
//        self.postcode = postcode
//    }
//    
    
    init(coordinate:CLLocationCoordinate2D ) {
        self.coordinate = coordinate
        let helper : LocationHelper = LocationHelper()
        helper.reverseGeocodeCoordinate(coordinate)
        
        dispatch_group_notify(locationDispatchGroup, dispatch_get_main_queue(), {
            self.updateProperties(helper.result)
        })
    }
    
    func updateProperties(result: [String]){
        self.streetName = result[0]
        var addressArr = result[1].characters.split{$0 == " "}.map(String.init)
        self.country = addressArr.removeLast() //pop region
        
        if addressArr.count >= 2 {
            self.city = addressArr.removeFirst() //pop city
            let postcode = addressArr.joinWithSeparator(" ") //join remaining index to string
            self.postcode = postcode.substringToIndex(postcode.endIndex.predecessor()) //remove comma at end index
        }else{
            self.city = nil
            self.postcode = nil
        }
               
    }
    
    var description : String {
        return "[Address [Street:\(streetName)], City: [\(city)], Coord: [\(coordinate)]] \n"
    }
}

