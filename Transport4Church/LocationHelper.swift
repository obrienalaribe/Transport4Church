//
//  LocationHelper.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 16/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import Foundation

var locationDispatchGroup = dispatch_group_create()

class LocationHelper {
   
    var result : [String] = [String]()
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) -> Void {
        let geocoder = GMSGeocoder()
        
        dispatch_group_enter(locationDispatchGroup)

        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                self.result = address.lines!
                dispatch_group_leave(locationDispatchGroup)

            }
        }
    }

}

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}